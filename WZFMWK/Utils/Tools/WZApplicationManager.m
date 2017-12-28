//
//  WZApplicationManager.m
//  WZFMWK
//
//  Created by Walker on 2017/11/6.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "WZApplicationManager.h"
#import "UIDevice+WZExtend.h"
#import <objc/runtime.h>

@interface UIDevice(_judge)

+ (BOOL)_isIPhoneX;

@end

@implementation UIDevice(_judge)

+ (BOOL)_isIPhoneX {
    NSNumber *is = objc_getAssociatedObject([UIDevice currentDevice], "current_device_is_iphoneX");
    if (is) {
        return [is boolValue];
    } else {
        NSLog(@"需要通过计算判断 iphoneX");
        NSString *modelName = [UIDevice wz_modelName];
#ifdef DEBUG
        if ([modelName isEqualToString:@"Simulator"]) {
            objc_setAssociatedObject([UIDevice currentDevice], "current_device_is_iphoneX", @([UIScreen mainScreen].bounds.size.height == 812), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            return [UIScreen mainScreen].bounds.size.height == 812;
        }
#endif
        objc_setAssociatedObject([UIDevice currentDevice], "current_device_is_iphoneX", @([modelName isEqualToString:@"iPhone X"]), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return [modelName isEqualToString:@"iPhone X"];
    }
}

@end

@implementation WZApplicationManager

+ (instancetype)sharedInstance {
    static WZApplicationManager *manager = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[WZApplicationManager alloc] init];
    });
    return manager;
}

- (CGFloat)statusBarHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height; // [UIDevice _isIPhoneX] ? 44 : 20;
}

- (CGFloat)navigationBarHeight {
    return self.statusBarHeight + 44;
}

- (CGFloat)tabBarHeight {
    return [UIDevice _isIPhoneX] ? 83 : 49;
}

- (CGFloat)homeIndicatorHeight {
    return [UIDevice _isIPhoneX] ? 34 : 0;
}

- (CGSize)screenSize {
    return [UIScreen mainScreen].bounds.size;
}

@end















