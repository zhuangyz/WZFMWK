//
//  WZPhotoBrowserProgressView.m
//  WZPhotoBrowser
//
//  Created by Walker on 2017/7/17.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "WZPhotoBrowserProgressView.h"

@interface WZPhotoBrowserProgressView ()

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@end

@implementation WZPhotoBrowserProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    if (CGSizeEqualToSize(frame.size, CGSizeZero)) {
        frame.size = CGSizeMake(50, 50);
    }
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self.layer addSublayer:self.progressLayer];
        self.progress = 0;
    }
    return self;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.strokeColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.lineWidth = 3;
        _progressLayer.lineCap = @"round";
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2) radius:(self.bounds.size.width / 2 - 2 * _progressLayer.lineWidth) startAngle:-M_PI_2 endAngle:M_PI_2 + M_PI clockwise:YES];
        _progressLayer.path = path.CGPath;
        _progressLayer.strokeStart = 0;
        _progressLayer.frame = self.bounds;
    }
    return _progressLayer;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.progressLayer.strokeEnd = progress;
}

@end
