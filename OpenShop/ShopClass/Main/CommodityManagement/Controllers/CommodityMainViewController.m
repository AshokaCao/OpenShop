//
//  CommodityMainViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/1/10.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "CommodityMainViewController.h"
#import "ProductsTableViewCell.h"
#import "ShelveTableViewCell.h"
#import "EditingGoodsViewController.h"
#import "CQCustomActionSheet.h"
#import "MarketListModel.h"
#import "WebViewController.h"
#import "CWActionSheet.h"

@interface CommodityMainViewController () <UITableViewDelegate, UITableViewDataSource, ProductsTableViewCellDelegate, CQCustomActionSheetDelegate, ShelveTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UIButton *saleBtn;
@property (weak, nonatomic) IBOutlet UIButton *shelveBtn;
@property (weak, nonatomic) IBOutlet UIView *saleLine;
@property (weak, nonatomic) IBOutlet UIView *shelveLine;
@property (weak, nonatomic) IBOutlet UIButton *addGoodsBtn;
@property (weak, nonatomic) IBOutlet UITableView *productTableView;
@property (nonatomic ,strong) NSMutableArray *productArray;
@property (nonatomic ,strong) NSString *stadeNum;
@property (nonatomic ,assign) NSInteger goodsPage;

@end

@implementation CommodityMainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getShopGoodsTableWithID:[nNsuserdefaul objectForKey:@"userID"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    self.shelveBtn.selected = NO;
    self.shelveLine.hidden = YES;
    self.saleBtn.selected = !self.shelveBtn.isSelected;
    self.saleLine.hidden = !self.shelveLine.hidden;
    self.stadeNum = @"1";
    self.goodsPage = 1000;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    NSLog(@"[nNsuserdefaul objectForKey -%@",[nNsuserdefaul objectForKey:@"userID"]);
//    [self registTableView];
    [self mjRefalish];
}

- (void)registTableView
{
    [self.productTableView registerNib:[UINib nibWithNibName:@"ProductsTableViewCell" bundle:nil] forCellReuseIdentifier:@"productCell"];
    [self.productTableView registerNib:[UINib nibWithNibName:@"ShelveTableViewCell" bundle:nil] forCellReuseIdentifier:@"shelveCell"];
}

- (void)mjRefalish
{
    self.productTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getShopGoodsTableWithID:[nNsuserdefaul objectForKey:@"userID"]];
    }];
    
    
//    self.productTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        self.goodsPage += 10;
//        [self getShopGoodsTableWithID:[nNsuserdefaul objectForKey:@"userID"]];
//    }];
    
}

- (void)shareAction
{
    CQCustomActionSheet *cusSheet = [[CQCustomActionSheet alloc] init];
    cusSheet.delegate = self;
    NSArray *contenArray = @[@{@"name" : @"Facebook" , @"icon" : @"facebook_icon"},
                             @{@"name" : @"Messenger" , @"icon" : @"messenger_icon"},
                             @{@"name" : @"Line" , @"icon" : @"line_icon"},
                             @{@"name" : @"Instagram" , @"icon" : @"instagram_icon"},
                             @{@"name" : @"Twitter" , @"icon" : @"twitter_icon"},
                             @{@"name" : @"CopyLink" , @"icon" : @"copylink_icon"}];
    [cusSheet showInView:[UIApplication sharedApplication].keyWindow contentArray:contenArray];
}
#pragma mark shareDelegate
- (void)customActionSheetButtonClick:(CQActionSheetButton *)btn
{
    
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
    if (self.productArray.count > 0) {
        if (self.saleBtn.isSelected) {
            [self.productTableView registerNib:[UINib nibWithNibName:@"ProductsTableViewCell" bundle:nil] forCellReuseIdentifier:@"productCell"];
            ProductsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCell" forIndexPath:indexPath];
            if (!cell) {
                cell = [[ProductsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productCell"];
            }
            MarketListModel *model = self.productArray[indexPath.section];
            [cell showProductListWith:model];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (self.shelveBtn.isSelected) {
            [self.productTableView registerNib:[UINib nibWithNibName:@"ShelveTableViewCell" bundle:nil] forCellReuseIdentifier:@"shelveCell"];
            ShelveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shelveCell" forIndexPath:indexPath];
            if (!cell) {
                cell = [[ShelveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shelveCell"];
            }
            MarketListModel *model = self.productArray[indexPath.section];
            [cell showShelveListWith:model];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return nil;
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

- (IBAction)saleBtnAction:(UIButton *)sender {
    self.stadeNum = @"1";
    self.goodsPage = 1000;
    self.shelveBtn.selected = NO;
    self.shelveLine.hidden = YES;
    self.saleBtn.selected = !self.shelveBtn.isSelected;
    self.saleLine.hidden = !self.shelveLine.hidden;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [self getShopGoodsTableWithID:[nNsuserdefaul objectForKey:@"userID"]];
    [self.productTableView reloadData];
}

- (IBAction)shelveAction:(UIButton *)sender {
    self.stadeNum = @"2";
    self.goodsPage = 1000;
    self.shelveBtn.selected = YES;
    self.shelveLine.hidden = NO;
    self.saleBtn.selected = !self.shelveBtn.isSelected;
    self.saleLine.hidden = !self.shelveLine.hidden;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [self getShopGoodsTableWithID:[nNsuserdefaul objectForKey:@"userID"]];
    [self.productTableView reloadData];
}

- (IBAction)addGoodsAction:(UIButton *)sender {
    EditingGoodsViewController *editView = [[EditingGoodsViewController alloc] init];
    [self.navigationController pushViewController:editView animated:YES];
}

- (void)didselectCellWithButton:(UIButton *)btn
{
    ProductsTableViewCell *cell = (ProductsTableViewCell *)[[[btn superview] superview] superview];
    NSIndexPath *pathCell = [self.productTableView indexPathForCell:cell];
    [self shareAction];
}

- (void)getShopGoodsTableWithID:(NSString *)userID
{
    self.productArray = [NSMutableArray array];
    NSString *goodTable = [NSString stringWithFormat:@"http://%@/Good/MyGoodListByState.ashx?userid=%@&pagesize=15&state=%@",publickUrl,userID,self.stadeNum];
    
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"accessToken"] forHTTPHeaderField:@"accesstoken"];
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"refreshToken"] forHTTPHeaderField:@"refreshtoken"];
    
    [PPNetworkHelper GET:goodTable parameters:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject - %@",responseObject);
        [self getGoodTableWith:responseObject];
    } failure:^(NSError *error) {
        NSLog(@"failure");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.productTableView.mj_header endRefreshing];
        [self.productTableView.mj_footer endRefreshing];
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
                [self.productArray addObject:mark];
                NSLog(@"responseObject - %@",self.productArray);
            }
            [self.productTableView reloadData];
        } else {
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:@"没有商品" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alerV show];
            NSLog(@"666666666");
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.productTableView.mj_header endRefreshing];
        [self.productTableView.mj_footer endRefreshing];
    });
}

- (void)selectPreviewBtnWithCell:(UITableViewCell *)cell
{
    WebViewController *webView = [[WebViewController alloc] init];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)saleSelectpromotionBtnWithCell:(UITableViewCell *)cell
{
    NSIndexPath *selectPath =  [self.productTableView indexPathForCell:cell];
    NSLog(@"---------%@",selectPath);
    MarketListModel *mark = self.productArray[selectPath.section];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSArray *title = @[@"Save the picture", @"copy the name & line" , @"copy the name",@"copy the link"];
    CWActionSheet *sheet = [[CWActionSheet alloc] initWithTitles:title clickAction:^(CWActionSheet *sheet, NSIndexPath *indexPath) {
        NSLog(@"点击了%ldd",(long) indexPath.row);
        switch (indexPath.row) {
            case 0:
                
                break;
            case 1:
                pasteboard.string = [NSString stringWithFormat:@"%@,%@",mark.shopname,mark.line];
                break;
                
            case 2:
                pasteboard.string = [NSString stringWithFormat:@"%@,",mark.shopname];
                break;
            case 3:
                pasteboard.string = [NSString stringWithFormat:@"%@,",mark.line];
                break;
                
            default:
                break;
        }
    }];
    [sheet show];
}

- (void)saleSelectPreviewBtnWithCell:(UITableViewCell *)cell
{
    WebViewController *webView = [[WebViewController alloc] init];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)selectOnsaleWithCell:(UITableViewCell *)cell
{
    NSIndexPath *selectPath =  [self.productTableView indexPathForCell:cell];
    NSLog(@"---------%@",selectPath);
    MarketListModel *mark = self.productArray[selectPath.section];
    NSString *stateNum = [NSString stringWithFormat:@"%@",mark.offsale];
    if ([stateNum isEqualToString:@"3"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
        NSLog(@"responseCache - %@",responseObject);
        NSDictionary *diction = responseObject;
        NSLog(@"nNsuserdefaul - %@",[nNsuserdefaul objectForKey:@"accessToken"]);
        if ([diction[@"returncode"] isEqualToString:@"success"]) {
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:@"上架成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alerV show];
            [self.productTableView.mj_header beginRefreshing];
        } else {
            NSString *mess = diction[@"msg"];
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:mess delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alerV show];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:@"上架失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alerV show];
    }];
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
