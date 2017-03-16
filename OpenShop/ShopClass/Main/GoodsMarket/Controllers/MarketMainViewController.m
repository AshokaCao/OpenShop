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
#import "HomeGoodListTableViewCell.h"
#import "MarkerGoodListViewController.h"
#import "MarketListModel.h"

@interface MarketMainViewController () <SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *tabHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *homeTabelView;
@property (nonatomic ,strong) NSMutableArray *marketDataArray;

@end

@implementation MarketMainViewController

//- (NSMutableArray *)marketDataArray
//{
//    if (!_marketDataArray) {
//        _marketDataArray = [NSMutableArray array];
//    }
//    return _marketDataArray;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"网络缓存大小cache = %fMB",[PPNetworkCache getAllHttpCacheSize]/1024/1024.f);
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    self.tabHeaderView.sd_height = SCREEN_WIDTH * 0.4;
    self.title = ASLocalizedString(@"Market");
    [self leftItem];
    [self.homeTabelView registerNib:[UINib nibWithNibName:@"HomeGoodListTableViewCell" bundle:nil] forCellReuseIdentifier:@"homeList"];
    [self setSegmentedController];
    [self currentNetworkStatus];
    [self setSDCycleScrollView];
    [self getMarketDataListWithType:1];
    [self mjRefalish];
}

- (void)leftItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_icon_sousuo"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    
    // 设置尺寸
    btn.size = btn.currentBackgroundImage.size;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -7;//自己设定
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space,leftItem, nil];
    //    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backToMain) image:@"nav_icon_back" highImage:@""];
}

- (void)searchClick
{
    
}

- (void)mjRefalish
{
    self.homeTabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setSDCycleScrollView];
        [self.homeTabelView.mj_header endRefreshing];
    }];
    
    
    self.homeTabelView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self.homeTabelView.mj_footer endRefreshing];
    }];

}

#pragma mark 轮播图
- (void)setSDCycleScrollView
{
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH *0.4) delegate:self placeholderImage:[UIImage imageNamed:@"home_banner"]];
    cycleScrollView3.backgroundColor = [UIColor clearColor];
    cycleScrollView3.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"banner_qiehuandian_selected"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"banner_qiehuandian_default"];
    //    cycleScrollView3.imageURLStringsGroup = imageArray;
    NSArray *array = @[@"banner_img",@"banner_img",@"banner_img"];
    cycleScrollView3.localizationImageNamesGroup = array;
    
    [self.tabHeaderView addSubview:cycleScrollView3];
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
    NSArray *titleArray = @[@"All",@"Women",@"Men",@"Makeup",@"Child",@"Other"];
    ZFJSegmentedControl *segment = [[ZFJSegmentedControl alloc] initwithTitleArr:titleArray iconArr:nil SCType:SCType_Underline];
    segment.frame = CGRectMake(0, 0, SCREEN_WIDTH, 28);
    segment.backgroundColor = [UIColor whiteColor];
    segment.titleColor = [UIColor colorWithHexString:@"#585858"];
    segment.selectBtnSpace = 5;//设置按钮间的间距
//    segment.selectBtnWID = 70;//设置按钮的宽度 不设就是均分
    segment.SCType_Underline_HEI = 2;//设置底部横线的高度
    segment.titleFont = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
    segment.selectType = ^(NSInteger selectIndex,NSString *selectIndexTitle){
        NSLog(@"selectIndexTitle == %@",selectIndexTitle);
        if ([selectIndexTitle isEqualToString:ASLocalizedString(@"All")]) {
            [self getMarketDataListWithType:1];
        } else if ([selectIndexTitle isEqualToString:ASLocalizedString(@"Women")]) {
            [self getMarketDataListWithType:3];
        } else if ([selectIndexTitle isEqualToString:ASLocalizedString(@"Men")]) {
            [self getMarketDataListWithType:2];
        } else if ([selectIndexTitle isEqualToString:ASLocalizedString(@"Makeup")]) {
            [self getMarketDataListWithType:5];
        } else if ([selectIndexTitle isEqualToString:ASLocalizedString(@"Child")]) {
            [self getMarketDataListWithType:4];
        } else if ([selectIndexTitle isEqualToString:ASLocalizedString(@"Other")]) {
            [self getMarketDataListWithType:6];
        }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.marketDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_WIDTH * 0.32;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeGoodListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeList"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MarketListModel *mark = self.marketDataArray[indexPath.section];
    [cell getMarkerListWithModel:mark];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarketListModel *model = self.marketDataArray[indexPath.section];
    MarkerGoodListViewController *markerList = [[MarkerGoodListViewController alloc] init];
    markerList.marketModel = model;
    [self.navigationController pushViewController:markerList animated:YES];
}

- (void)getMarketDataListWithType:(NSInteger )type
{
    self.marketDataArray = [NSMutableArray array];
    NSString *marketUrl = [NSString stringWithFormat:@"http://%@/Good/GoodsList.ashx?pagesize=10&type=%ld",publickUrl,type];
    [PPNetworkHelper GET:marketUrl parameters:nil responseCache:^(id responseCache) {
        [self getGoodTableWith:responseCache];
    } success:^(id responseObject) {
        [self getGoodTableWith:responseObject];
//        NSLog(@"responseObject - %@",marketDict[@"goodlist"]);
    } failure:^(NSError *error) {
        
        NSLog(@"fail");
    }];
}

- (void)getGoodTableWith:(id)some
{
    NSMutableDictionary *marketDict = some;
    NSMutableArray *array = [marketDict valueForKey:@"goodlist"];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"marketDict - %@",array);
        if (array.count > 0) {
            for (NSDictionary *dict in marketDict[@"goodlist"]) {
                MarketListModel *mark = [[MarketListModel alloc] init];
                [mark setValuesForKeysWithDictionary:dict];
                [self.marketDataArray addObject:mark];
                NSLog(@"responseObject - %@",self.marketDataArray);
            }
            [self.homeTabelView reloadData];
        } else {
            NSLog(@"666666666");
        }
        
    });
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
