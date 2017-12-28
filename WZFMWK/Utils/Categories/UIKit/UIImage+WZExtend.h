//
//  UIImage+WZExtend.h
//  WZFMWK
//
//  Created by Walker on 2017/11/27.
//  Copyright © 2017年 wz. All rights reserved.
//

#import <UIKit/UIKit.h>

// MARK: - 解决竖屏拍照上传的图片旋转90度的问题
@interface UIImage (WZOrientation)

- (UIImage *)wz_imageWthFixOrientation;

@end

// MARK: - 裁剪
@interface UIImage (WZScaleToSize)

- (UIImage *)wz_imageWithScaleToSize:(CGSize)size
                          contentMode:(UIViewContentMode)contentMode
                                scale:(CGFloat)scale;

@end















