//
//  WZPhotoBrowserCell.m
//  WZPhotoBrowser
//
//  Created by Walker on 2017/6/7.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "WZPhotoBrowserCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WZPhotoBrowserProgressView.h"

@interface WZPhotoBrowserCell () <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@property (nonatomic, strong) WZPhotoBrowserProgressView *progressView;

// 记录拖动手势开始时imageView的frame和手势位置
@property (nonatomic, assign) CGRect beganFrame;
@property (nonatomic, assign) CGPoint beganTouch;

@end

@implementation WZPhotoBrowserCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        [self.contentView addSubview:self.progressView];
        
        self.imageMaxZoomScale = 2.0;
        self.beganFrame = CGRectZero;
        self.beganTouch = CGPointZero;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_longPressAction:)];
        [self.contentView addGestureRecognizer:longPress];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_doubleTapAction:)];
        doubleTap.numberOfTapsRequired = 2;
        [self.contentView addGestureRecognizer:doubleTap];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_singleTapAction)];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [self.contentView addGestureRecognizer:singleTap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(_panAction:)];
        pan.delegate = self;
        [self.scrollView addGestureRecognizer:pan];
    }
    return self;
}

- (void)setPhoto:(WZPhoto *)photo defaultImage:(UIImage *)defaultImage {
    if (photo.imageURL) {
        NSString *cacheKey = [[SDWebImageManager sharedManager] cacheKeyForURL:photo.imageURL];
        UIImage *cacheImage = [[SDWebImageManager sharedManager].imageCache imageFromMemoryCacheForKey:cacheKey];
        if (!cacheImage) {
            cacheImage = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:cacheKey];
        }
        if (cacheImage) {
            self.imageView.image = cacheImage;
            [self _updateFrames];
            
        } else {
            __weak typeof(self) weakSelf = self;
            self.progressView.hidden = NO;
            [self.imageView sd_setImageWithURL:photo.imageURL placeholderImage:nil options:(SDWebImageProgressiveDownload) progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                weakSelf.progressView.progress = receivedSize / (CGFloat)expectedSize;
                
            } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (error) {
                    weakSelf.imageView.image = defaultImage;
                }
                [weakSelf _updateFrames];
                weakSelf.progressView.hidden = YES;
            }];
        }
        
    } else if (photo.image) {
        self.imageView.image = photo.image;
        [self _updateFrames];
        
    } else {
        self.imageView.image = defaultImage;
        [self _updateFrames];
    }
}

#pragma mark 手势事件
- (void)_longPressAction:(UILongPressGestureRecognizer *)longPress {
    if ([self.delegate respondsToSelector:@selector(photoBrowserCell:didLongPressWithImage:)] && longPress.state == UIGestureRecognizerStateBegan && self.imageView.image != nil) {
        [self.delegate photoBrowserCell:self didLongPressWithImage:self.imageView.image];
    }
}

- (void)_doubleTapAction:(UITapGestureRecognizer *)doubleTap {
    if (self.scrollView.zoomScale == 1.0) {
        CGPoint pointInView = [doubleTap locationInView:self.imageView];
        CGFloat w = self.scrollView.bounds.size.width / self.imageMaxZoomScale;
        CGFloat h = self.scrollView.bounds.size.height / self.imageMaxZoomScale;
        CGFloat x = pointInView.x - (w / 2.0);
        CGFloat y = pointInView.y - (h / 2.0);
        [self.scrollView zoomToRect:CGRectMake(x, y, w, h) animated:YES];
        
    } else {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }
}

- (void)_singleTapAction {
    if ([self.delegate respondsToSelector:@selector(photoBrowserCellDidSingleTap:)]) {
        [self.delegate photoBrowserCellDidSingleTap:self];
    }
}

- (void)_panAction:(UIPanGestureRecognizer *)pan {
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            self.beganFrame = self.imageView.frame;
            self.beganTouch = [pan locationInView:self.scrollView];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint translation = [pan translationInView:self.scrollView];
            CGPoint currentTouchPoint = [pan locationInView:self.scrollView];
            
            CGFloat scale = MAX(0.3, 1 - (fabs(translation.y) / self.bounds.size.height));
            
            CGFloat width = self.beganFrame.size.width * scale;
            CGFloat height = self.beganFrame.size.height * scale;
            
            CGFloat beganXRate = (self.beganTouch.x - self.beganFrame.origin.x) / self.beganFrame.size.width;
            CGFloat x = currentTouchPoint.x - beganXRate * width;
            
            CGFloat beganYRate = (self.beganTouch.y - self.beganFrame.origin.y) / self.beganFrame.size.height;
            CGFloat y = currentTouchPoint.y - beganYRate * height;
            
            self.imageView.frame = CGRectMake(x, y, width, height);
            
            if ([self.delegate respondsToSelector:@selector(photoBrowserCell:didPanScale:)]) {
                [self.delegate photoBrowserCell:self didPanScale:scale];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            if ([pan velocityInView:self].y > 0) { // dismiss
                [self _singleTapAction];
                
            } else { // 图片复位
                [self endPan];
            }
            break;
        }
        default:
            [self endPan];
            break;
    }
}

- (void)endPan {
    CGSize size = [self _imageViewFitSize];
    [UIView animateWithDuration:0.25 animations:^{
        self.imageView.center = [self _centerOfContentSize];
        self.imageView.bounds = CGRectMake(0, 0, size.width, size.height);
    }];
    if ([self.delegate respondsToSelector:@selector(photoBrowserCell:didPanScale:)]) {
        [self.delegate photoBrowserCell:self didPanScale:1.0];
    }
}

#pragma mark UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return YES;
    }
    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
    // 向上滑动时不响应手势
    if (velocity.y < 0) {
        return NO;
    }
    // 横向滑动时，不响应 pan 手势
    if (fabs(velocity.x) > fabs(velocity.y)) {
        return NO;
    }
    // 向下滑动，如果图片顶部超出可视区域，不响应手势
    if (self.scrollView.contentOffset.y > 0) {
        return NO;
    }
    return YES;
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    self.imageView.center = [self _centerOfContentSize];
}

#pragma mark layout
//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.scrollView.frame = self.contentView.bounds;
//}

- (void)_updateFrames {
    self.scrollView.frame = self.contentView.bounds;
    [self.scrollView setZoomScale:1.0 animated:NO];
    self.imageView.frame = [self _imageViewFitFrame];
    [self.scrollView setZoomScale:1.0 animated:NO];
}

#pragma mark getters and setters
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (WZPhotoBrowserProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[WZPhotoBrowserProgressView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 50) / 2, ([UIScreen mainScreen].bounds.size.height - 50) / 2, 50, 50)];
    }
    return _progressView;
}

- (void)setImageMaxZoomScale:(CGFloat)imageMaxZoomScale {
    _imageMaxZoomScale = imageMaxZoomScale;
    self.scrollView.maximumZoomScale = imageMaxZoomScale;
}

- (CGSize)_imageViewFitSize {
    CGSize fitSize = CGSizeZero;
    if (self.imageView.image) {
        CGFloat width = self.contentView.bounds.size.width;
        CGFloat scale = self.imageView.image.size.height / self.imageView.image.size.width;
        fitSize = CGSizeMake(width, scale * width);
    }
    return fitSize;
}

- (CGRect)_imageViewFitFrame {
    CGSize fitSize = [self _imageViewFitSize];
    CGFloat y = self.contentView.bounds.size.height > fitSize.height ? ((self.contentView.bounds.size.height - fitSize.height) / 2) : 0;
    return CGRectMake(0, y, fitSize.width, fitSize.height);
}

- (CGPoint)_centerOfContentSize {
    CGFloat deltaW = self.bounds.size.width - self.scrollView.contentSize.width;
    CGFloat offsetX = deltaW > 0 ? (deltaW / 2.0) : 0;
    CGFloat deltaH = self.bounds.size.height - self.scrollView.contentSize.height;
    CGFloat offsetY = deltaH > 0 ? (deltaH / 2.0) : 0;
    return CGPointMake(self.scrollView.contentSize.width / 2.0 + offsetX, self.scrollView.contentSize.height / 2.0 + offsetY);
}

@end


























