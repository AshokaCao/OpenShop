//
//  SearchViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/3/28.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "SearchViewController.h"
#import "HomeGoodListTableViewCell.h"
#import "MarketListModel.h"
#import "MarkerGoodListViewController.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, HomeGoodListTableViewCellDelegate>
@property (nonatomic ,strong) NSMutableArray *marketDataArray;
@property (nonatomic ,strong) NSString *goodsTypeNum;
@property (nonatomic ,assign) NSInteger goodsPage;
@property (weak, nonatomic) IBOutlet UITableView *searchShowTableView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    [self addSearchView];
    self.title = self.searchStr;
    [self.searchShowTableView registerNib:[UINib nibWithNibName:@"HomeGoodListTableViewCell" bundle:nil] forCellReuseIdentifier:@"homeList"];
    [self getMarketDataListWithStr:self.searchStr];
    self.searchShowTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    NSIndexPath *path = [self.searchShowTableView indexPathForCell:cell];
    MarketListModel *model = self.marketDataArray[path.section];
    MarkerGoodListViewController *markerList = [[MarkerGoodListViewController alloc] init];
    markerList.marketModel = model;
    [self.navigationController pushViewController:markerList animated:YES];
}

- (void)getMarketDataListWithStr:(NSString *)string
{
    self.marketDataArray = [NSMutableArray array];
    NSString *marketUrl = [NSString stringWithFormat:@"http://%@/Good/GoodsSearch.ashx?str=%@",publickUrl,string];
    [PPNetworkHelper GET:marketUrl parameters:nil responseCache:^(id responseCache) {
        //        [self getGoodTableWith:responseCache];
    } success:^(id responseObject) {
        [self getGoodTableWith:responseObject];
        NSLog(@"responseObject - %@",responseObject);
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.searchShowTableView.mj_footer endRefreshing];
        [self.searchShowTableView.mj_header endRefreshing];
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
            [self.searchShowTableView reloadData];
        } else {
            NSLog(@"666666666");
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.searchShowTableView.mj_footer endRefreshing];
        [self.searchShowTableView.mj_header endRefreshing];
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
