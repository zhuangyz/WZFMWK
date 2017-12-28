//
//  WZBaseAPIManager1.m
//  WZFMWK
//
//  Created by Walker on 2017/5/17.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "WZBaseAPIManager.h"
#import "WZRequestProxy.h"
#import "WZAPILogger.h"

#pragma mark - WZBaseAPIManager
@interface WZBaseAPIManager ()

@property (nonatomic, strong) NSMutableArray<NSNumber *> *requestIDs;

@end

@implementation WZBaseAPIManager

- (instancetype)init {
    self = [super init];
    if (self) {
        NSAssert([self conformsToProtocol:@protocol(WZAPIManagerConfig)], @"%@ 必须实现 WZAPIManagerConfig 协议", self.class);
        self.child = (id<WZAPIManagerConfig>)self;
    }
    return self;
}

- (void)dealloc {
    [self cancelAllRequests];
}

#pragma mark 请求起飞和取消
- (NSInteger)loadData {
    return [self loadDataWithContext:nil];
}

- (NSInteger)loadDataWithContext:(id)context {
    NSDictionary *params = [self.paramSource paramsForAPIManager:self];
    if ([self.child respondsToSelector:@selector(reformParams:)]) {
        params = [self.child reformParams:params];
    }
    return [self _loadDataWithParams:params context:context];
}

- (NSInteger)_loadDataWithParams:(NSDictionary *)params context:(id)context {
    NSMutableDictionary *allParams = [NSMutableDictionary dictionary];
    if (params) [allParams addEntriesFromDictionary:params];
    
    NSUInteger requestID = kFailRequestID;
    WZRequestErrorObject *error = nil;
    if ([self shouldCallAPIWithParams:allParams error:&error]) {
        
        if ([self isCorrectWithParams:allParams error:&error]) {
            __block id strongContext = context;
            __weak typeof(self) weakSelf = self;
            RequestCallback successCallBack = ^(WZOriginResponse *originResponse) {
                if (!weakSelf) return;
                originResponse.context = strongContext;
                [weakSelf successOnCallingAPI:originResponse];
            };
            RequestCallback failCallBack = ^(WZOriginResponse *originResponse) {
                if (!weakSelf) return;
                originResponse.context = strongContext;
                [weakSelf failOnCallingAPI:originResponse];
            };
            
            NSString *url = [self _requestURLWithBaseURL:[self.child serviceBaseURL] serviceName:[self.child serviceName]];
            requestID = [[WZRequestProxy sharedInstance]
                         requestWithURL:url
                         requestMethod:[self.child requestMethod]
                         params:allParams
                         success:successCallBack
                         fail:failCallBack];
            [self.requestIDs addObject:@(requestID)];
            
            [WZAPILogger logRequestInfo:url
                                  params:allParams
                      serviceDescription:[self.child serviceDescription]];
            
            [self afterCallAPIWithParams:allParams];
            
        } else {
            WZAPIFailResponse *failResponse = [[WZAPIFailResponse alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self _requestURLWithBaseURL:[self.child serviceBaseURL] serviceName:[self.child serviceName]]]] requestID:kFailRequestID error:error context:context];
            [self tryPerformFailCallBack:failResponse];
        }
        
    } else {
        WZAPIFailResponse *failResponse = [[WZAPIFailResponse alloc] initWithRequest:nil requestID:kFailRequestID error:error context:context];
        [self tryPerformFailCallBack:failResponse];
    }
    return requestID;
}

- (NSString *)_requestURLWithBaseURL:(NSString *)baseURL serviceName:(NSString *)serviceName {
    return [baseURL stringByAppendingPathComponent:serviceName];
}

- (void)cancelRequestWithRequestID:(NSInteger)requestID {
    [[WZRequestProxy sharedInstance] cancelRequestWithWithRequestID:requestID];
    [self _removeRequestID:requestID];
}

- (void)cancelAllRequests {
    [[WZRequestProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIDs];
    [self.requestIDs removeAllObjects];
}

- (void)_removeRequestID:(NSUInteger)requestID {
    for (NSNumber *storeID in self.requestIDs) {
        if ([storeID unsignedIntegerValue] == requestID) {
            [self.requestIDs removeObject:storeID];
            break;
        }
    }
}

#pragma mark 请求落地回调
- (void)successOnCallingAPI:(WZOriginResponse *)response {
    [self _removeRequestID:response.requestID];
    
    WZRequestErrorObject *error = nil;
    if ([self isCorrectWithCallBackData:response error:&error]) {
        WZAPISuccessResponse *successResponse = [[WZAPISuccessResponse alloc] initWithRequest:response.request requestID:response.requestID responseContent:[self extractResponseContentFromOriginResponseContent:response.responseContent] context:response.context];
        [self tryPerformSuccessCallBack:successResponse];
        
    } else {
        WZAPIFailResponse *failResponse = [[WZAPIFailResponse alloc] initWithRequest:response.request requestID:response.requestID error:error context:response.context];
        [self tryPerformFailCallBack:failResponse];
    }
}

- (void)failOnCallingAPI:(WZOriginResponse *)response {
    [self _removeRequestID:response.requestID];
    NSAssert(response.status != WZOriginResponseStatusSuccess, @"解析发生错误！！！！");
    
    WZRequestErrorObject *error = nil;
    if (response.status == WZOriginResponseStatusErrorTimeout) {
        error = WZRequestErrorTimeoutObject;
    } else if (response.status == WZOriginResponseStatusErrorNoNetwork) {
        error = WZRequestErrorNoNetworkObject;
    } else if (response.status == WZOriginResponseStatusErrorCancel) {
        if (![self shouldPerformCancelledRequestsResponse:response]) {
            return;
        }
        error = WZRequestErrorCancelObject;
    }
    WZAPIFailResponse *failResponse = [[WZAPIFailResponse alloc] initWithRequest:response.request requestID:response.requestID error:error context:response.context];
    [self tryPerformFailCallBack:failResponse];
}

- (NSDictionary *)extractResponseContentFromOriginResponseContent:(NSDictionary *)originResponseContent {
    return originResponseContent;
}

#pragma mark 执行回调
- (void)tryPerformSuccessCallBack:(WZAPISuccessResponse *)response {
    if ([self shouldPerformSuccessWithResponse:response]) {
        [WZAPILogger logSuccessResponse:[self _requestURLWithBaseURL:[self.child serviceBaseURL] serviceName:[self.child serviceName]]
                      serviceDescription:[self.child serviceDescription]
                         responseContent:nil];
        if ([self.delegate respondsToSelector:@selector(manager:callAPIDidSuccess:)]) {
            [self.delegate manager:self callAPIDidSuccess:response];
        }
        [self afterPerformSuccessWithResponse:response];
    }
}

- (void)tryPerformFailCallBack:(WZAPIFailResponse *)response {
    if ([self shouldPerformFailWithResponse:response]) {
        [WZAPILogger logFailResponse:[self _requestURLWithBaseURL:[self.child serviceBaseURL] serviceName:[self.child serviceName]]
                   serviceDescription:[self.child serviceDescription]
                            errorCode:response.error.errorCode
                             errorMsg:response.error.errorMsg];
        if ([self.delegate respondsToSelector:@selector(manager:callAPIDidFailed:)]) {
            [self.delegate manager:self callAPIDidFailed:response];
        }
        [self afterPerformFailWithResponse:response];
    }
}

#pragma mark 验证器
- (BOOL)isCorrectWithParams:(NSDictionary *)params
                      error:(WZRequestErrorObject *__autoreleasing *)error {
    return YES;
}

- (BOOL)isCorrectWithCallBackData:(WZOriginResponse *)response
                            error:(WZRequestErrorObject *__autoreleasing *)error {
    return YES;
}

#pragma mark 拦截器
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params error:(WZRequestErrorObject **)error {
    if ([self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:error:)]) {
        return [self.interceptor manager:self shouldCallAPIWithParams:params error:error];
    }
    return YES;
}

- (void)afterCallAPIWithParams:(NSDictionary *)params {
    if ([self.interceptor respondsToSelector:@selector(manager:afterCallAPIWithParams:)]) {
        [self.interceptor manager:self afterCallAPIWithParams:params];
    }
}

- (BOOL)shouldPerformSuccessWithResponse:(WZAPISuccessResponse *)response {
    if ([self.interceptor respondsToSelector:@selector(manager:shouldPerformSuccessWithResponse:)]) {
        return [self.interceptor manager:self shouldPerformSuccessWithResponse:response];
    }
    return YES;
}

- (void)afterPerformSuccessWithResponse:(WZAPISuccessResponse *)response {
    if ([self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (BOOL)shouldPerformFailWithResponse:(WZAPIFailResponse *)response {
    if ([self.interceptor respondsToSelector:@selector(manager:shouldPerformFailWithResponse:)]) {
        return [self.interceptor manager:self shouldPerformFailWithResponse:response];
    }
    return YES;
}

- (void)afterPerformFailWithResponse:(WZAPIFailResponse *)response {
    if ([self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}

- (BOOL)shouldPerformCancelledRequestsResponse:(WZOriginResponse *)response {
    return NO;
}

#pragma mark getter
- (NSMutableArray<NSNumber *> *)requestIDs {
    if (!_requestIDs) {
        _requestIDs = [NSMutableArray array];
    }
    return _requestIDs;
}

- (BOOL)isLoading {
    return self.requestIDs.count > 0;
}

@end



























