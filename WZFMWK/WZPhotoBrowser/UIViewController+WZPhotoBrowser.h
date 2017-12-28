//
//  UIViewController+LookPhotos.h
//  WZPhotoBrowser
//
//  Created by Walker on 2016/11/26.
//  Copyright © 2016年 wz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZPhotoBrowser.h"

@interface UIViewController (WZPhotoBrowser)

- (WZPhotoBrowser *)wz_pushPhotoBrowserWithImageURLStrs:(NSArray<NSString *> *)imageURLStrs defaultIndex:(NSInteger)index;
- (WZPhotoBrowser *)wz_pushPhotoBrowserWithUIImages:(NSArray<UIImage *> *)images defaultIndex:(NSInteger)index;
- (WZPhotoBrowser *)wz_pushPhotoBrowserWithPhotos:(NSArray<WZPhoto *> *)photos defaultIndex:(NSInteger)index;

@end



















