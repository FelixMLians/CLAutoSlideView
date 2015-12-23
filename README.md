# CLAutoSlideView
🔥 A customized auto slide view! And, infinite loop!

## Introduction

This is a display of advertising or information.

You can add customized views (such as imageView, webview, textView) into auto slide view with a infinite loop. It's so cool!

If you feel good, please give me a star, thank you very much! ⭐️

## Installation

## Non-CocoaPods Installation

Just drag the CLAutoSlideView folder into your project.

## Usage

* Use by including the following import:
````objc
#import "CLAutoSlideView.h"
````
* Demo code:
````objc
// add image views
NSMutableArray *viewsArray = [@[] mutableCopy];
    for (int i = 0; i < 3; ++i) {
        UIImageView *imageView = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i + 1]];
        imageView.image = image;
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
    [self.view addSubview:self.autoSlideView];
````

* Delegate (`@optional`):
````objc
- (void)autoSlideView:(CLAutoSlideView *)autoSlideView didClickedImageAtIndex:(NSInteger)index;
````
* For example:
````objc
#pragma mark - CLAutoSlideViewDelegate

- (void)autoSlideView:(CLAutoSlideView *)autoSlideView didClickedImageAtIndex:(NSInteger)index {
    NSLog(@"autoSlideView did Clicked Image At Index:(%zd)", index);
}

// logs
2015-12-23 19:15:11.518 CLAutoSlideView[6629:2491185] autoSlideView did Clicked Image At Index:(1)
2015-12-23 19:15:14.140 CLAutoSlideView[6629:2491185] autoSlideView did Clicked Image At Index:(2)
````

## Support
* If you have any questions, please commit a issure! Thx!
* Email: felixmorgan109@gmail.com 
* Weibo: http://www.weibo.com/felixmorgan/
* Twitter: https://twitter.com/FelixMLians
* Facebook: https://www.facebook.com/felixmorgan109

### License
[MIT License](http://opensource.org/licenses/MIT)
