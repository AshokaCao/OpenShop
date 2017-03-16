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

@interface CommodityMainViewController () <UITableViewDelegate, UITableViewDataSource, ProductsTableViewCellDelegate, CQCustomActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIButton *saleBtn;
@property (weak, nonatomic) IBOutlet UIButton *shelveBtn;
@property (weak, nonatomic) IBOutlet UIView *saleLine;
@property (weak, nonatomic) IBOutlet UIView *shelveLine;
@property (weak, nonatomic) IBOutlet UIButton *addGoodsBtn;
@property (weak, nonatomic) IBOutlet UITableView *productTableView;

@end

@implementation CommodityMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    self.shelveBtn.selected = NO;
    self.shelveLine.hidden = YES;
    self.saleBtn.selected = !self.shelveBtn.isSelected;
    self.saleLine.hidden = !self.shelveLine.hidden;
    [self registTableView];
    [self mjRefalish];
}

- (void)registTableView
{
    [self.productTableView registerNib:[UINib nibWithNibName:@"ProductsTableViewCell" bundle:nil] forCellReuseIdentifier:@"productCell"];
    [self.productTableView registerNib:[UINib nibWithNibName:@"ShelveTableViewCell" bundle:nil] forCellReuseIdentifier:@"sheleveCell"];
}

- (void)mjRefalish
{
    self.productTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.productTableView.mj_header endRefreshing];
    }];
    
    
    self.productTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self.productTableView.mj_footer endRefreshing];
    }];
    
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProductsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCell"];
    if (!cell) {
        cell = [[ProductsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productCell"];
    }
    if (indexPath.section == 0) {
        cell.discardView.hidden = YES;
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditingGoodsViewController *editView = [[EditingGoodsViewController alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editView animated:YES];
    self.hidesBottomBarWhenPushed = NO;
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
    self.shelveBtn.selected = NO;
    self.shelveLine.hidden = YES;
    self.saleBtn.selected = !self.shelveBtn.isSelected;
    self.saleLine.hidden = !self.shelveLine.hidden;
}

- (IBAction)shelveAction:(UIButton *)sender {
    self.shelveBtn.selected = YES;
    self.shelveLine.hidden = NO;
    self.saleBtn.selected = !self.shelveBtn.isSelected;
    self.saleLine.hidden = !self.shelveLine.hidden;
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
