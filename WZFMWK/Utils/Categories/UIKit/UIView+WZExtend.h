//
//  UIView+WZEasyFrame.h
//  WZFMWK
//
//  Created by Walker on 2017/11/23.
//  Copyright © 2017年 wz. All rights reserved.
//

#import <UIKit/UIKit.h>

// MARK: - frame help
@interface UIView (WZEasyFrame)

@property (nonatomic, assign) CGPoint wz_origin;

@property (nonatomic, assign) CGSize wz_size;

@property (nonatomic, assign) CGFloat wz_x;

@property (nonatomic, assign) CGFloat wz_y;

@property (nonatomic, assign) CGFloat wz_width;

@property (nonatomic, assign) CGFloat wz_height;

@property (nonatomic, assign, readonly) CGFloat wz_maxX;

@property (nonatomic, assign, readonly) CGFloat wz_maxY;

@end
