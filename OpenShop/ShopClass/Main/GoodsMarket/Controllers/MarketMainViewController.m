//
//  MarketMainViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/1/10.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "MarketMainViewController.h"
#import "SDCycleScrollView.h"
#import "ZFJSegmentedControl.h"
#import "PPNetworkHelper.h"

@interface MarketMainViewController () <SDCycleScrollViewDelegate>

@end

@implementation MarketMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"网络缓存大小cache = %fMB",[PPNetworkCache getAllHttpCacheSize]/1024/1024.f);
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor grayColor];
    self.title = ASLocalizedString(@"好货市场");
    [self setSegmentedController];
    [self currentNetworkStatus];
//    [self setSDCycleScrollView];
}

#pragma mark 轮播图
- (void)setSDCycleScrollView
{
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 70, SCREEN_WIDTH, 221) delegate:self placeholderImage:[UIImage imageNamed:@"home_banner"]];
    cycleScrollView3.backgroundColor = [UIColor clearColor];
    cycleScrollView3.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"point_selected"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"point_default"];
    //    cycleScrollView3.imageURLStringsGroup = imageArray;
    NSArray *array = @[@"1",@"2",@"3"];
    cycleScrollView3.localizationImageNamesGroup = array;
    
    [self.view addSubview:cycleScrollView3];
}
#pragma mark SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"==5");
}

#pragma mark SegmentedView
- (void)setSegmentedController
{
    NSArray *titleArray = @[@"妆容",@"女装",@"男装",@"小件",@"搭建",@"女装",@"女装",@"女装"];
    ZFJSegmentedControl *segment = [[ZFJSegmentedControl alloc]initwithTitleArr:titleArray iconArr:nil SCType:SCType_Underline];
    segment.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    segment.backgroundColor = [UIColor whiteColor];
    segment.titleColor = [UIColor lightGrayColor];
    segment.selectBtnSpace = 5;//设置按钮间的间距
    segment.selectBtnWID = 70;//设置按钮的宽度 不设就是均分
    segment.SCType_Underline_HEI = 2;//设置底部横线的高度
    segment.titleFont = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
    segment.selectType = ^(NSInteger selectIndex,NSString *selectIndexTitle){
        NSLog(@"selectIndexTitle == %@",selectIndexTitle);
    };
    [self.view addSubview:segment];
}
#pragma mark - 一次性网络状态判断
- (void)currentNetworkStatus
{
    if (kIsNetwork) {
        NSLog(@"有网络");
        if (kIsWWANNetwork) {
            NSLog(@"手机网络");
        }else if (kIsWiFiNetwork){
            NSLog(@"WiFi网络");
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
