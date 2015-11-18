//
//  MainPageArcView.m
//  ADCarousel
//
//  Created by 程磊 on 15/11/17.
//  Copyright © 2015年 aayongche. All rights reserved.
//

#import "MainPageArcView.h"

@implementation MainPageArcView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = self.bounds;
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, self.bounds.size.height/2, self.bounds.size.width, self.bounds.size.height)];
        shapeLayer.path = path.CGPath;
        shapeLayer.fillColor = [UIColor redColor].CGColor;
        shapeLayer.lineWidth = 1;
        shapeLayer.strokeStart = 0.f;
        shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        [self.layer addSublayer:shapeLayer];
    }
    return self;
}

@end
