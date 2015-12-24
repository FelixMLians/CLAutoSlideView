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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addAutoSlideImageViews];
    [self addAutoSlideWebViews];
}

// local image view

- (void)addAutoSlideImageViews {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, CGRectGetWidth(self.view.frame), 20)];
    label.text = @"Local Image View";
    [self.view addSubview:label];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    NSMutableArray *viewsArray = [@[] mutableCopy];
    for (int i = 0; i < 3; ++i) {
        UIImageView *imageView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i + 1]];
        imageView.image = image;
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        [viewsArray addObject:imageView];
    }
    
    CGRect frame = CGRectMake(0, 40, CGRectGetWidth(self.view.frame), 200);
    CLAutoSlideView *autoSlideView = [CLAutoSlideView autoSlideViewWithFrame:frame
                                                        delegate:self
                                                          images:viewsArray
                                                           count:3
                                               animationInterval:3.0
                                   currentPageIndicatorTintColor:[UIColor orangeColor]
                                          pageIndicatorTintColor:[UIColor lightGrayColor]];
    autoSlideView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:autoSlideView];
}

// webview

- (void)addAutoSlideWebViews {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 240, CGRectGetWidth(self.view.frame), 20)];
    label.text = @"UIWebView";
    [self.view addSubview:label];
    
    NSArray *webURLs = @[@"http://tieba.baidu.com/photo/p?kw=%E5%9B%BE%E7%89%87&tid=1433290932&pic_id=f11373f082025aafb100f77afbedab64034f1a54", @"http://tieba.baidu.com/photo/p?kw=%E5%9B%BE%E7%89%87&tid=1433290932&pic_id=f11373f082025aafb100f77afbedab64034f1a54#!/pid2a7b02087bf40ad12bdf4e52572c11dfa9ecce4c/pn1", @"http://tieba.baidu.com/photo/p?kw=%E5%9B%BE%E7%89%87&tid=1433290932&pic_id=f11373f082025aafb100f77afbedab64034f1a54#!/pid11adcbef76094b36998d0fa3a3cc7cd98d109d64/pn1"];
    
    NSMutableArray *viewsArray = [@[] mutableCopy];
    for (int i = 0; i < 3; ++i) {
        UIWebView *webView = [[UIWebView alloc] init];
        NSURLRequest *requset = [NSURLRequest requestWithURL:[NSURL URLWithString:webURLs[i]]];
        [webView loadRequest:requset];
        webView.scalesPageToFit = YES;
        webView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        [viewsArray addObject:webView];
    }
    
    CGRect frame = CGRectMake(0, 260, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 260 - 20);
    CLAutoSlideView *autoSlideView = [CLAutoSlideView autoSlideViewWithFrame:frame
                                                                    delegate:self
                                                                      images:viewsArray
                                                                       count:3
                                                           animationInterval:3.0
                                               currentPageIndicatorTintColor:[UIColor orangeColor]
                                                      pageIndicatorTintColor:[UIColor lightGrayColor]];
    autoSlideView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:autoSlideView];
}

#pragma mark - CLAutoSlideViewDelegate

- (void)autoSlideView:(CLAutoSlideView *)autoSlideView didClickedImageAtIndex:(NSInteger)index {
    NSLog(@"autoSlideView did Clicked Image At Index:(%zd)", index);
}

@end
