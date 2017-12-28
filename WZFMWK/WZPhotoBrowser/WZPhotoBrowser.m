//
//  WZPhotoBrowser.m
//  WZPhotoBrowser
//
//  Created by Walker on 2017/6/6.
//  Copyright © 2017年 wz. All rights reserved.
//

#import "WZPhotoBrowser.h"
#import "WZPhotoBrowserCell.h"
#import "WZPhotoBrowserFlowLayout.h"
#import "WZScaleAnimator.h"
#import "WZScaleAnimatorCoordinator.h"

@interface WZPhotoBrowser () <UICollectionViewDataSource, UICollectionViewDelegate, WZPhotoBrowserCellDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, copy) NSArray<WZPhoto *> *photos;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) WZPhotoBrowserFlowLayout *flowLayout;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, weak) WZScaleAnimator *presentationAnimator;
@property (nonatomic, weak) WZScaleAnimatorCoordinator *animatorCoordinator;

@property (nonatomic, strong) UIViewController *presentingVC;

@end

@implementation WZPhotoBrowser

@dynamic pageIndicatorTintColor;
@dynamic currentPageIndicatorTintColor;

- (instancetype)initWithPhotos:(NSArray<WZPhoto *> *)photos defaultIndex:(NSInteger)index delegate:(id<WZPhotoBrowserDelegate>)delegate {
    if (self = [super init]) {
        self.photos = photos;
        _currentIndex = index;
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)initWithWebImageURLs:(NSArray<NSString *> *)urls defaultIndex:(NSInteger)index delegate:(id<WZPhotoBrowserDelegate>)delegate {
    NSMutableArray *photos = [NSMutableArray array];
    for (NSString *url in urls) {
        [photos addObject:[WZPhoto photoWithImageURLString:url]];
    }
    return [self initWithPhotos:[photos copy] defaultIndex:index delegate:delegate];
}

- (instancetype)initWithUIImages:(NSArray<UIImage *> *)images defaultIndex:(NSInteger)index delegate:(id<WZPhotoBrowserDelegate>)delegate {
    NSMutableArray *photos = [NSMutableArray array];
    for (UIImage *image in images) {
        [photos addObject:[WZPhoto photoWithImage:image]];
    }
    return [self initWithPhotos:[photos copy] defaultIndex:index delegate:delegate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.pageControl];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    [self.collectionView layoutIfNeeded];
    
    WZPhotoBrowserCell *cell = (WZPhotoBrowserCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (cell) {
        self.presentationAnimator.endView = cell.imageView;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:cell.imageView.image];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        self.presentationAnimator.scaleView = imageView;
    }
}

- (void)showFromVC:(UIViewController *)vc {
    self.presentingVC = vc;
    self.transitioningDelegate = self;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.modalPresentationCapturesStatusBarAppearance = YES;
    [self.presentingVC presentViewController:self animated:YES completion:nil];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    [self.animatorCoordinator updateCurrentHiddenView:[self relatedView]];
    if ([self.delegate respondsToSelector:@selector(photoBrowser:didChangedCurrentIndex:)]) {
        [self.delegate photoBrowser:self didChangedCurrentIndex:_currentIndex];
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_collectionView registerClass:[WZPhotoBrowserCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (WZPhotoBrowserFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[WZPhotoBrowserFlowLayout alloc] init];
    }
    return _flowLayout;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 20 - 10, [UIScreen mainScreen].bounds.size.width, 10)];
        _pageControl.numberOfPages = self.photos.count;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPage = self.currentIndex;
        _pageControl.hidesForSinglePage = YES;
    }
    return _pageControl;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
}

- (UIColor *)pageIndicatorTintColor {
    return self.pageControl.pageIndicatorTintColor;
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}

- (UIColor *)currentPageIndicatorTintColor {
    return self.pageControl.currentPageIndicatorTintColor;
}

#pragma mark UICollectionViewDataSource and UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WZPhotoBrowserCell *cell = (WZPhotoBrowserCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell setPhoto:self.photos[indexPath.item] defaultImage:self.placeholdImage];
    return cell;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGFloat width = self.flowLayout.itemSize.width + self.flowLayout.minimumLineSpacing;
    self.currentIndex = (NSInteger)((*targetContentOffset).x / width);
    self.pageControl.currentPage = self.currentIndex;
}

#pragma mark UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    WZScaleAnimator *animator = [[WZScaleAnimator alloc] initWithStartView:[self relatedView] endView:nil scaleView:nil];
    self.presentationAnimator = animator;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    WZPhotoBrowserCell *cell = self.collectionView.visibleCells.firstObject;
    if (!cell) {
        return nil;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:cell.imageView.image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    return [[WZScaleAnimator alloc] initWithStartView:cell.imageView endView:[self relatedView] scaleView:imageView];
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    WZScaleAnimatorCoordinator *coordinator = [[WZScaleAnimatorCoordinator alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    coordinator.currentHiddenView = [self relatedView];
    self.animatorCoordinator = coordinator;
    return coordinator;
}

- (UIView *)relatedView {
    if ([self.delegate respondsToSelector:@selector(photoBrowser:thumbnailViewForIndex:)]) {
        return [self.delegate photoBrowser:self thumbnailViewForIndex:self.currentIndex];
    }
    return nil;
}

#pragma mark WZPhotoBrowserCellDelegate
- (void)photoBrowserCellDidSingleTap:(WZPhotoBrowserCell *)cell {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoBrowserCell:(WZPhotoBrowserCell *)cell didLongPressWithImage:(UIImage *)image {
    if ([self.delegate respondsToSelector:@selector(photoBrowser:didLongPressForIndex:image:)]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        if (indexPath) {
            [self.delegate photoBrowser:self didLongPressForIndex:indexPath.item image:image];
        }
    }
}

- (void)photoBrowserCell:(WZPhotoBrowserCell *)cell didPanScale:(CGFloat)scale {
    CGFloat alpha = scale * scale;
    self.animatorCoordinator.maskView.alpha = alpha;
}

// 不能旋转
- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end



























