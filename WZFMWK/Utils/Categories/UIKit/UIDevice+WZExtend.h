//
//  UIDevice+WZDeviceInfo.h
//  WZFMWK
//
//  Created by Walker on 2017/11/23.
//  Copyright © 2017年 wz. All rights reserved.
//

#import <UIKit/UIKit.h>

// MARK: - 设备信息
@interface UIDevice (WZDeviceInfo)

// 例如 iPhone9,2
+ (NSString *)wz_identifier;
// 例如 iPhone 7
+ (NSString *)wz_modelName;

@end
