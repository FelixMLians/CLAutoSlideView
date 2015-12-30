//
//  CLAutoSlideView.m
//  CLAutoSlideView
//
//  Created by YuanRong on 15/12/23.
//  Copyright © 2015年 FelixMLians. All rights reserved.
//

#import "CLAutoSlideView.h"

static NSInteger const kDefaultPageCount = 1;
static CGFloat const kDefaultAnimationInterval = 3.0F;

@interface CLAutoSlideView () <UIScrollViewDelegate>
{
    CGFloat scrollViewStartContentOffsetX;
}
@property (nonatomic , assign) NSInteger currentPageIndex;

@property (nonatomic , strong) NSMutableArray *contentViews;

@property (nonatomic , strong) NSTimer *animationTimer;

@property (nonatomic , strong) UIPageControl *pageControl;

@end

@implementation CLAutoSlideView

#pragma mark - Init

+ (instancetype)autoSlideViewWithFrame:(CGRect)frame
                              delegate:(id<CLAutoSlideViewDelegate>)delegate
                                images:(NSArray *)images
                     animationInterval:(NSInteger)animationInterval
         currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
                pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    return [[self alloc] initWithFrame:frame
                              delegate:delegate
                                images:images
                     animationInterval:animationInterval
         currentPageIndicatorTintColor:currentPageIndicatorTintColor
                pageIndicatorTintColor:pageIndicatorTintColor];
}

- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<CLAutoSlideViewDelegate>)delegate
                       images:(NSArray *)images
            animationInterval:(NSInteger)animationInterval
currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
       pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configureUI];
        
        self.delegate = delegate;
        self.animationInterval = animationInterval;
        self.pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
        self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
        
        if (images != nil && images.count > 0) {
            _imageViews = images;
            self.totalPagesCount = self.imageViews.count;
            self.contentViews = [[NSMutableArray alloc] initWithArray:images];
            [self configureContentViews];
            [self.animationTimer resumeTimer];
        } else {
            _totalPagesCount = 1;
        }
    }
    return self;
}

#pragma mark - Private Method

- (void)configureUI {
    // init animation timer
    if (self.animationInterval > 0.0) {
        [self.animationTimer pauseTimer];
    }
    
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
}

- (void)configureContentViews {
    
    self.scrollView.contentSize = CGSizeMake(self.totalPagesCount * CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    if (self.scrollView.subviews.count > 0) {
        [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGesture:)];
        [contentView addGestureRecognizer:longGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [contentView addGestureRecognizer:tapGesture];
        
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter ++), 0);
        
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
    
    if (self.totalPagesCount > 1) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0)];
    }
}

- (void)setScrollViewContentDataSource {
    NSInteger previousPageIndex = [self obtainValidNextPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self obtainValidNextPageIndex:self.currentPageIndex + 1];
    
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    id set = (self.totalPagesCount == 1) ? [NSSet setWithObjects:@(previousPageIndex), @(_currentPageIndex), @(rearPageIndex), nil]:@[@(previousPageIndex),@(_currentPageIndex),@(rearPageIndex)];
    for (NSNumber *tempNumber in set) {
        NSInteger tempIndex = [tempNumber integerValue];
        if ([self isValidArrayIndex:tempIndex]) {
            [self.contentViews addObject:self.imageViews[tempIndex]];
        }
    }
}

- (BOOL)isValidArrayIndex:(NSInteger)index {
    if (index >= 0 && index <= self.totalPagesCount - 1) {
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger)obtainValidNextPageIndex:(NSInteger)currentPageIndex {
    if (currentPageIndex == -1) {
        return self.totalPagesCount - 1;
    } else if (currentPageIndex == self.totalPagesCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    scrollViewStartContentOffsetX = scrollView.contentOffset.x;
    [self.animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationInterval];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    if (self.totalPagesCount == 2) {
        if (scrollViewStartContentOffsetX < contentOffsetX) {
            UIView *tempView = (UIView *)[self.contentViews lastObject];
            tempView.frame = (CGRect){{2 * CGRectGetWidth(scrollView.frame),0},tempView.frame.size};
        } else if (scrollViewStartContentOffsetX > contentOffsetX) {
            UIView *tempView = (UIView *)[self.contentViews firstObject];
            tempView.frame = (CGRect){{0,0},tempView.frame.size};
        }
    }
    
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self obtainValidNextPageIndex:self.currentPageIndex + 1];
        //        NSLog(@"next，当前页:%d",self.currentPageIndex);
        [self configureContentViews];
    }
    if(contentOffsetX <= 0) {
        self.currentPageIndex = [self obtainValidNextPageIndex:self.currentPageIndex - 1];
        //        NSLog(@"previous，当前页:%d",self.currentPageIndex);
        [self configureContentViews];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

#pragma mark - 响应事件

- (void)handleLongGesture:(UILongPressGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateBegan) {
        //        NSLog(@"UIGestureRecognizerStateBegan");
        [self.animationTimer pauseTimer];
    }
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        [self.animationTimer resumeTimer];
        //        NSLog(@"UIGestureRecognizerStateEnded");
    }
}

- (void)animationTimerDidFired:(NSTimer *)timer {
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(autoSlideView:didClickedImageAtIndex:)]) {
        [self.delegate autoSlideView:self didClickedImageAtIndex:self.currentPageIndex];
    }
}

#pragma mark - Accessor

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        self.autoresizesSubviews = YES;
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.autoresizingMask = 0xFF;
        _scrollView.contentMode = UIViewContentModeCenter;
        _scrollView.contentSize = CGSizeMake(kDefaultPageCount * CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (self.totalPagesCount > 1) {
        if (!_pageControl) {
            _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 20, self.scrollView.frame.size.width, 20)];
            _pageControl.numberOfPages = kDefaultPageCount;
            _pageControl.currentPage = 0;
            _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
            _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
            self.currentPageIndex = 0;
        }
    }
    return _pageControl;
}

- (NSTimer *)animationTimer {
    if (!_animationTimer) {
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationInterval ? self.animationInterval : kDefaultAnimationInterval)
                                                           target:self
                                                         selector:@selector(animationTimerDidFired:)
                                                         userInfo:nil
                                                          repeats:YES];
    }
    return _animationTimer;
}

- (void)setTotalPagesCount:(NSInteger)totalPagesCount {
    _totalPagesCount = totalPagesCount;
    if (_totalPagesCount > 0) {
        if (_totalPagesCount > 1) {
            self.scrollView.scrollEnabled = YES;
            self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
            [self.animationTimer resumeTimerAfterTimeInterval:self.animationInterval];
            
            self.pageControl.numberOfPages = _totalPagesCount;
            self.pageControl.hidden = NO;
        } else {
            self.scrollView.scrollEnabled = NO;
            self.pageControl.hidden = YES;
        }
        [self configureContentViews];
        [self addSubview:self.pageControl];
    }
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex {
    _currentPageIndex = currentPageIndex;
    
    [self.pageControl setCurrentPage:_currentPageIndex];
}

- (void)setImageViews:(NSArray *)imageViews {
    _imageViews = imageViews;
    self.totalPagesCount = imageViews.count;
    self.contentViews = [[NSMutableArray alloc] initWithArray:imageViews];
    [self configureContentViews];
    [self.animationTimer resumeTimer];
}

@end

#pragma mark -

@implementation NSTimer (Addition)

-(void)pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}


-(void)resumeTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
