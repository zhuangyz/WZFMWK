//
//  WZScaleAnimatorCoordinator.m
//  WZPhotoBrowser
//
//  Created by Walker on 2017/6/8.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "WZScaleAnimatorCoordinator.h"

@implementation WZScaleAnimatorCoordinator

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor blackColor];
    }
    return _maskView;
}

- (void)updateCurrentHiddenView:(UIView *)view {
    if (self.currentHiddenView) {
        self.currentHiddenView.hidden = NO;
    }
    self.currentHiddenView = view;
    if (view) {
        view.hidden = YES;
    }
}

- (void)presentationTransitionWillBegin {
    [super presentationTransitionWillBegin];
    if (!self.containerView) {
        return;
    }
    [self.containerView addSubview:self.maskView];
    self.maskView.frame = self.containerView.bounds;
    self.maskView.alpha = 0;
    self.currentHiddenView.hidden = YES;
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.maskView.alpha = 1;
    } completion:nil];
}

- (void)dismissalTransitionWillBegin {
    [super dismissalTransitionWillBegin];
    self.currentHiddenView.hidden = YES;
    [self.presentedViewController.transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.maskView.alpha = 0;
    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.currentHiddenView.hidden = NO;
    }];
}

@end




























