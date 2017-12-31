//
//  WZRequestProxy.m
//  WZFMWK
//
//  Created by Walker on 2017/5/11.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "WZRequestProxy.h"
#import "NSURLRequest+WZParam.h"

// MARK: - WZRequestProxy
@interface WZRequestProxy ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) NSMutableDictionary *taskTable;

@end

@implementation WZRequestProxy

- (instancetype)init {
    if (self = [super init]) {
        self.sessionManager = [AFHTTPSessionManager manager];
        self.sessionManager.requestSerializer.timeoutInterval = 60;
        self.sessionManager.requestSerializer.HTTPShouldHandleCookies = NO;
        self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
        self.sessionManager.securityPolicy.allowInvalidCertificates = YES;
        self.sessionManager.securityPolicy.validatesDomainName = NO;
        
        self.taskTable = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static WZRequestProxy *proxy = nil;
    dispatch_once(&once, ^{
        proxy = [[WZRequestProxy alloc] init];
    });
    return proxy;
}

- (NSInteger)requestWithURL:(NSString *)url
              requestMethod:(WZRequestMethod)method
                     params:(NSDictionary *)params
                    success:(RequestCallback)success
                       fail:(RequestCallback)fail {
    NSAssert(url != nil, @"url can not nil");
    NSInteger requestID = kFailRequestID;
    switch (method) {
        case WZRequestMethodGET: {
            requestID =
            [self getWithURL:url
                      params:params
                     success:success
                        fail:fail];
            break;
        }
        case WZRequestMethodPOST: {
            requestID =
            [self postWithURL:url
                       params:params
                      success:success
                         fail:fail];
            break;
        }
        default:
            NSAssert(false, @"未知的request method");
            break;
    }
    return requestID;
}

// 这里的生成的request是比较简单的，未来如果需要为request设置请求头之类的操作的话，考虑创建一个request工厂类
- (NSInteger)getWithURL:(NSString *)url
                 params:(NSDictionary *)params
                success:(RequestCallback)success
                   fail:(RequestCallback)fail {
    NSMutableURLRequest *request = [self.sessionManager.requestSerializer requestWithMethod:@"GET" URLString:url parameters:params error:NULL];
    request.wz_params = params;
    NSInteger requestID = [self callAPIWithRequest:request success:success fail:fail];
    return requestID;
}

- (NSInteger)postWithURL:(NSString *)url
                  params:(NSDictionary *)params
                 success:(RequestCallback)success
                    fail:(RequestCallback)fail {
    NSMutableURLRequest *request = [self.sessionManager.requestSerializer requestWithMethod:@"POST" URLString:url parameters:params error:NULL];
    request.wz_params = params;
    NSInteger requestID = [self callAPIWithRequest:request success:success fail:fail];
    return requestID;
}

- (void)cancelRequestWithWithRequestID:(NSInteger)requestID {
    NSURLSessionDataTask *task = self.taskTable[@(requestID)];
    if (task) {
        [task cancel];
    }
    [self.taskTable removeObjectForKey:@(requestID)];
}

- (void)cancelRequestWithRequestIDList:(NSArray<NSNumber *> *)requestIDs {
    for (NSNumber *requestID in requestIDs) {
        [self cancelRequestWithWithRequestID:[requestID integerValue]];
    }
}

// MARK: private method
- (NSInteger)callAPIWithRequest:(NSURLRequest *)request success:(RequestCallback)success fail:(RequestCallback)fail {
    NSURLSessionDataTask *task = [self taskWithRequest:request success:success fail:fail];
    NSInteger requestID = [self dispatchTask:task];
    return requestID;
}

- (NSURLSessionDataTask *)taskWithRequest:(NSURLRequest *)request
                                  success:(RequestCallback)success
                                     fail:(RequestCallback)fail {
    __block NSURLSessionDataTask *task = nil;
    task = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSInteger requestID = [task taskIdentifier];
        
        [self.taskTable removeObjectForKey:@(requestID)];
        
        if (error) {
            
            WZOriginResponse *wzResponse = [[WZOriginResponse alloc] initWithRequest:request requestID:requestID responseData:responseObject error:error];
            fail ? fail(wzResponse) : nil;
            
        } else {
            WZOriginResponse *wzResponse = [[WZOriginResponse alloc] initWithRequest:request requestID:requestID responseObject:responseObject status:WZOriginResponseStatusSuccess];
            success ? success(wzResponse) : nil;
        }
    }];
    return task;
}

- (NSInteger)dispatchTask:(NSURLSessionDataTask *)task {
    NSInteger requestID = [task taskIdentifier];
    [self.taskTable setObject:task forKey:@(requestID)];
    [task resume];
    return requestID;
}

@end

// MARK: - WZRequestProxyConfigurator
@implementation WZRequestProxyConfigurator

@dynamic requestSerializer, responseSerializer, securityPolicy;

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static WZRequestProxyConfigurator *configurator = nil;
    dispatch_once(&once, ^{
        configurator = [[WZRequestProxyConfigurator alloc] init];
    });
    return configurator;
}

- (NSURLSession *)session {
    return [WZRequestProxy sharedInstance].sessionManager.session;
}

- (void)setRequestSerializer:(AFHTTPRequestSerializer *)requestSerializer {
    [WZRequestProxy sharedInstance].sessionManager.requestSerializer = requestSerializer;
}

- (AFHTTPRequestSerializer *)requestSerializer {
    return [WZRequestProxy sharedInstance].sessionManager.requestSerializer;
}

- (void)setResponseSerializer:(AFHTTPResponseSerializer *)responseSerializer {
    [WZRequestProxy sharedInstance].sessionManager.responseSerializer = responseSerializer;
}

- (AFHTTPResponseSerializer *)responseSerializer {
    return [WZRequestProxy sharedInstance].sessionManager.responseSerializer;
}

- (void)setSecurityPolicy:(AFSecurityPolicy *)securityPolicy {
    [WZRequestProxy sharedInstance].sessionManager.securityPolicy = securityPolicy;
}

- (AFSecurityPolicy *)securityPolicy {
    return [WZRequestProxy sharedInstance].sessionManager.securityPolicy;
}

@end



















