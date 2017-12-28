//
//  WZScaleAnimatorCoordinator.h
//  WZPhotoBrowser
//
//  Created by Walker on 2017/6/8.
//  Copyright © 2017年 wz. All rights reserved.
//
//  在 JXPhotoBrowser(https://github.com/JiongXing/PhotoBrowser) 的基础上修改部分代码

#import <UIKit/UIKit.h>

@interface WZScaleAnimatorCoordinator : UIPresentationController

@property (nonatomic, strong) UIView *currentHiddenView;
@property (nonatomic, strong) UIView *maskView;

- (void)updateCurrentHiddenView:(UIView *)view;

@end
