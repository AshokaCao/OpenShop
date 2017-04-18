//
//  WomenDataViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/4/13.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "WomenDataViewController.h"
#import "SDCycleScrollView.h"
#import "ZFJSegmentedControl.h"
#import "PPNetworkHelper.h"
#import "HomeGoodListTableViewCell.h"
#import "MarkerGoodListViewController.h"
#import "MarketListModel.h"

@interface WomenDataViewController () <SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, HomeGoodListTableViewCellDelegate>
@property (nonatomic ,strong) NSMutableArray *marketDataArray;
@property (nonatomic ,strong) NSMutableArray *urlImageArray;
@property (nonatomic ,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic ,strong) NSString *goodsTypeNum;
@property (nonatomic ,assign) NSInteger goodsPage;
@property (nonatomic ,strong) UITableView *alltableView;

@end

@implementation WomenDataViewController


- (UITableView *)alltableView
{
    if (!_alltableView) {
        _alltableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 108)];
        [self.alltableView registerNib:[UINib nibWithNibName:@"HomeGoodListTableViewCell" bundle:nil] forCellReuseIdentifier:@"homeList"];
        _alltableView.delegate = self;
        _alltableView.dataSource = self;
        [self.view addSubview:self.alltableView];
    }
    return _alltableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    //    self.tabHeaderView.sd_height = SCREEN_WIDTH * 0.4;
    self.title = ASLocalizedString(@"Market");
    self.goodsPage = 10;
    self.goodsTypeNum = @"3";
    [self currentNetworkStatus];
    [self setSDCycleScrollView];
    [self getMarketDataListWithType:3];
    [self mjRefalish];
    self.alltableView.tableHeaderView = self.cycleScrollView;
}
- (void)mjRefalish
{
    self.alltableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"self.goodsTypeNum - %@",self.goodsTypeNum);
        [self getScrollViewImageArray];
        [self getMarketDataListWithType:[self.goodsTypeNum intValue]];
    }];
    
    
    self.alltableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.goodsPage += 10;
        [self getMarketDataListWithType:[self.goodsTypeNum intValue]];
    }];
    
}

#pragma mark 轮播图
- (void)setSDCycleScrollView
{
    [self getScrollViewImageArray];
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH *0.4) delegate:self placeholderImage:[UIImage imageNamed:@"home_banner"]];
    cycleScrollView3.backgroundColor = [UIColor clearColor];
    cycleScrollView3.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"banner_qiehuandian_selected"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"banner_qiehuandian_default"];
    cycleScrollView3.placeholderImage = [UIImage imageNamed:@"banner_img_default"];
    
    self.cycleScrollView = cycleScrollView3;
}

- (void)getScrollViewImageArray
{
    self.urlImageArray = [NSMutableArray array];
    NSString *urlImge = [NSString stringWithFormat:@"http://%@/Handler/Banner.ashx",publickUrl];
    [PPNetworkHelper GET:urlImge parameters:nil success:^(id responseObject) {
        NSDictionary *dictionary = responseObject;
        if ([dictionary[@"returncode"] isEqualToString:@"success"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSArray *array = dictionary[@"bannerlist"];
                for (NSDictionary *imageDic in array) {
                    [self.urlImageArray addObject:imageDic[@"img"]];
                    self.cycleScrollView.imageURLStringsGroup = self.urlImageArray;
                    NSLog(@"urlImageArray - %@",imageDic[@"img"]);
                }
            });
            [self.alltableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"==5");
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
    if (self.marketDataArray.count > 0) {
        MarketListModel *mark = self.marketDataArray[indexPath.section];
        [cell getMarkerListWithModel:mark];
    }
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarketListModel *model = self.marketDataArray[indexPath.section];
    MarkerGoodListViewController *markerList = [[MarkerGoodListViewController alloc] init];
    markerList.marketModel = model;
    [self.navigationController pushViewController:markerList animated:YES];
}

- (void)selectSellWith:(UITableViewCell *)cell
{
    NSIndexPath *path = [self.alltableView indexPathForCell:cell];
    MarketListModel *model = self.marketDataArray[path.section];
    MarkerGoodListViewController *markerList = [[MarkerGoodListViewController alloc] init];
    markerList.marketModel = model;
    [self.navigationController pushViewController:markerList animated:YES];
}

- (void)getMarketDataListWithType:(NSInteger )type
{
    self.marketDataArray = [NSMutableArray array];
    NSString *marketUrl = [NSString stringWithFormat:@"http://%@/Good/GoodsList.ashx?pagesize=%ld&type=%ld",publickUrl,self.goodsPage,type];
    [PPNetworkHelper GET:marketUrl parameters:nil responseCache:^(id responseCache) {
        //        [self getGoodTableWith:responseCache];
    } success:^(id responseObject) {
        [self getGoodTableWith:responseObject];
        NSLog(@"responseObject - %@",responseObject);
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.alltableView.mj_footer endRefreshing];
        [self.alltableView.mj_header endRefreshing];
        NSLog(@"fail");
    }];
}

- (void)getGoodTableWith:(id)some
{
    NSMutableDictionary *marketDict = some;
    NSMutableArray *array = [marketDict valueForKey:@"goodlist"];
    dispatch_async(dispatch_get_main_queue(), ^{
        //        NSLog(@"marketDict - %@",array);
        if (array.count > 0) {
            for (NSDictionary *dict in marketDict[@"goodlist"]) {
                MarketListModel *mark = [[MarketListModel alloc] init];
                [mark setValuesForKeysWithDictionary:dict];
                [self.marketDataArray addObject:mark];
                //                NSLog(@"responseObject - %@",self.marketDataArray);
            }
            [self.alltableView reloadData];
        } else {
            NSLog(@"666666666");
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.alltableView.mj_footer endRefreshing];
        [self.alltableView.mj_header endRefreshing];
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
