//
//  ViewController.m
//  ADCarousel
//
//  Created by aayongche on 15/11/13.
//  Copyright © 2015年 aayongche. All rights reserved.
//

#import "ViewController.h"
#import "CLADCarousel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *dataArray = [NSMutableArray array];
    UIImage *image1 = [UIImage imageNamed:@"a"];
    UIImage *image2 = [UIImage imageNamed:@"d"];
    UIImage *image3 = [UIImage imageNamed:@"Default"];
    [dataArray addObject:image1];
    [dataArray addObject:image2];
    [dataArray addObject:image3];
    CLADCarousel *ad = [CLADCarousel scrollViewWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 200) AndPlaceholderImageArray:dataArray AndImageClickBlock:^(NSInteger index) {
        NSLog(@"%ld",(long)index);
    }];
    [self.view addSubview:ad];
    ad.time = 2;
    [ad beginTimer];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
