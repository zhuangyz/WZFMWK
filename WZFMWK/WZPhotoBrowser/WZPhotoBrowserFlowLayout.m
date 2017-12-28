//
//  WZPhotoBrowserFlowLayout.m
//  WZPhotoBrowser
//
//  Created by Walker on 2017/6/7.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "WZPhotoBrowserFlowLayout.h"

@interface WZPhotoBrowserFlowLayout ()

// 上一页码
@property (nonatomic, assign) NSInteger lastPage;
@property (nonatomic, assign) NSInteger maxPage;
@property (nonatomic, assign) CGFloat pageWidth;

@end

@implementation WZPhotoBrowserFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.itemSize = [UIScreen mainScreen].bounds.size;
        self.minimumLineSpacing = 20;
        self.lastPage = -1;
        self.maxPage = -1;
        self.pageWidth = -1;
    }
    return self;
}

- (CGFloat)pageWidth {
    if (_pageWidth == -1) {
        _pageWidth = self.itemSize.width + self.minimumLineSpacing;
    }
    return _pageWidth;
}

- (NSInteger)lastPage {
    if (_lastPage == -1) {
        if (self.collectionView) {
            _lastPage = round(self.collectionView.contentOffset.x / self.pageWidth);
            
        } else {
            _lastPage = 0;
        }
    }
    return _lastPage;
}

- (NSInteger)minPage {
    return 0;
}

- (NSInteger)maxPage {
    if (_maxPage == -1) {
        if (self.collectionView) {
            _maxPage = (self.collectionView.contentSize.width + self.minimumLineSpacing) / self.pageWidth - 1;
        } else {
            _maxPage = 0;
        }
    }
    return _maxPage;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    NSInteger page = round(proposedContentOffset.x / self.pageWidth);
    // 处理速度很快的轻微滑动
    if (velocity.x > 0.2) {
        page += 1;
    } else if (velocity.x < -0.2) {
        page -= 1;
    }
    
    if (page > self.lastPage) {
        page = self.lastPage + 1;
    } else if (page < self.lastPage - 1) {
        page = self.lastPage - 1;
    }
    
    if (page > self.maxPage) {
        page = self.maxPage;
    } else if (page < self.minPage) {
        page = self.minPage;
    }
    
    self.lastPage = page;
    return CGPointMake(page * self.pageWidth, 0);
}

@end

























