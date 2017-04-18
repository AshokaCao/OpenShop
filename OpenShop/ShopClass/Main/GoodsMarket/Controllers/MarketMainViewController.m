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
#import "SearchViewController.h"
#import "DQHotSearchViewController.h"

#import "AllDataViewController.h"
#import "WomenDataViewController.h"
#import "MenDataViewController.h"
#import "ChildDataViewController.h"
#import "MakeupDataViewController.h"
#import "OtherDataViewController.h"
#import "SGSegmentedControl.h"

@interface MarketMainViewController () <SGSegmentedControlStaticDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) SGSegmentedControlStatic *topSView;
@property (nonatomic, strong) SGSegmentedControlBottomView *bottomSView;

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
    
    [self leftItem];
    AllDataViewController *all = [[AllDataViewController alloc] init];
    [self addChildViewController:all];
    WomenDataViewController *women = [[WomenDataViewController alloc] init];
    [self addChildViewController:women];
    MenDataViewController *men = [[MenDataViewController alloc] init];
    [self addChildViewController:men];
    MakeupDataViewController *make = [[MakeupDataViewController alloc] init];
    [self addChildViewController:make];
    ChildDataViewController *chiled = [[ChildDataViewController alloc] init];
    [self addChildViewController:chiled];
    OtherDataViewController *other = [[OtherDataViewController alloc] init];
    [self addChildViewController:other];
    
    NSArray *childVC = @[all, women, men, make, chiled, other];
    
    NSArray *title_arr = @[ASLocalizedString(@"All"),ASLocalizedString(@"Women"),ASLocalizedString(@"Men"),ASLocalizedString(@"Makeup"),ASLocalizedString(@"Child"),ASLocalizedString(@"Other")];
    self.bottomSView = [[SGSegmentedControlBottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bottomSView.childViewController = childVC;
    _bottomSView.backgroundColor = [UIColor clearColor];
    _bottomSView.delegate = self;
    //_bottomView.scrollEnabled = NO;
    [self.view addSubview:_bottomSView];
    
    self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) delegate:self childVcTitle:title_arr indicatorIsFull:NO];
    // 必须实现的方法
    [self.topSView SG_setUpSegmentedControlType:^(SGSegmentedControlStaticType *segmentedControlStaticType, NSArray *__autoreleasing *nomalImageArr, NSArray *__autoreleasing *selectedImageArr) {
        
    }];
    self.topSView.selectedIndex = 0;
    [self.view addSubview:_topSView];

}
- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index {
    NSLog(@"index - - %ld", (long)index);
    // 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.bottomSView.contentOffset = CGPointMake(offsetX, 0);
    [self.bottomSView showChildVCViewWithIndex:index outsideVC:self];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 1.添加子控制器view
    [self.bottomSView showChildVCViewWithIndex:index outsideVC:self];
    
    // 2.把对应的标题选中
    [self.topSView changeThePositionOfTheSelectedBtnWithScrollView:scrollView];
}
//
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
    DQHotSearchViewController *search = [[DQHotSearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

//- (void)mjRefalish
//{
//    self.homeTabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        NSLog(@"self.goodsTypeNum - %@",self.goodsTypeNum);
//        [self getMarketDataListWithType:[self.goodsTypeNum intValue]];
//    }];
//    
//    
//    self.homeTabelView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        self.goodsPage += 10;
//        [self getMarketDataListWithType:[self.goodsTypeNum intValue]];
//    }];
//
//}
//
//#pragma mark 轮播图
//- (void)setSDCycleScrollView
//{
//    [self getScrollViewImageArray];
//    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH *0.4) delegate:self placeholderImage:[UIImage imageNamed:@"home_banner"]];
//    cycleScrollView3.backgroundColor = [UIColor clearColor];
//    cycleScrollView3.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"banner_qiehuandian_selected"];
//    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"banner_qiehuandian_default"];
//    
//    self.cycleScrollView = cycleScrollView3;
////    NSArray *array = @[@"banner_img",@"banner_img",@"banner_img"];
////    cycleScrollView3.localizationImageNamesGroup = array;
//    [self.tabHeaderView addSubview:cycleScrollView3];
//}
//
//- (void)getScrollViewImageArray
//{
//    self.urlImageArray = [NSMutableArray array];
//    NSString *urlImge = [NSString stringWithFormat:@"http://%@/Handler/Banner.ashx",publickUrl];
//    [PPNetworkHelper GET:urlImge parameters:nil success:^(id responseObject) {
//        NSDictionary *dictionary = responseObject;
//        if ([dictionary[@"returncode"] isEqualToString:@"success"]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSArray *array = dictionary[@"bannerlist"];
//                for (NSDictionary *imageDic in array) {
//                    [self.urlImageArray addObject:imageDic[@"img"]];
//                    self.cycleScrollView.imageURLStringsGroup = self.urlImageArray;
//                    NSLog(@"urlImageArray - %@",imageDic[@"img"]);
//                }
//            });
//            [self.homeTabelView reloadData];
//        }
//    } failure:^(NSError *error) {
//        
//    }];
//}
//
//#pragma mark SDCycleScrollViewDelegate
///** 点击图片回调 */
//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
//{
//    NSLog(@"==5");
//}
//
//#pragma mark SegmentedView
//- (void)setSegmentedController
//{
//    NSArray *titleArray = @[@"All",@"Women",@"Men",@"Makeup",@"Child",@"Other"];
//    ZFJSegmentedControl *segment = [[ZFJSegmentedControl alloc] initwithTitleArr:titleArray iconArr:nil SCType:SCType_Underline];
//    segment.frame = CGRectMake(0, 0, SCREEN_WIDTH, 28);
//    segment.backgroundColor = [UIColor whiteColor];
//    segment.titleColor = [UIColor colorWithHexString:@"#585858"];
//    segment.selectBtnSpace = 5;//设置按钮间的间距
////    segment.selectBtnWID = 70;//设置按钮的宽度 不设就是均分
//    segment.SCType_Underline_HEI = 2;//设置底部横线的高度
//    segment.titleFont = [UIFont fontWithName:@"STHeitiSC-Light" size:13];
//    segment.selectType = ^(NSInteger selectIndex,NSString *selectIndexTitle){
//        NSLog(@"selectIndexTitle == %@",selectIndexTitle);
//        if ([selectIndexTitle isEqualToString:ASLocalizedString(@"All")]) {
//            self.goodsTypeNum = @"1";
//            self.goodsPage = 10;
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeIndeterminate;
//        } else if ([selectIndexTitle isEqualToString:ASLocalizedString(@"Women")]) {
//            self.goodsTypeNum = @"3";
//            self.goodsPage = 10;
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeIndeterminate;
//        } else if ([selectIndexTitle isEqualToString:ASLocalizedString(@"Men")]) {
//            self.goodsTypeNum = @"2";
//            self.goodsPage = 10;
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeIndeterminate;
//        } else if ([selectIndexTitle isEqualToString:ASLocalizedString(@"Makeup")]) {
//            self.goodsTypeNum = @"5";
//            self.goodsPage = 10;
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeIndeterminate;
//        } else if ([selectIndexTitle isEqualToString:ASLocalizedString(@"Child")]) {
//            self.goodsTypeNum = @"4";
//            self.goodsPage = 10;
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeIndeterminate;
//        } else if ([selectIndexTitle isEqualToString:ASLocalizedString(@"Other")]) {
//            self.goodsTypeNum = @"6";
//            self.goodsPage = 10;
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeIndeterminate;
//        }
//        [self getMarketDataListWithType:[self.goodsTypeNum intValue]];
//    };
//    [self.view addSubview:segment];
//}
//#pragma mark - 一次性网络状态判断
//- (void)currentNetworkStatus
//{
//    if (kIsNetwork) {
//        NSLog(@"有网络");
//        if (kIsWWANNetwork) {
//            NSLog(@"手机网络");
//        }else if (kIsWiFiNetwork){
//            NSLog(@"WiFi网络");
//        }
//    } 
//    
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return self.marketDataArray.count;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return SCREEN_WIDTH * 0.32;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    HomeGoodListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeList"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (self.marketDataArray.count > 0) {
//        MarketListModel *mark = self.marketDataArray[indexPath.section];
//        [cell getMarkerListWithModel:mark];
//    }
//    cell.delegate = self;
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    MarketListModel *model = self.marketDataArray[indexPath.section];
//    MarkerGoodListViewController *markerList = [[MarkerGoodListViewController alloc] init];
//    markerList.marketModel = model;
//    [self.navigationController pushViewController:markerList animated:YES];
//}
//
//- (void)selectSellWith:(UITableViewCell *)cell
//{
//    NSIndexPath *path = [self.homeTabelView indexPathForCell:cell];
//    MarketListModel *model = self.marketDataArray[path.section];
//    MarkerGoodListViewController *markerList = [[MarkerGoodListViewController alloc] init];
//    markerList.marketModel = model;
//    [self.navigationController pushViewController:markerList animated:YES];
//}
//
//- (void)getMarketDataListWithType:(NSInteger )type
//{
//    self.marketDataArray = [NSMutableArray array];
//    NSString *marketUrl = [NSString stringWithFormat:@"http://%@/Good/GoodsList.ashx?pagesize=%ld&type=%ld",publickUrl,self.goodsPage,type];
//    [PPNetworkHelper GET:marketUrl parameters:nil responseCache:^(id responseCache) {
////        [self getGoodTableWith:responseCache];
//    } success:^(id responseObject) {
//        [self getGoodTableWith:responseObject];
//        NSLog(@"responseObject - %@",responseObject);
//    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [self.homeTabelView.mj_footer endRefreshing];
//        [self.homeTabelView.mj_header endRefreshing];
//        NSLog(@"fail");
//    }];
//}
//
//- (void)getGoodTableWith:(id)some
//{
//    NSMutableDictionary *marketDict = some;
//    NSMutableArray *array = [marketDict valueForKey:@"goodlist"];
//    dispatch_async(dispatch_get_main_queue(), ^{
////        NSLog(@"marketDict - %@",array);
//        if (array.count > 0) {
//            for (NSDictionary *dict in marketDict[@"goodlist"]) {
//                MarketListModel *mark = [[MarketListModel alloc] init];
//                [mark setValuesForKeysWithDictionary:dict];
//                [self.marketDataArray addObject:mark];
////                NSLog(@"responseObject - %@",self.marketDataArray);
//            }
//            [self.homeTabelView reloadData];
//        } else {
//            NSLog(@"666666666");
//        }
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [self.homeTabelView.mj_footer endRefreshing];
//        [self.homeTabelView.mj_header endRefreshing];
//    });
//}

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
