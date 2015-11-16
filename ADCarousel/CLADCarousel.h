//
//  CLADCarousel.h
//  ADCarousel
//
//  Created by aayongche on 15/11/13.
//  Copyright © 2015年 aayongche. All rights reserved.
//
/**
 *  屏幕大小
 */
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#import <UIKit/UIKit.h>
typedef void(^imageClickBlock)(NSInteger index);

@interface CLADCarousel : UIView
/**
 *  轮播的scrollView
 */
@property (nonatomic, strong) UIScrollView *scrollView;
/**
 *  轮播的页码
 */
@property (nonatomic, strong) UIPageControl *pageControl;
/**
 *  轮播的时间
 */
@property (nonatomic, assign) int time;
/**
 *  默认图片
 */
@property (nonatomic, strong) NSString *placeholderImageStr;

/**
 *  创建一个CLADCarousel的实例
 *
 *  @param frame      坐标
 *  @param imageArray 对应的图片
 *  @param clickBlock 在页面的点击事件
 *  @param plcaceholderImage 默认图片
 *  @return 返回一个CLADCarousel的实例
 */
+ (instancetype)scrollViewWithFrame:(CGRect)frame imageArr:(NSArray *)imageArray AndPlaceholderImage:(UIImage *)image AndImageClickBlock:(imageClickBlock)clickBlock;
/**
 *  创建一个CLADCarousel的实例
 *
 *  @param frame      坐标
 *  @param placeholderImageArray      对应的默认图片显示数组
 *  @param clickBlock 在页面的点击事件
 *
 *  @return 返回一个CLADCarousel的实例
 */
+ (instancetype)scrollViewWithFrame:(CGRect)frame AndPlaceholderImageArray:(NSArray *)placeholderImageArray AndImageClickBlock:(imageClickBlock)clickBlock;

/**
 *  开始定时器
 */
- (void)beginTimer;
/**
 *  结束定时器
 */
- (void)stopTimer;


@end
