//
//  CLAutoSlideView.h
//  CLAutoSlideView
//
//  Created by YuanRong on 15/12/23.
//  Copyright © 2015年 FelixMLians. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class CLAutoSlideView;

@protocol CLAutoSlideViewDelegate <NSObject>

@optional

- (void)autoSlideView:(CLAutoSlideView *)autoSlideView didClickedImageAtIndex:(NSInteger)index;

@end

@interface CLAutoSlideView : UIView

@property (nonatomic, strong) UIScrollView *scrollView;   // main scrollView
@property (nonatomic, copy) NSArray *imageViews;
@property (nonatomic, assign) NSInteger totalPagesCount;  // total pages count, default 1
@property (nonatomic, assign) CGFloat animationInterval;  // interval of slide pages，optional，default is 0.7s

@property (nonatomic, weak) id<CLAutoSlideViewDelegate> delegate;

#pragma mark - Class methods

+ (instancetype)autoSlideViewWithFrame:(CGRect)frame
                              delegate:(id<CLAutoSlideViewDelegate>)delegate
                                images:(NSArray *)images
                     animationInterval:(NSInteger)animationInterval
         currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
                pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor;

#pragma mark - Instance methods

- (instancetype)initWithFrame:(CGRect)frame
                              delegate:(id<CLAutoSlideViewDelegate>)delegate
                                images:(NSArray *)images
                     animationInterval:(NSInteger)animationInterval
         currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
                pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor;
@end

#pragma mark -

@interface NSTimer (Addition)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end