//
//  WZApplicationManager.h
//  WZFMWK
//
//  Created by Walker on 2017/11/6.
//  Copyright © 2017年 wz. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WZNavBarHeight [WZApplicationManager sharedInstance].navigationBarHeight
#define WZStatusBarHeight [WZApplicationManager sharedInstance].statusBarHeight
#define WZTabBarHeight [WZApplicationManager sharedInstance].tabBarHeight
#define WZHomeIndicatorHeight [WZApplicationManager sharedInstance].homeIndicatorHeight

// 这个类的计算方法适用情景是很有限的(仅仅适用竖屏&iOS 11导航栏没有使用大字体)，所以可能考虑移除或更换计算方法
@interface WZApplicationManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, readonly) CGFloat statusBarHeight;
@property (nonatomic, readonly) CGFloat navigationBarHeight; // 包含 statusBarHeight
@property (nonatomic, readonly) CGFloat tabBarHeight;
@property (nonatomic, readonly) CGFloat homeIndicatorHeight;

@property (nonatomic, readonly) CGSize screenSize;

@end
