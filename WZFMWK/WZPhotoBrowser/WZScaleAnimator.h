//
//  WZScaleAnimator.h
//  WZPhotoBrowser
//
//  Created by Walker on 2017/6/8.
//  Copyright © 2017年 wz. All rights reserved.
//
//  在 JXPhotoBrowser(https://github.com/JiongXing/PhotoBrowser) 的基础上修改部分代码

#import <UIKit/UIKit.h>

@interface WZScaleAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UIView *startView;
@property (nonatomic, strong) UIView *endView;
@property (nonatomic, strong) UIView *scaleView;

- (instancetype)initWithStartView:(UIView *)startView endView:(UIView *)endView scaleView:(UIView *)scaleView;

@end
