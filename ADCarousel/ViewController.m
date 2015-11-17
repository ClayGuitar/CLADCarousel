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

@property (nonatomic, strong) CLADCarousel *ad;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *dataArray = [NSMutableArray arrayWithObjects:@"http://photo.l99.com/bigger/03/1359895566588_db3x4f.jpg",@"http://img.hb.aicdn.com/c0b35eed3ce270da5b0c6092a17a8ceb5df317052866-gx7Kbx_fw580",@"http://fb.topit.me/b/35/51/118901491918c5135bl.jpg", nil];
    _ad = [CLADCarousel scrollViewWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 200) imageArr:dataArray AndPlaceholderImage:[UIImage imageNamed:@"a.png"] AndImageClickBlock:^(NSInteger index) {
        NSLog(@"%ld",(long)index);
    }];
    [self.view addSubview:_ad];
    _ad.time = 3;
    [_ad beginTimer];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 220, SCREEN_WIDTH, SCREEN_HEIGHT-220)];
    bottomView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:bottomView];
    
    [self performSelector:@selector(refreshData) withObject:self afterDelay:5];
}

- (void)refreshData {
    NSMutableArray *dataArray = [NSMutableArray arrayWithObjects:@"http://pic14.nipic.com/20110522/7411759_164157418126_2.jpg",@"http://img2.3lian.com/img2007/19/33/005.jpg",@"http://img.taopic.com/uploads/allimg/130501/240451-13050106450911.jpg",@"http://pic25.nipic.com/20121209/9252150_194258033000_2.jpg",@"http://down.tutu001.com/d/file/20101129/2f5ca0f1c9b6d02ea87df74fcc_560.jpg", nil];
    [_ad reloadImageArr:dataArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
