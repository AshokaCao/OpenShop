//
//  ShelveProductsViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/4/20.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "ShelveProductsViewController.h"
#import "ProductsTableViewCell.h"
#import "ShelveTableViewCell.h"
#import "EditingGoodsViewController.h"
#import "CQCustomActionSheet.h"
#import "MarketListModel.h"
#import "WebViewController.h"
#import "CWActionSheet.h"
#import "MarkerGoodListViewController.h"

@interface ShelveProductsViewController () <ShelveTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *shelveTableView;
@property (weak, nonatomic) IBOutlet UIView *nothingView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic ,strong) NSMutableArray *productArray;
@property (nonatomic ,strong) NSString *stadeNum;
@property (nonatomic ,assign) NSInteger goodsPage;

@property (nonatomic ,strong) NSString *shareUrl;
@property (nonatomic ,strong) NSString *shareTitle;
@property (nonatomic ,strong) NSArray *shareImage;

@end

@implementation ShelveProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.addBtn setTitle:ASLocalizedString(@"Add good") forState:UIControlStateNormal];
    [self registTableView];
    self.stadeNum = @"2";
    self.goodsPage = 1000;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow  animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [self getShopGoodsTableWithID:[nNsuserdefaul objectForKey:@"userID"]];
    //    NSLog(@"[nNsuserdefaul objectForKey -%@",[nNsuserdefaul objectForKey:@"userID"]);
    [self mjRefalish];
    self.shelveTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view from its nib.
}

- (void)registTableView
{
    [self.shelveTableView registerNib:[UINib nibWithNibName:@"ShelveTableViewCell" bundle:nil] forCellReuseIdentifier:@"shelveCell"];
    [self.shelveTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)mjRefalish
{
    self.shelveTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getShopGoodsTableWithID:[nNsuserdefaul objectForKey:@"userID"]];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.productArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShelveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shelveCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[ShelveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shelveCell"];
    }
    if (self.productArray.count > 0) {
        MarketListModel *model = self.productArray[indexPath.section];
        [cell showShelveListWith:model];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarketListModel *model = self.productArray[indexPath.section];
    NSString *goodFrom = [NSString stringWithFormat:@"%@",model.goodfrom];
    if ([goodFrom isEqualToString:@"0"]) {
        EditingGoodsViewController *editView = [[EditingGoodsViewController alloc] init];
        //    self.hidesBottomBarWhenPushed = YES;
        editView.editModel = model;
        editView.imageCount = model.imgcount;
        [self.navigationController pushViewController:editView animated:YES];
    } else {
        MarkerGoodListViewController *place = [[MarkerGoodListViewController alloc] init];
        place.marketModel = model;
        //        NSLog(@"----   %@",model);
        [self.navigationController pushViewController:place animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_WIDTH * 0.405;
}
- (void)didselectCellWithButton:(UITableViewCell *)cell
{
    NSIndexPath *prePath = [self.shelveTableView indexPathForCell:cell];
    MarketListModel *marke = self.productArray[prePath.section];
    NSString *goodUrl = [NSString stringWithFormat:@"http://%@/Good/app/gooddetails.aspx?goodid=%@",publickUrl,marke.goodid];
    self.shareUrl = goodUrl;
    self.shareTitle = marke.goodname;
    self.shareImage = [NSArray arrayWithArray:marke.goodimgs];
}

- (void)getShopGoodsTableWithID:(NSString *)userID
{
    NSString *goodTable = [NSString stringWithFormat:@"http://%@/Good/MyGoodListByState.ashx?userid=%@&pagesize=15&state=%@",publickUrl,userID,self.stadeNum];
    
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"accessToken"] forHTTPHeaderField:@"accesstoken"];
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"refreshToken"] forHTTPHeaderField:@"refreshtoken"];
    [PPNetworkHelper GET:goodTable parameters:nil responseCache:^(id responseCache) {
        //        NSLog(@"responseObject - %@",responseCache);
        //        [self getGoodTableWith:responseCache];
    } success:^(id responseObject) {
        NSLog(@"responseObject - - - %@",responseObject);
        [self getGoodTableWith:responseObject];
    } failure:^(NSError *error) {
        self.nothingView.hidden = NO;
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
        [self.shelveTableView.mj_header endRefreshing];
        [self.shelveTableView.mj_footer endRefreshing];
    }];
}

- (void)getGoodTableWith:(id)some
{
    self.productArray = [NSMutableArray array];
    NSMutableDictionary *marketDict = some;
    
    if ([marketDict[@"returncode"] isEqualToString:@"success"]) {
        NSMutableArray *array = [marketDict valueForKey:@"goodlist"];
        dispatch_async(dispatch_get_main_queue(), ^{
            //        NSLog(@"marketDict - %@",array);
            if (array.count > 0) {
                for (NSDictionary *dict in marketDict[@"goodlist"]) {
                    MarketListModel *mark = [[MarketListModel alloc] init];
                    [mark setValuesForKeysWithDictionary:dict];
                    [self.productArray addObject:mark];
                    //                NSLog(@"responseObject - %@",self.productArray);
                }
                self.nothingView.hidden = YES;
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
                [self.shelveTableView.mj_header endRefreshing];
                [self.shelveTableView.mj_footer endRefreshing];
                [self.shelveTableView reloadData];
            } else {
                self.nothingView.hidden = NO;
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
                [self.shelveTableView.mj_header endRefreshing];
                [self.shelveTableView.mj_footer endRefreshing];
            }
        });
        
    } else {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
        NSString *mess = marketDict[@"msg"];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = mess;
        [hud hide:YES afterDelay:2];
        [self.shelveTableView.mj_header endRefreshing];
        [self.shelveTableView.mj_footer endRefreshing];
    }
}

- (void)selectOnsaleWithCell:(UITableViewCell *)cell
{
    NSIndexPath *selectPath =  [self.shelveTableView indexPathForCell:cell];
    NSLog(@"---------%@",selectPath);
    MarketListModel *mark = self.productArray[selectPath.section];
    NSString *stateNum = [NSString stringWithFormat:@"%@",mark.offsale];
    if ([stateNum isEqualToString:@"3"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = ASLocalizedString(@"不能代销");
        [hud hide:YES afterDelay:2];
    } else {
        [self onsaleWithGoodID:mark.goodid andUserID:[nNsuserdefaul objectForKey:@"userID"]];
    }
}

- (void)onsaleWithGoodID:(NSString *)goodid andUserID:(NSString *)userid
{
    NSString *goodsUrl = [NSString stringWithFormat:@"http://%@/Good/GetGood.ashx?goodid=%@&userid=%@",publickUrl,goodid,userid];
    NSLog(@"goodsUrl - %@",goodsUrl);
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"accessToken"] forHTTPHeaderField:@"accesstoken"];
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"refreshToken"] forHTTPHeaderField:@"refreshtoken"];
    [PPNetworkHelper GET:goodsUrl parameters:nil success:^(id responseObject) {
        //        NSLog(@"responseCache - %@",responseObject);
        NSDictionary *diction = responseObject;
        //        NSLog(@"nNsuserdefaul - %@",[nNsuserdefaul objectForKey:@"accessToken"]);
        if ([diction[@"returncode"] isEqualToString:@"success"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = ASLocalizedString(@"Success");
            [hud hide:YES afterDelay:2];
            [self.shelveTableView.mj_header beginRefreshing];
        } else {
            NSString *mess = diction[@"msg"];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = mess;
            [hud hide:YES afterDelay:2];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = ASLocalizedString(@"failure");
        [hud hide:YES afterDelay:2];
    }];
}


- (void)selectPreviewBtnWithCell:(UITableViewCell *)cell
{
    NSIndexPath *prePath = [self.shelveTableView indexPathForCell:cell];
    MarketListModel *marke = self.productArray[prePath.section];
    NSString *goodUrl = [NSString stringWithFormat:@"http://%@/GoodHander/product.aspx?goodid=%@",publickUrl,marke.goodid];
    NSLog(@"%@",goodUrl);
    WebViewController *webView = [[WebViewController alloc] init];
    webView.showUrl = goodUrl;
    [self.navigationController pushViewController:webView animated:YES];
}
- (IBAction)addProtuctAction:(UIButton *)sender {
    EditingGoodsViewController *editView = [[EditingGoodsViewController alloc] init];
    [self.navigationController pushViewController:editView animated:YES];
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
