//
//  WZPhotoBrowser.h
//  WZPhotoBrowser
//
//  Created by Walker on 2017/6/6.
//  Copyright © 2017年 wz. All rights reserved.
//
//  在 JXPhotoBrowser(https://github.com/JiongXing/PhotoBrowser) 的基础上修改部分代码

#import <UIKit/UIKit.h>
#import "WZPhoto.h"

@class WZPhotoBrowser;
@protocol WZPhotoBrowserDelegate <NSObject>

@required
- (UIView *)photoBrowser:(WZPhotoBrowser *)photoBrowser thumbnailViewForIndex:(NSInteger)index;

@optional
- (void)photoBrowser:(WZPhotoBrowser *)photoBrowser didChangedCurrentIndex:(NSInteger)index;

- (void)photoBrowser:(WZPhotoBrowser *)photoBrowser didLongPressForIndex:(NSInteger)index image:(UIImage *)image;

@end

@interface WZPhotoBrowser : UIViewController

@property (nonatomic, weak) id<WZPhotoBrowserDelegate> delegate;

// pageControl 的颜色
@property (nonatomic, strong) UIColor *pageIndicatorTintColor; // 默认 lightGray
@property (nonatomic, strong) UIColor *currentPageIndicatorTintColor; // 默认 white

@property (nonatomic, strong) UIImage *placeholdImage;

- (instancetype)initWithPhotos:(NSArray<WZPhoto *> *)photos
                  defaultIndex:(NSInteger)index
                      delegate:(id<WZPhotoBrowserDelegate>)delegate;
- (instancetype)initWithWebImageURLs:(NSArray<NSString *> *)urls
                        defaultIndex:(NSInteger)index
                            delegate:(id<WZPhotoBrowserDelegate>)delegate;
- (instancetype)initWithUIImages:(NSArray<UIImage *> *)images
                    defaultIndex:(NSInteger)index
                        delegate:(id<WZPhotoBrowserDelegate>)delegate;
- (void)showFromVC:(UIViewController *)vc;

@end
