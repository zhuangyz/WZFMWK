//
//  WZOriginResponse.h
//  WZFMWK
//
//  Created by Walker on 2017/5/17.
//  Copyright © 2017年 wz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURLRequest+WZParam.h"

typedef NS_ENUM(NSUInteger, WZOriginResponseStatus) {
    WZOriginResponseStatusSuccess,       // 这里的success是指请求能否成功收到服务器反馈
    WZOriginResponseStatusErrorTimeout,
    WZOriginResponseStatusErrorNoNetwork,
    WZOriginResponseStatusErrorCancel,
};

@interface WZOriginResponse : NSObject

@property (nonatomic, readonly) WZOriginResponseStatus status;

@property (nonatomic, readonly) id responseContent;
@property (nonatomic, readonly) NSData *responseData;

@property (nonatomic, readonly) NSInteger requestID;
@property (nonatomic, readonly) NSURLRequest *request; // request有个wz_params的额外的属性可以使用！值为请求时的参数

@property (nonatomic, strong) id context; // 请求发起时调用方传入的上下文相关的附加信息，供回调处可用

- (instancetype)initWithRequest:(NSURLRequest *)request
                      requestID:(NSInteger)requestID
                   responseData:(NSData *)responseData
                          error:(NSError *)error;

- (instancetype)initWithRequest:(NSURLRequest *)request
                      requestID:(NSInteger)requestID
                   responseData:(NSData *)responseData
                         status:(WZOriginResponseStatus)status;

@end
