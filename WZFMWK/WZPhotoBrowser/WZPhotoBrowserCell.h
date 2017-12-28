//
//  WZPhotoBrowserCell.h
//  WZPhotoBrowser
//
//  Created by Walker on 2017/6/7.
//  Copyright © 2017年 wz. All rights reserved.
//
//  在 JXPhotoBrowser(https://github.com/JiongXing/PhotoBrowser) 的基础上修改部分代码

#import <UIKit/UIKit.h>
#import "WZPhoto.h"

@class WZPhotoBrowserCell;
@protocol WZPhotoBrowserCellDelegate <NSObject>

- (void)photoBrowserCellDidSingleTap:(WZPhotoBrowserCell *)cell;

- (void)photoBrowserCell:(WZPhotoBrowserCell *)cell didLongPressWithImage:(UIImage *)image;

- (void)photoBrowserCell:(WZPhotoBrowserCell *)cell didPanScale:(CGFloat)scale;

@end

@interface WZPhotoBrowserCell : UICollectionViewCell

@property (nonatomic, readonly) UIImageView *imageView;

@property (nonatomic, weak) id<WZPhotoBrowserCellDelegate> delegate;

// 缩放最大的比例 default 2.0
@property (nonatomic, assign) CGFloat imageMaxZoomScale;

- (void)setPhoto:(WZPhoto *)photo defaultImage:(UIImage *)defaultImage;

@end
