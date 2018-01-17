//
//  WZBaseListAPI.m
//  WZFMWK
//
//  Created by Walker on 2017/6/15.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "WZBaseListAPIManager.h"

static NSString *const kOriginContextKey = @"context";
static NSString *const kIsFirstPageFlagKey = @"isFirstPage";

@interface WZBaseListAPIManager ()

@property (nonatomic, assign) BOOL willLoadFirstPage;

@end

@implementation WZBaseListAPIManager

- (instancetype)init {
    NSAssert(false, @"因为暂时不希望这个类被使用，所以这里强制报错！");
    if (self = [super init]) {
        self.paramSource = self;
        self.delegate = self;
    }
    return self;
}

- (void)loadFirstPage {
    NSAssert(self.paramSource == self, @"请不要修改 %@ 的paramSource属性", self.class);
    NSAssert(self.delegate == self, @"请不要修改 %@ 的delegate属性", self.class);
    
    id context = [self.listParamSource respondsToSelector:@selector(contextForRequestNewData:)] ? [self.listParamSource contextForRequestNewData:self] : nil;
    NSDictionary *reformContext = nil;
    if (context) {
        reformContext = @{kOriginContextKey: context, kIsFirstPageFlagKey: @YES};
    } else {
        reformContext = @{kIsFirstPageFlagKey: @YES};
    }
    
    self.willLoadFirstPage = YES;
    [self loadDataWithContext:reformContext];
    self.willLoadFirstPage = NO;
}

- (void)loadNextPage {
    NSAssert(self.paramSource == self, @"请不要修改 %@ 的paramSource属性", self.class);
    NSAssert(self.delegate == self, @"请不要修改 %@ 的delegate属性", self.class);
    id context = [self.listParamSource respondsToSelector:@selector(contextForRequestMoreData:)] ? [self.listParamSource contextForRequestMoreData:self] : nil;
    NSDictionary *reformContext = nil;
    if (context) {
        reformContext = @{kOriginContextKey: context, kIsFirstPageFlagKey: @NO};
    } else {
        reformContext = @{kIsFirstPageFlagKey: @NO};
    }
    
    self.willLoadFirstPage = NO;
    [self loadDataWithContext:reformContext];
}

- (void)setParamSource:(id<WZAPIManagerParamSource>)paramSource {
    [super setParamSource:self];
}

- (void)setDelegate:(id<WZAPIManagerCallBackDelegate>)delegate {
    [super setDelegate:self];
}

#pragma mark override
- (BOOL)shouldPerformCancelledRequestsResponse:(WZOriginResponse *)response {
    return YES;
}

- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params error:(WZRequestErrorObject *__autoreleasing *)error {
    [self cancelAllRequests];
    return [super shouldCallAPIWithParams:params error:error];
}

#pragma mark WZAPIManagerConfig
- (NSString *)serviceBaseURL {
    NSAssert(false, @"%@ 必须实现 %@ 方法", self.class, NSStringFromSelector(_cmd));
    return nil;
}

- (NSString *)serviceName {
    NSAssert(false, @"%@ 必须实现 %@ 方法", self.class, NSStringFromSelector(_cmd));
    return nil;
}

- (WZRequestMethod)requestMethod {
    NSAssert(false, @"%@ 必须实现 %@ 方法", self.class, NSStringFromSelector(_cmd));
    return WZRequestMethodPOST;
}

- (NSString *)serviceDescription {
    NSAssert(false, @"%@ 必须实现 %@ 方法", self.class, NSStringFromSelector(_cmd));
    return nil;
}

#pragma mark WZAPIManagerParamSource
- (NSDictionary *)paramsForAPIManager:(WZBaseAPIManager *)manager {
    if (self.willLoadFirstPage) {
        return [self.listParamSource paramsForRequestNewData:self];
    } else {
        return [self.listParamSource paramsForRequestMoreData:self];
    }
}

#pragma mark WZAPIManagerCallBackDelegate
- (void)manager:(WZBaseAPIManager *)manager callAPIDidSuccess:(WZAPISuccessResponse *)response {
    NSDictionary *context = response.context;
    id originContext = context[kOriginContextKey];
    BOOL isFirstPageRequest = [context[kIsFirstPageFlagKey] boolValue];
    
    WZAPISuccessResponse *rightResponse = [[WZAPISuccessResponse alloc] initWithRequest:response.request requestID:response.requestID responseContent:response.responseContent context:originContext];
    if (isFirstPageRequest) {
        if ([self.listDelegate respondsToSelector:@selector(manager:requestNewDataDidSuccess:)]) {
            [self.listDelegate manager:self requestNewDataDidSuccess:rightResponse];
        }
    } else {
        if ([self.listDelegate respondsToSelector:@selector(manager:requestMoreDataDidSuccess:)]) {
            [self.listDelegate manager:self requestMoreDataDidSuccess:rightResponse];
        }
    }
}

- (void)manager:(WZBaseAPIManager *)manager callAPIDidFailed:(WZAPIFailResponse *)response {
    NSDictionary *context = response.context;
    id originContext = context[kOriginContextKey];
    BOOL isFirstPageRequest = [context[kIsFirstPageFlagKey] boolValue];
    
    WZAPIFailResponse *rightResponse = [[WZAPIFailResponse alloc] initWithRequest:response.request requestID:response.requestID error:response.error context:originContext];
    if (isFirstPageRequest) {
        if ([self.listDelegate respondsToSelector:@selector(manager:requestNewDataDidFailed:)]) {
            [self.listDelegate manager:self requestNewDataDidFailed:rightResponse];
        }
    } else {
        if ([self.listDelegate respondsToSelector:@selector(manager:requestMoreDataDidFailed:)]) {
            [self.listDelegate manager:self requestMoreDataDidFailed:rightResponse];
        }
    }
}

@end

































