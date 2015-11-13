//
//  CLADCarousel.h
//  ADCarousel
//
//  Created by aayongche on 15/11/13.
//  Copyright © 2015年 aayongche. All rights reserved.
//

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
@property (nonatomic, assign) CGFloat *time;



@end
