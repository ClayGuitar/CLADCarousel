//
//  CLADCarousel.m
//  ADCarousel
//
//  Created by 程磊 on 15/11/13.
//  Copyright © 2015年 aayongche. All rights reserved.
//

#import "CLADCarousel.h"
#import "UIImageView+WebCache.h"
#import "MainPageArcView.h"

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
/**
 *  左边的视图
 */
@property (nonatomic, strong) UIImageView *leftImageView;
/**
 *  中间显示的视图
 */
@property (nonatomic, strong) UIImageView *centerImageView;
/**
 *  右边的视图
 */
@property (nonatomic, strong) UIImageView *rightImageView;
/**
 *  当前图片索引，即pageControl的currentPage
 */
@property (nonatomic, assign) int currentImageIndex;
/**
 *  设定轮播时间+1
 */
@property (nonatomic, assign) int TimeNum;

/**
 *  检查图片是否显示到最后一页了
 */
@property (nonatomic, assign) BOOL Tend;
/**
 *  默认图片
 */
@property (nonatomic, strong) UIImage *placehloderImage;

@end

@implementation CLADCarousel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)scrollViewWithFrame:(CGRect)frame imageArr:(NSArray *)imageArray AndPlaceholderImage:(UIImage *)image AndImageClickBlock:(imageClickBlock)clickBlock{
    return [[CLADCarousel alloc] initWithFrame:frame imageArr:imageArray AndPlaceholderImage:image AndImageClickBlock:clickBlock];
}

//+ (instancetype)scrollViewWithFrame:(CGRect)frame AndPlaceholderImageArray:(NSArray *)placeholderImageArray AndPlaceholderImage:(UIImage *)image AndImageClickBlock:(imageClickBlock)clickBlock{
//    return [[CLADCarousel getSingleClass] initWithFrame:frame imageArr:nil AndPlaceholderImage:image AndPlaceholderImageArray:placeholderImageArray AndImageClickBlock:clickBlock];
//}

- (instancetype)initWithFrame:(CGRect)frame imageArr:(NSArray *)imageArray AndPlaceholderImage:(UIImage *)image AndImageClickBlock:(imageClickBlock)clickBlock{
    if (self = [super initWithFrame:frame]) {
        _TimeNum = 1;
        _placehloderImage = image;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *plistPath = [paths objectAtIndex:0];
        NSString *filename = [plistPath stringByAppendingPathComponent:@"CLADCarousel.plist"];
        NSArray *totalArray = [NSArray arrayWithContentsOfFile:filename];
        _imageArr = imageArray;
        self.clickBlock = clickBlock;
        [self addScrollView];
        [self addScrollViewImageView];
        [self addPageControl];
        [self setDefaultImage];
//        MainPageArcView *mainPageArcView = [[MainPageArcView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-30, SCREEN_WIDTH, 30)];
//        [self addSubview:mainPageArcView];
        self.time = 3;
    }
    return self;
}

/**
 *  初始化scrollView
 */
- (void)addScrollView {
    //初始化scrollview
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _scrollView.delegate = self;
        //设置显示当前图片
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, 0);
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
    }
}

/**
 *  scrollView添加其三个imageView，并将手势加在centerImageView上
 */
- (void)addScrollViewImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.bounds.size.height)];
        [_scrollView addSubview:_leftImageView];
    }
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, self.bounds.size.width, self.bounds.size.height)];
        [_scrollView addSubview:_rightImageView];
    }
    if (!_centerImageView) {
        _centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.bounds.size.height)];
        [_scrollView addSubview:_centerImageView];
        //添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
        _centerImageView.userInteractionEnabled = YES;
        [_centerImageView addGestureRecognizer:tap];
    }
}

/**
 *  初始化pageControl
 */
- (void)addPageControl {
    if (!_pageControl) {
        //初始化pageControl
        _pageControl = [[UIPageControl alloc] init];
        //注意此方法可以根据页数返回UIPageControl合适的大小
        CGSize size = [_pageControl sizeForNumberOfPages:_imageArr.count];
        _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
        _pageControl.center = CGPointMake(SCREEN_WIDTH/2, self.bounds.size.height-30);
        //设置颜色
        _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:193/255.0 green:219/255.0 blue:249/255.0 alpha:1];
        //设置当前页颜色
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
        [self addSubview:_pageControl];
    }
    //设置总页数
    _pageControl.numberOfPages = _imageArr.count;
}

/**
 *  设置默认图片,当从网络获取数据的时候
 */
- (void)setDefaultImage {
    if (_imageArr.count < 2) {
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[_imageArr objectAtIndex:0]] placeholderImage:_placehloderImage];
    } else {
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[_imageArr objectAtIndex:1]] placeholderImage:_placehloderImage];
    }
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:[_imageArr firstObject]] placeholderImage:_placehloderImage];
    
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[_imageArr lastObject]] placeholderImage:_placehloderImage];
    _currentImageIndex = 0;
    //设置当前页
    _pageControl.currentPage = _currentImageIndex;
}

- (void)imageClick:(UITapGestureRecognizer *)tap{
    if (self.clickBlock) {
        self.clickBlock(_pageControl.currentPage);
    }
}

#pragma mark-===========================scrollView的代理方法======================================
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self beginTimer];
    //重新加载图片
    [self reloadImage];
    //移动到中间
    [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    //设置分页
    _pageControl.currentPage = _currentImageIndex;
}

#pragma mark-===========================定时器===============================
#pragma mark 初始化定时器
-(void)beginTimer
{
    if(self.timer == nil)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    }
}
#pragma mark 摧毁定时器
-(void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark 定时器调用的方法
- (void)handleTimer: (NSTimer *)timer{
    if (_TimeNum % _time == 0) {
        if (!_Tend) {
            _pageControl.currentPage++;
            if (_pageControl.currentPage == _pageControl.numberOfPages-1) {
                _Tend=YES;
            }
        }else{
            _pageControl.currentPage = 0;
            _Tend=NO;
        }
        [UIView animateWithDuration:0.7 //速度0.7秒
                         animations:^{//修改坐标
                             _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * 2,0);
                         }];
        [self reloadImage];
        [_scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    }
    _TimeNum ++;
}

#pragma mark- 重新加载图片
-(void)reloadImage{
    int leftImageIndex,rightImageIndex;
    CGPoint offset = [_scrollView contentOffset];
    if (offset.x > SCREEN_WIDTH) { //向右滑动
        _currentImageIndex = (_currentImageIndex+1) % _imageArr.count;
    }else if(offset.x < SCREEN_WIDTH){ //向左滑动
        _currentImageIndex = (_currentImageIndex+(int)_imageArr.count-1) % _imageArr.count;
    }
    if (_currentImageIndex == _pageControl.numberOfPages-1) {
        _Tend = YES;
    } else {
        _Tend = NO;
    }
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:[_imageArr objectAtIndex:_currentImageIndex]] placeholderImage:_placehloderImage];
    //重新设置左右图片
    leftImageIndex = (_currentImageIndex+(int)_imageArr.count-1) % (int)_imageArr.count;
    rightImageIndex = (_currentImageIndex+1) % (int)_imageArr.count;
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[_imageArr objectAtIndex:leftImageIndex]] placeholderImage:_placehloderImage];
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[_imageArr objectAtIndex:rightImageIndex]] placeholderImage:_placehloderImage];
}

- (void)setTime:(int)time{
    _time = time;
}

- (void)reloadImageArr:(NSArray *)imageArr{
    [self stopTimer];
    _TimeNum = 1;
    _imageArr = imageArr;
    [self addScrollView];
    [self addScrollViewImageView];
    [self addPageControl];
    [self setDefaultImage];
    [self beginTimer];
}

@end
