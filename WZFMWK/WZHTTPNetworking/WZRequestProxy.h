//
//  WZRequestProxy.h
//  WZFMWK
//
//  Created by Walker on 2017/5/11.
//  Copyright © 2017年 wz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "WZOriginResponse.h"
#import "WZNetworkingDefine.h"

// MARK: - WZRequestProxy
typedef void(^RequestCallback)(WZOriginResponse *response);

@interface WZRequestProxy : NSObject

+ (instancetype)sharedInstance;

- (NSInteger)requestWithURL:(NSString *)url
              requestMethod:(WZRequestMethod)method
                     params:(NSDictionary *)params
                    success:(RequestCallback)success
                       fail:(RequestCallback)fail;

- (void)cancelRequestWithWithRequestID:(NSInteger)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray<NSNumber *> *)requestIDs;

@end

// MARK: - WZRequestProxyConfigurator
@interface WZRequestProxyConfigurator : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, readonly) NSURLSession *session;

@property (nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;

@property (nonatomic, strong) AFHTTPResponseSerializer *responseSerializer;

@property (nonatomic, strong) AFSecurityPolicy *securityPolicy;

@end


















