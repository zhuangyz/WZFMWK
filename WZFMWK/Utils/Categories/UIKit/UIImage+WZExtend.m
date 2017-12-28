//
//  UIImage+WZExtend.m
//  WZFMWK
//
//  Created by Walker on 2017/11/27.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "UIImage+WZExtend.h"

// MARK: - 解决竖屏拍照上传的图片旋转90度的问题
@implementation UIImage (WZOrientation)

- (UIImage *)wz_imageWthFixOrientation {
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.height, self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end

// MARK: - 裁剪
@implementation UIImage (WZScaleToSize)

- (UIImage *)wz_imageWithScaleToSize:(CGSize)size
                          contentMode:(UIViewContentMode)contentMode
                                scale:(CGFloat)scale {
    NSAssert(size.width >= 0 && size.height >= 0, @"非法的size：%@", NSStringFromCGSize(size));
    CGSize imageSize = self.size;
    CGRect drawingRect = CGRectZero;
    
    if (contentMode == UIViewContentModeScaleToFill) {
        drawingRect = CGRectMake(0, 0, size.width, size.height);
    } else {
        CGFloat horizontalRatio = size.width / imageSize.width;
        CGFloat verticalRatio = size.height / imageSize.height;
        CGFloat ratio = 0;
        if (contentMode == UIViewContentModeScaleAspectFill) {
            ratio = fmax(horizontalRatio, verticalRatio);
        } else {
            // 默认按 UIViewContentModeScaleAspectFit
            ratio = fmin(horizontalRatio, verticalRatio);
        }
        drawingRect.size.width = imageSize.width * ratio;
        drawingRect.size.height = imageSize.height * ratio;
    }
    
    UIGraphicsBeginImageContextWithOptions(drawingRect.size, NO, scale);
    [self drawInRect:drawingRect];
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageOut;
}

@end


















