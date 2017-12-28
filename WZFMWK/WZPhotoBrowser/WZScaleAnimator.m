//
//  WZScaleAnimator.m
//  WZPhotoBrowser
//
//  Created by Walker on 2017/6/8.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "WZScaleAnimator.h"

@implementation WZScaleAnimator

- (instancetype)initWithStartView:(UIView *)startView endView:(UIView *)endView scaleView:(UIView *)scaleView {
    if (self = [super init]) {
        self.startView = startView;
        self.endView = endView;
        self.scaleView = scaleView;
    }
    return self;
}

#pragma mark UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    if (!fromVC && !toVC) {
        return;
    }
    
    BOOL presentation = toVC.presentingViewController == fromVC;
    UIView *presentedView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    if (!presentation && presentedView) {
        presentedView.hidden = YES;
    }
    
    UIView *containerView = transitionContext.containerView;
    if (!self.startView && !self.scaleView) {
        return;
    }
    CGRect startFrame = self.startView ? [self.startView convertRect:self.startView.bounds toView:containerView] : CGRectMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2, 0, 0);
    CGRect endFrame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2, 0, 0);
    CGFloat endAlpha = 0.0;
    
    if (self.endView) {
        CGRect relativeFrame = [self.endView convertRect:self.endView.bounds toView:nil];
        CGRect keyWindowBounds = [UIScreen mainScreen].bounds;
        if (CGRectIntersectsRect(relativeFrame, keyWindowBounds)) {
            endAlpha = 1.0;
            endFrame = [self.endView convertRect:self.endView.bounds toView:containerView];
        }
    }
    
    self.scaleView.frame = startFrame;
    [containerView addSubview:self.scaleView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        self.scaleView.alpha = endAlpha;
        self.scaleView.frame = endFrame;
        
    } completion:^(BOOL finished) {
        UIView *presentedView = [transitionContext viewForKey:UITransitionContextToViewKey];
        if (presentation && presentedView) {
            [containerView addSubview:presentedView];
        }
        [self.scaleView removeFromSuperview];
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end





























