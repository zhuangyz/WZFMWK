//
//  WZPhoto.h
//  WZPhotoBrowser
//
//  Created by Walker on 2017/6/6.
//  Copyright © 2017年 wz. All rights reserved.
//
//  在 JXPhotoBrowser(https://github.com/JiongXing/PhotoBrowser) 的基础上修改部分代码

#import <UIKit/UIKit.h>

@interface WZPhoto : NSObject

@property (nonatomic, readonly) NSURL *imageURL;
@property (nonatomic, readonly) UIImage *image;

- (instancetype)initWithImageURLString:(NSString *)urlStr;
- (instancetype)initWithImageURL:(NSURL *)url;
- (instancetype)initWithImage:(UIImage *)image;

@end

@interface WZPhoto (Factory)

+ (instancetype)photoWithImageURLString:(NSString *)urlStr;
+ (instancetype)photoWithImageURL:(NSURL *)url;
+ (instancetype)photoWithImage:(UIImage *)image;

@end
