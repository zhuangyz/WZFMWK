//
//  WZAPILogger.h
//  WZFMWK
//
//  Created by Walker on 2017/5/18.
//  Copyright © 2017年 wz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZAPILogger : NSObject

+ (void)logRequestInfo:(NSString *)requestURL
                params:(NSDictionary *)params
    serviceDescription:(NSString *)description;

+ (void)logSuccessResponse:(NSString *)requestURL
        serviceDescription:(NSString *)description
           responseContent:(NSDictionary *)responseContent; // 可空

+ (void)logFailResponse:(NSString *)requestURL
     serviceDescription:(NSString *)description
              errorCode:(NSInteger)code
               errorMsg:(NSString *)msg;

@end
