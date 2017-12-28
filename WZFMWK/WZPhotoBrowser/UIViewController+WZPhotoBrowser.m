//
//  UIViewController+LookPhotos.m
//  WZPhotoBrowser
//
//  Created by Walker on 2016/11/26.
//  Copyright © 2016年 wz. All rights reserved.
//

#import "UIViewController+WZPhotoBrowser.h"

@implementation UIViewController (WZLookPhotos)

- (WZPhotoBrowser *)wz_pushPhotoBrowserWithImageURLStrs:(NSArray<NSString *> *)imageURLStrs
                                            defaultIndex:(NSInteger)index {
    WZPhotoBrowser *browser = [[WZPhotoBrowser alloc] initWithWebImageURLs:imageURLStrs defaultIndex:index delegate:nil];
    [browser showFromVC:self];
    return browser;
}

- (WZPhotoBrowser *)wz_pushPhotoBrowserWithUIImages:(NSArray<UIImage *> *)images defaultIndex:(NSInteger)index {
    WZPhotoBrowser *browser = [[WZPhotoBrowser alloc] initWithUIImages:images defaultIndex:index delegate:nil];
    [browser showFromVC:self];
    return browser;
}

- (WZPhotoBrowser *)wz_pushPhotoBrowserWithPhotos:(NSArray<WZPhoto *> *)photos defaultIndex:(NSInteger)index {
    WZPhotoBrowser *browser = [[WZPhotoBrowser alloc] initWithPhotos:photos defaultIndex:index delegate:nil];
    [browser showFromVC:self];
    return browser;
}

@end

















