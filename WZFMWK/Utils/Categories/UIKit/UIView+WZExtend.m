//
//  UIView+WZEasyFrame.m
//  WZFMWK
//
//  Created by Walker on 2017/11/23.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "UIView+WZExtend.h"

// MARK: - frame help
@implementation UIView (WZEasyFrame)

- (void)setWz_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)wz_origin {
    return self.frame.origin;
}

- (void)setWz_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)wz_size {
    return self.frame.size;
}

- (void)setWz_x:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)wz_x {
    return self.wz_origin.x;
}

- (void)setWz_y:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)wz_y {
    return self.wz_origin.y;
}

- (void)setWz_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)wz_width {
    return self.wz_size.width;
}

- (void)setWz_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)wz_height {
    return self.wz_size.height;
}

- (CGFloat)wz_maxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)wz_maxY {
    return CGRectGetMaxY(self.frame);
}

@end
