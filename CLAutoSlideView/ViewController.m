//
//  ViewController.m
//  CLAutoSlideView
//
//  Created by YuanRong on 15/12/23.
//  Copyright © 2015年 FelixMLians. All rights reserved.
//

#import "ViewController.h"
#import "CLAutoSlideView.h"

@interface ViewController ()<CLAutoSlideViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) CLAutoSlideView *autoSlideView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addAutoSlideViews];
}

- (void)addAutoSlideViews {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    NSMutableArray *viewsArray = [@[] mutableCopy];
    for (int i = 0; i < 3; ++i) {
        UIImageView *imageView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i + 1]];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        [viewsArray addObject:imageView];
    }
    
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    self.autoSlideView = [CLAutoSlideView autoSlideViewWithFrame:frame
                                                        delegate:self
                                                          images:viewsArray
                                                           count:3
                                               animationInterval:3.0
                                   currentPageIndicatorTintColor:[UIColor orangeColor]
                                          pageIndicatorTintColor:[UIColor lightGrayColor]];
    self.autoSlideView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.autoSlideView];
}

#pragma mark - CLAutoSlideViewDelegate

- (void)autoSlideView:(CLAutoSlideView *)autoSlideView didClickedImageAtIndex:(NSInteger)index {
    NSLog(@"autoSlideView did Clicked Image At Index:(%zd)", index);
}

@end
