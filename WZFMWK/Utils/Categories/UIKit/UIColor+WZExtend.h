//
//  UIColor+WZColor.h
//  WZFMWK
//
//  Created by Walker on 2017/11/23.
//  Copyright © 2017年 wz. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WZColor(__hexStr__) [UIColor wz_colorWithHexString:__hexStr__]

@interface UIColor (WZColor)

+ (UIColor *)wz_colorWithHexString:(NSString *)hexStr;

@end
