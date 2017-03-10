//
//  MarkerGoodListViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/2/23.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "MarkerGoodListViewController.h"
#import "GoodListTableViewCell.h"
#import "SDCycleScrollView.h"

@interface MarkerGoodListViewController () <SDCycleScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *goodsListTableView;
@property (weak, nonatomic) IBOutlet UIView *tabHeaderView;

@end

@implementation MarkerGoodListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ASLocalizedString(@"Sourcing details");
    self.tabBarController.tabBar.translucent = NO;
    [self leftItem];
    
    [self.goodsListTableView registerNib:[UINib nibWithNibName:@"GoodListTableViewCell" bundle:nil] forCellReuseIdentifier:@"goodsList"];
    [self setSDCycleScrollView];
    [self mjRefalish];
    // Do any additional setup after loading the view from its nib.
}

- (void)leftItem
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backToMain) image:@"nav_icon_back" highImage:@""];
}

#pragma mark 刷新
- (void)mjRefalish
{
    self.goodsListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self setSDCycleScrollView];
        [self.goodsListTableView.mj_header endRefreshing];
    }];
    
    
    self.goodsListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self.goodsListTableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark 轮播图
- (void)setSDCycleScrollView
{
    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH *1.04) delegate:self placeholderImage:[UIImage imageNamed:@"home_banner"]];
    cycleScrollView3.backgroundColor = [UIColor clearColor];
    cycleScrollView3.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"banner_qiehuandian_selected"];
    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"banner_qiehuandian_default"];
    //    cycleScrollView3.imageURLStringsGroup = imageArray;
    NSArray *array = @[@"shangpingtu_img",@"shangpingtu_img",@"shangpingtu_img"];
    cycleScrollView3.localizationImageNamesGroup = array;
    
    [self.tabHeaderView addSubview:cycleScrollView3];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsList"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_WIDTH * 0.344;
}
#pragma mark  back
- (void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
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
