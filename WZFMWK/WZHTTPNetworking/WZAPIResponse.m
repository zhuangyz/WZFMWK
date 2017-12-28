//
//  WZAPIResponse.m
//  WZFMWK
//
//  Created by Walker on 2017/5/17.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "WZAPIResponse.h"

#pragma mark - WZRequestErrorObject
@interface WZRequestErrorObject ()

@property (nonatomic, assign, readwrite) NSInteger errorCode;
@property (nonatomic, copy, readwrite) NSString *errorMsg;

@end

@implementation WZRequestErrorObject

+ (instancetype)errorObjectWithCode:(NSInteger)code errorMsg:(NSString *)msg {
    WZRequestErrorObject *obj = [[WZRequestErrorObject alloc] init];
    obj.errorCode = code;
    obj.errorMsg = msg;
    return obj;
}

@end


#pragma mark - WZAPISuccessResponse
@interface WZAPISuccessResponse ()

@property (nonatomic, assign, readwrite) NSInteger requestID;
@property (nonatomic, copy, readwrite) NSURLRequest *request;
@property (nonatomic, copy, readwrite) NSDictionary *responseContent;
@property (nonatomic, strong, readwrite) id context;

@end

@implementation WZAPISuccessResponse

- (instancetype)initWithRequest:(NSURLRequest *)request
                      requestID:(NSInteger)requestID
                responseContent:(NSDictionary *)responseContent
                        context:(id)context {
    if (self = [super init]) {
        self.request = request;
        self.request.wz_params = request.wz_params;
        self.requestID = requestID;
        self.responseContent = responseContent;
        self.context = context;
    }
    return self;
}

@end


#pragma mark - WZAPIFailResponse
@interface WZAPIFailResponse ()

@property (nonatomic, assign, readwrite) NSInteger requestID;
@property (nonatomic, copy, readwrite) NSURLRequest *request;
@property (nonatomic, strong, readwrite) WZRequestErrorObject *error;
@property (nonatomic, strong, readwrite) id context;

@end

@implementation WZAPIFailResponse

- (instancetype)initWithRequest:(NSURLRequest *)request
                      requestID:(NSInteger)requestID
                          error:(WZRequestErrorObject *)error
                        context:(id)context {
    if (self = [super init]) {
        self.request = request;
        if (request) {
            self.request.wz_params = request.wz_params;
        }
        self.requestID = requestID;
        self.error = error;
        self.context = context;
    }
    return self;
}

@end



























