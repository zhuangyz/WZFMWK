//
//  NSURLRequest+Param.m
//  WZFMWK
//
//  Created by Walker on 2017/5/17.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "NSURLRequest+WZParam.h"
#import <objc/runtime.h>

@implementation NSURLRequest (WZParam)

- (void)setWz_params:(NSDictionary *)wz_params {
    objc_setAssociatedObject(self, "wz_params", [wz_params copy], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSDictionary *)wz_params {
    return objc_getAssociatedObject(self, "wz_params");
}

@end
