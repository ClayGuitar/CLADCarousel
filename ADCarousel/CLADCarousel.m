//
//  CLADCarousel.m
//  ADCarousel
//
//  Created by aayongche on 15/11/13.
//  Copyright © 2015年 aayongche. All rights reserved.
//

#import "CLADCarousel.h"
#import "UIImageView+WebCache.h"

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
 *  是否显示的是本地数据
 */
@property (nonatomic, assign) BOOL isLocalData;








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
    return [[CLADCarousel alloc] initWithFrame:frame imageArr:imageArray AndPlaceholderImage:image AndPlaceholderImageArray:nil AndImageClickBlock:clickBlock];
}

+ (instancetype)scrollViewWithFrame:(CGRect)frame AndPlaceholderImageArray:(NSArray *)placeholderImageArray AndImageClickBlock:(imageClickBlock)clickBlock{
    return [[CLADCarousel alloc] initWithFrame:frame imageArr:nil AndPlaceholderImage:nil AndPlaceholderImageArray:placeholderImageArray AndImageClickBlock:clickBlock];
}

- (instancetype)initWithFrame:(CGRect)frame imageArr:(NSArray *)imageArray AndPlaceholderImage:(UIImage *)image AndPlaceholderImageArray:(NSArray *)placeholderImageArray AndImageClickBlock:(imageClickBlock)clickBlock{
    if (self = [super initWithFrame:frame]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *plistPath = [paths objectAtIndex:0];
        NSString *filename = [plistPath stringByAppendingPathComponent:@"CLADCarousel.plist"];
        NSArray *totalArray = [NSArray arrayWithContentsOfFile:filename];
        if (imageArray == nil) {
            _isLocalData = YES;
            _imageArr = placeholderImageArray;
        } else {
            _isLocalData = NO;
            _imageArr = imageArray;
        }
        self.clickBlock = clickBlock;
        [self addScrollView];
        [self addScrollViewImageView];
        [self addPageControl];
        if (image != nil) {
            [self setDefaultImageWithPlaceholderImage:image];
        } else {
            [self setDefaultImageWithPlaceholderImageArray];
        }
        self.time = 3;
    }
    return self;
}
/**
 *  初始化scrollView
 */
- (void)addScrollView {
    //初始化scrollview
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

/**
 *  scrollView添加其三个imageView，并将手势加在centerImageView上
 */
- (void)addScrollViewImageView {
    _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.bounds.size.height)];
    [_scrollView addSubview:_leftImageView];
    _centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.bounds.size.height)];
    [_scrollView addSubview:_centerImageView];
    _rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, self.bounds.size.width, self.bounds.size.height)];
    [_scrollView addSubview:_rightImageView];
    //添加手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
    _centerImageView.userInteractionEnabled = YES;
    [_centerImageView addGestureRecognizer:tap];
}
/**
 *  初始化pageControl
 */
- (void)addPageControl {
    //初始化pageControl
    _pageControl = [[UIPageControl alloc] init];
    //注意此方法可以根据页数返回UIPageControl合适的大小
    CGSize size= [_pageControl sizeForNumberOfPages:_imageArr.count];
    _pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    _pageControl.center = CGPointMake(SCREEN_WIDTH/2, self.bounds.size.height-30);
    //设置颜色
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:193/255.0 green:219/255.0 blue:249/255.0 alpha:1];
    //设置当前页颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
    //设置总页数
    _pageControl.numberOfPages = _imageArr.count;
    [self addSubview:_pageControl];
}
/**
 *  设置默认图片,当从网络获取数据的时候
 */
- (void)setDefaultImageWithPlaceholderImage:(UIImage *)image {
    if (_imageArr.count < 2) {
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[_imageArr objectAtIndex:0]] placeholderImage:image];
    } else {
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[_imageArr objectAtIndex:1]] placeholderImage:image];
    }
    [_centerImageView sd_setImageWithURL:[NSURL URLWithString:[_imageArr firstObject]] placeholderImage:image];
    
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[_imageArr lastObject]] placeholderImage:image];
    _currentImageIndex = 0;
    //设置当前页
    _pageControl.currentPage = _currentImageIndex;
}
/**
 *  设置默认图片，当从本地获取图片的时候
 */
- (void)setDefaultImageWithPlaceholderImageArray{
    if (_imageArr.count < 2) {
        _rightImageView.image = [_imageArr objectAtIndex:0];
    } else {
        _rightImageView.image = [_imageArr objectAtIndex:1];
    }
    _centerImageView.image = [_imageArr firstObject];
    _leftImageView.image = [_imageArr lastObject];
    _currentImageIndex = 0;
    //设置当前页
    _pageControl.currentPage = _currentImageIndex;
}

- (void)imageClick:(UITapGestureRecognizer *)tap{
    if (self.clickBlock) {
        self.clickBlock(_pageControl.currentPage);
    }
}

#pragma mark ===========================scrollView的代理方法======================================
#pragma mark 滚动停止事件

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
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
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.time target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    }
}
#pragma mark 摧毁定时器
-(void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark 定时器调用的方法
- (void) handleTimer: (NSTimer *) timer
{
    NSLog(@"===========");
    if (_TimeNum % _time == 0 ) {
        
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

#pragma mark 重新加载图片
-(void)reloadImage{
    int leftImageIndex,rightImageIndex;
    CGPoint offset=[_scrollView contentOffset];
    if (offset.x > SCREEN_WIDTH) { //向右滑动
        _currentImageIndex=(_currentImageIndex+1)%_imageArr.count;
    }else if(offset.x < SCREEN_WIDTH){ //向左滑动
        _currentImageIndex=(_currentImageIndex+(int)_imageArr.count-1)%_imageArr.count;
    }
    if (_isLocalData) {
        _centerImageView.image = [_imageArr objectAtIndex:_currentImageIndex];
        //重新设置左右图片
        leftImageIndex=(_currentImageIndex+(int)_imageArr.count-1)%(int)_imageArr.count;
        rightImageIndex=(_currentImageIndex+1)%(int)_imageArr.count;
        _leftImageView.image = [_imageArr objectAtIndex:leftImageIndex];
        _rightImageView.image = [_imageArr objectAtIndex:rightImageIndex];
    } else {
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:[_imageArr objectAtIndex:_currentImageIndex]] placeholderImage:[UIImage imageNamed:[_imageArr objectAtIndex:_currentImageIndex]]];
        //重新设置左右图片
        leftImageIndex=(_currentImageIndex+(int)_imageArr.count-1)%(int)_imageArr.count;
        rightImageIndex=(_currentImageIndex+1)%(int)_imageArr.count;
        [_leftImageView sd_setImageWithURL:[NSURL URLWithString:[_imageArr objectAtIndex:leftImageIndex]] placeholderImage:[UIImage imageNamed:[_imageArr objectAtIndex:leftImageIndex]]];
        [_rightImageView sd_setImageWithURL:[NSURL URLWithString:[_imageArr objectAtIndex:rightImageIndex]] placeholderImage:[UIImage imageNamed:[_imageArr objectAtIndex:rightImageIndex]]];
    }
    
}

- (void)setTime:(int)time{
    _time = time;
}




@end
