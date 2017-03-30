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
#import "ContactViewController.h"

@interface MarkerGoodListViewController () <SDCycleScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate, GoodListTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *goodsListTableView;
@property (weak, nonatomic) IBOutlet UIView *tabHeaderView;
@property (nonatomic ,strong) ContactViewController *contactView;
@property (weak, nonatomic) IBOutlet UIButton *contactBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactBtnW;
@property (weak, nonatomic) IBOutlet UIButton *onsaleBtn;
@property (nonatomic ,strong) NSMutableArray *goodsListArray;
@property (nonatomic ,strong) NSMutableArray *goodImageArray;
@property (weak, nonatomic) IBOutlet UILabel *goodTitle;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodIntroduce;
@property (nonatomic ,strong) SDCycleScrollView *cycleScrollView3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleConst;

@end

@implementation MarkerGoodListViewController

- (SDCycleScrollView *)cycleScrollView3
{
    if (!_cycleScrollView3) {
        _cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH *1.04) delegate:self placeholderImage:[UIImage imageNamed:@"shangpingtu_img"]];
    }
    return _cycleScrollView3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ASLocalizedString(@"Sourcing details");
    self.tabBarController.tabBar.translucent = NO;
    self.contactBtnW.constant = SCREEN_WIDTH * 0.597;
    self.titleConst.constant = SCREEN_WIDTH * 1.082;
    [self leftItem];
    
    [self.goodsListTableView registerNib:[UINib nibWithNibName:@"GoodListTableViewCell" bundle:nil] forCellReuseIdentifier:@"goodsList"];
    // 商品详情和列表共用 model
    NSString *goodsID = self.marketModel.idGood;
    [self getGoodsListWithGoodID:goodsID];
    
    [self setSDCycleScrollView];
    [self mjRefalish];
    // Do any additional setup after loading the view from its nib.
}

- (void)leftItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];

    // 设置尺寸
    btn.size = btn.currentBackgroundImage.size;

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -7;//自己设定
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space,leftItem, nil];
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backToMain) image:@"nav_icon_back" highImage:@""];
}

#pragma mark 刷新
- (void)mjRefalish
{
    self.goodsListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self setSDCycleScrollView];
        [self.goodsListTableView.mj_header endRefreshing];
    }];
    
    
    self.goodsListTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [self.goodsListTableView.mj_footer endRefreshing];
    }];
    
}
#pragma mark 轮播图
- (void)setSDCycleScrollView
{
//    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH *1.04) delegate:self placeholderImage:[UIImage imageNamed:@"home_banner"]];
    self.cycleScrollView3.backgroundColor = [UIColor clearColor];
    _cycleScrollView3.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"banner_qiehuandian_selected"];
    _cycleScrollView3.pageDotImage = [UIImage imageNamed:@"banner_qiehuandian_default"];
    //    cycleScrollView3.imageURLStringsGroup = imageArray;
//    NSArray *array = @[@"shangpingtu_img",@"shangpingtu_img",@"shangpingtu_img"];
    
    [self.tabHeaderView addSubview:_cycleScrollView3];
}

- (void)getGoodsListWithGoodID:(NSString *)goodID
{
    NSString *goodsUrl = [NSString stringWithFormat:@"http://%@/Good/GoodDetial.ashx?goodid=%@",publickUrl,goodID];
    [PPNetworkHelper GET:goodsUrl parameters:nil responseCache:^(id responseCache) {
        NSLog(@"responseCache - %@",responseCache);
        if (responseCache != nil) {
            [self getGoodMessageWith:responseCache];
        }
    } success:^(id responseObject) {
        [self getGoodMessageWith:responseObject];
        [self.goodsListTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"failure");
    }];
}

- (void)getGoodMessageWith:(id)some
{
    NSMutableDictionary *goodsList = some;
    self.goodsListArray = [NSMutableArray array];
    self.goodImageArray = [NSMutableArray array];
    NSDictionary *goodDetial = goodsList[@"gooddetial"];
    if (goodDetial != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 商品详情model
            MarketListModel *goodsModel = [[MarketListModel alloc] init];
            [goodsModel setValuesForKeysWithDictionary:goodDetial];
            [self.goodsListArray addObject:goodsModel];
            for (NSDictionary *imageDic in goodDetial[@"goodimg"]) {
                [self.goodImageArray addObject:imageDic[@"path"]];
            }
            self.goodTitle.text = [NSString stringWithFormat:@"%@",goodsModel.goodname];
            self.goodIntroduce.text = [NSString stringWithFormat:@"%@",goodsModel.introduction];
            
            self.priceLabel.text = [NSString stringWithFormat:ASLocalizedString(@"price: $%@"),self.marketModel.price];
            
            NSMutableAttributedString *buyCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:ASLocalizedString(@"profit: $%@"),self.marketModel.profit]];
            NSString *len = [NSString stringWithFormat:ASLocalizedString(@"$%@"),self.marketModel.profit];
            NSString *allLen = [NSString stringWithFormat:ASLocalizedString(@"profit: $%@"),self.marketModel.profit];
            NSLog(@"%@",allLen);
            [buyCount addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff213b"] range:NSMakeRange(allLen.length - len.length, len.length)];
            self.profitLabel.attributedText = buyCount;
            self.saleCountLabel.text = [NSString stringWithFormat:ASLocalizedString(@"%@ distribution"),self.marketModel.discount];
            _cycleScrollView3.localizationImageNamesGroup = self.goodImageArray;
        });
    }
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
    GoodListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"goodsList"];
    MarketListModel *model = [self.goodsListArray firstObject];
    [cell getMessageForModel:model];
//    cell.shopImageView.sd_width = SCREEN_WIDTH * 0.141;
    cell.delegate = self;
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
- (IBAction)shareAndOtherAction:(UIButton *)sender {
    self.contactView = [[ContactViewController alloc] init];
    //设置控制器为弹出类型
    self.contactView.modalPresentationStyle = UIModalPresentationPopover;
    //获得弹出控制器属性
    UIPopoverPresentationController *pover = self.contactView.popoverPresentationController;
    //设置弹出控制器视图的大小
    self.contactView.preferredContentSize = CGSizeMake(SCREEN_WIDTH * 0.349, SCREEN_WIDTH * 0.282);
    //设置弹出控制器背景视图为白透明
    pover.backgroundColor = [UIColor colorWithHexString:@"#333333"];
    pover.delegate = self;
    [pover setSourceView:self.view];//设置在哪个控制器里面弹出来
    [pover setSourceRect:CGRectMake(0, SCREEN_HEIGHT - self.contactBtn.sd_height *2.5, self.contactBtn.sd_width, 80)];//设置弹出视图的位置。
    [pover setPermittedArrowDirections:UIPopoverArrowDirectionUp];//设置弹出类型为任意
    [self presentViewController:self.contactView animated:YES completion:nil];//显示弹出控制器
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    // 此处为不适配(如果选择其他,会自动视频屏幕,上面设置的大小就毫无意义了)
    return UIModalPresentationNone;
}

- (IBAction)onsaleAction:(UIButton *)sender {
    MarketListModel *model = [self.goodsListArray firstObject];
    NSString *goodid = [NSString stringWithFormat:@"%@",model.goodid];
    
    [self onsaleWithGoodID:goodid andUserID:[nNsuserdefaul objectForKey:@"userID"]];
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

- (void)shopList
{
    NSLog(@"noThing");
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
