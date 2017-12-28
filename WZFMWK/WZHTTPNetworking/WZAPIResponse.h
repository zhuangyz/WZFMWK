//
//  WZAPIResponse.h
//  WZFMWK
//
//  Created by Walker on 2017/5/17.
//  Copyright © 2017年 wz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURLRequest+WZParam.h"

static NSInteger const kRequestErrorCodeTimeout     = -1;
static NSInteger const kRequestErrorCodeNoNetwork   = -2;
static NSInteger const kRequestErrorCodeCancel      = -3;
static NSInteger const kRequestErrorCodeParamError  = -4;

#pragma mark - WZRequestErrorObject
@interface WZRequestErrorObject : NSObject

@property (nonatomic, assign, readonly) NSInteger errorCode;
@property (nonatomic, copy, readonly) NSString *errorMsg;

+ (instancetype)errorObjectWithCode:(NSInteger)code errorMsg:(NSString *)msg;

@end
#define WZRequestErrorObjectCreate(__code__, __msg__) [WZRequestErrorObject errorObjectWithCode:__code__ errorMsg:__msg__]
#define WZRequestErrorTimeoutObject WZRequestErrorObjectCreate(kRequestErrorCodeTimeout, @"请求超时，请检查网络连接")
#define WZRequestErrorNoNetworkObject WZRequestErrorObjectCreate(kRequestErrorCodeNoNetwork, @"网络连接失败，请检查网络连接")
#define WZRequestErrorCancelObject WZRequestErrorObjectCreate(kRequestErrorCodeCancel, @"请求已取消")
/*
 通常取消请求是暗地里取消的，界面的一些状态可能会变，但是一般不需要显示错误提醒文字
 */

#pragma mark - WZAPISuccessResponse
@interface WZAPISuccessResponse : NSObject

@property (nonatomic, assign, readonly) NSInteger requestID;
@property (nonatomic, copy, readonly) NSURLRequest *request; // 一般情况下都不为空。request有个wz_params的额外的属性可以使用！值为请求时的参数
@property (nonatomic, copy, readonly) NSDictionary *responseContent; // 原始数据的data字段的内容

@property (nonatomic, strong, readonly) id context; // 请求发起时调用方传入的上下文相关的附加信息，供回调处可用

- (instancetype)initWithRequest:(NSURLRequest *)request
                      requestID:(NSInteger)requestID
                responseContent:(NSDictionary *)responseContent
                        context:(id)context;

@end

#pragma mark - WZAPIFailResponse
@interface WZAPIFailResponse : NSObject

@property (nonatomic, assign, readonly) NSInteger requestID; // 被拦截掉的请求或是请求的参数验证不通过时，requestID将会是kFailRequestID
@property (nonatomic, copy, readonly) NSURLRequest *request; // request是可能为空的（请求被API拦截并阻止起飞时或是参数验证不通过时，这时候实际上是没有request的）
@property (nonatomic, strong, readonly) WZRequestErrorObject *error;

@property (nonatomic, strong, readonly) id context; // 请求发起时调用方传入的上下文相关的附加信息，供回调处可用

- (instancetype)initWithRequest:(NSURLRequest *)request
                      requestID:(NSInteger)requestID
                          error:(WZRequestErrorObject *)error
                        context:(id)context;

@end




















