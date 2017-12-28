//
//  WZOriginResponse.m
//  WZFMWK
//
//  Created by Walker on 2017/5/17.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "WZOriginResponse.h"

@interface WZOriginResponse ()

@property (nonatomic, assign, readwrite) WZOriginResponseStatus status;

@property (nonatomic, copy, readwrite) id responseContent;
@property (nonatomic, copy, readwrite) NSData *responseData;

@property (nonatomic, assign, readwrite) NSInteger requestID;
@property (nonatomic, copy, readwrite) NSURLRequest *request;

@end

@implementation WZOriginResponse

- (instancetype)initWithRequest:(NSURLRequest *)request
                      requestID:(NSInteger)requestID
                   responseData:(NSData *)responseData
                         status:(WZOriginResponseStatus)status {
    if (self = [super init]) {
        self.status = status;
        self.request = request;
        self.request.wz_params = request.wz_params;
        self.requestID = requestID;
        self.responseData = responseData;
        self.responseContent = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        self.context = nil;
    }
    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request
                      requestID:(NSInteger)requestID
                   responseData:(NSData *)responseData
                          error:(NSError *)error {
    if (self = [super init]) {
        self.status = [self responseStatusWithError:error];
        self.request = request;
        self.request.wz_params = request.wz_params;
        self.requestID = requestID;
        self.responseData = responseData;
        if (responseData) {
            self.responseContent = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:NULL];
        }
        self.context = nil;
    }
    return self;
}

- (WZOriginResponseStatus)responseStatusWithError:(NSError *)error {
    if (error) {
        if (error.code == NSURLErrorTimedOut) {
            return WZOriginResponseStatusErrorTimeout;
        } else if (error.code == NSURLErrorCancelled) {
            return WZOriginResponseStatusErrorCancel;
        } else {
            return WZOriginResponseStatusErrorNoNetwork;
        }
        
    } else {
        return WZOriginResponseStatusSuccess;
    }
}

@end

























