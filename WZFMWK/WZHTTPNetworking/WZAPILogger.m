//
//  WZAPILogger.m
//  WZFMWK
//
//  Created by Walker on 2017/5/18.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "WZAPILogger.h"

@implementation WZAPILogger

+ (void)logRequestInfo:(NSString *)requestURL
                params:(NSDictionary *)params
    serviceDescription:(NSString *)description {
#if DEBUG
    NSMutableString *log = [NSMutableString string];
    [log appendString:@"\n↓↓↓↓↓========================================================================↓↓↓↓↓\n"];
    [log appendString:@"request\n"];
    [log appendFormat:@"request url:\t\t\t%@\n", [self _stringWithURL:requestURL params:params]];
    [log appendFormat:@"request description:\t%@\n", description];
    [log appendString:@"↑↑↑↑↑========================================================================↑↑↑↑↑\n\n"];
    NSLog(@"%@", log);
#endif
}

+ (void)logSuccessResponse:(NSString *)requestURL
        serviceDescription:(NSString *)description
           responseContent:(NSDictionary *)responseContent {
#if DEBUG
    NSMutableString *log = [NSMutableString string];
    [log appendString:@"\n↓↓↓↓↓************************************************************************↓↓↓↓↓\n"];
    [log appendString:@"response success\n"];
    [log appendFormat:@"request url:\t\t\t%@\n", requestURL];
    [log appendFormat:@"request description:\t%@\n", description];
    if (responseContent) {
        [log appendFormat:@"response content:\n%@\n", responseContent];
    }
    [log appendString:@"↑↑↑↑↑************************************************************************↑↑↑↑↑\n\n"];
    NSLog(@"%@", log);
#endif
}

+ (void)logFailResponse:(NSString *)requestURL
     serviceDescription:(NSString *)description
              errorCode:(NSInteger)code
               errorMsg:(NSString *)msg {
#if DEBUG
    NSMutableString *log = [NSMutableString string];
    [log appendString:@"\n↓↓↓↓↓************************************************************************↓↓↓↓↓\n"];
    [log appendString:@"response fail\n"];
    [log appendFormat:@"request url:\t\t\t%@\n", requestURL];
    [log appendFormat:@"request description:\t%@\n", description];
    [log appendFormat:@"error code:\t\t\t\t%ld\n", code];
    [log appendFormat:@"error massage:\t\t\t%@\n", msg];
    [log appendString:@"↑↑↑↑↑************************************************************************↑↑↑↑↑\n\n"];
    NSLog(@"%@", log);
#endif
}

+ (NSString *)_stringWithURL:(NSString *)url params:(NSDictionary *)params {
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@?", url];
    for (NSString *key in params.allKeys) {
        [str appendFormat:@"%@=%@&", key, params[key]];
    }
    [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
    return str;
}

@end































