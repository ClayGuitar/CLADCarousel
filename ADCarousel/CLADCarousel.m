//
//  CLADCarousel.m
//  ADCarousel
//
//  Created by aayongche on 15/11/13.
//  Copyright © 2015年 aayongche. All rights reserved.
//

#import "CLADCarousel.h"

@interface CLADCarousel ()<UIScrollViewDelegate>
/**
 *  传过来的图片数组
 */
@property (nonatomic, strong) NSArray *imageArr;
/**
 *  定时器
 */
@property (nonatomic, strong) NSTimer *timer;
/**
 *  按钮点击事件
 */
@property (nonatomic, assign) imageClickBlock clickBlock;



@end

@implementation CLADCarousel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)scrollviewWithFrame:(CGRect)frame imageArr:(NSArray *)imageArray AndImageClickBlock:(imageClickBlock)clickBlock{
    return [[CLADCarousel alloc] initWithFrame:frame imageArr:imageArray AndImageClickBlock:clickBlock];
}

- (instancetype)initWithFrame:(CGRect)frame imageArr:(NSArray *)imageArray AndImageClickBlock:(imageClickBlock)clickBlock{
    if (self = [super initWithFrame:frame]) {
        //初始化scrollview
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
        _scrollView.delegate = self;
        //设置显示当前图片
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
        
        //初始化pageControl
        _pageControl = [[UIPageControl alloc] init];
        //注意此方法可以根据页数返回UIPageControl合适的大小
        CGSize size= [_pageControl sizeForNumberOfPages:imageArray.count];
        _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
        _pageControl.center = CGPointMake(SCREEN_WIDTH/2, frame.size.height-30);
        //设置颜色
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:193/255.0 green:219/255.0 blue:249/255.0 alpha:1];
        //设置当前页颜色
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
        //设置总页数
        _pageControl.numberOfPages = imageArray.count;
        [self addSubview:_pageControl];
        self.time = 3;
    }
    return self;
}



@end
