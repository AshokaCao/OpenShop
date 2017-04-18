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
#import "WebViewController.h"

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
@property (nonatomic ,strong) NSString *goodID;

@end

@implementation MarkerGoodListViewController

- (SDCycleScrollView *)cycleScrollView3
{
    if (!_cycleScrollView3) {
        _cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH *1.04) delegate:self placeholderImage:[UIImage imageNamed:@"shangpingtu_img"]];
    }
    return _cycleScrollView3;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    NSLog(@"goodIntroduce 2 - %f",self.goodIntroduce.sd_height);
    if (self.goodIntroduce.sd_height < 45) {
        self.tabHeaderView.sd_height = SCREEN_WIDTH * 1.04 + 62 + 90;
    } else {
        self.tabHeaderView.sd_height = SCREEN_WIDTH * 1.04 + self.goodIntroduce.sd_height + 120;
    }
    [self.goodsListTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    self.title = ASLocalizedString(@"Sourcing details");
    [self.contactBtn setTitle:ASLocalizedString(@"contact") forState:UIControlStateNormal];
    self.tabBarController.tabBar.translucent = NO;
    self.contactBtnW.constant = SCREEN_WIDTH * 0.597;
    self.titleConst.constant = SCREEN_WIDTH * 1.082;
    [self leftItem];
    
    [self.goodsListTableView registerNib:[UINib nibWithNibName:@"GoodListTableViewCell" bundle:nil] forCellReuseIdentifier:@"goodsList"];
    // 商品详情和列表共用 model
    
    NSString *goodsID = self.marketModel.goodid;
    NSLog(@"goodid - %@",self.marketModel);
    [self getGoodsListWithGoodID:goodsID andUserID:[nNsuserdefaul objectForKey:@"userID"]];
    
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
        NSString *goodsID = self.marketModel.idGood;
        [self getGoodsListWithGoodID:goodsID andUserID:[nNsuserdefaul objectForKey:@"userID"]];
        
    }];
}
#pragma mark 轮播图
- (void)setSDCycleScrollView
{
//    SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH *1.04) delegate:self placeholderImage:[UIImage imageNamed:@"home_banner"]];
    self.cycleScrollView3.backgroundColor = [UIColor clearColor];
    _cycleScrollView3.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"banner_qiehuandian_selected"];
    _cycleScrollView3.placeholderImage = [UIImage imageNamed:@"shangpintuneiye_img_default"];
    _cycleScrollView3.pageDotImage = [UIImage imageNamed:@"banner_qiehuandian_default"];
    //    cycleScrollView3.imageURLStringsGroup = imageArray;
//    NSArray *array = @[@"shangpingtu_img",@"shangpingtu_img",@"shangpingtu_img"];
    
    [self.tabHeaderView addSubview:_cycleScrollView3];
}

- (void)getGoodsListWithGoodID:(NSString *)goodID andUserID:(NSString *)userID
{
    NSString *goodsUrl = [NSString stringWithFormat:@"http://%@/Good/GoodDetial.ashx?goodid=%@&userid=%@",publickUrl,goodID,userID];
    
    [PPNetworkHelper GET:goodsUrl parameters:nil success:^(id responseObject) {
        NSLog(@"responseCache - %@",responseObject);
        [self getGoodMessageWith:responseObject];
    } failure:^(NSError *error) {
        NSLog(@"failure - %@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.goodsListTableView.mj_header endRefreshing];
    }];
}

- (void)getGoodMessageWith:(id)some
{
    NSMutableDictionary *goodsList = some;
    self.goodsListArray = [NSMutableArray array];
    self.goodImageArray = [NSMutableArray array];
    NSDictionary *goodDetial = goodsList[@"gooddetial"];
//    NSLog(@"goodDetial - %@",goodDetial);
    if (goodDetial != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // 商品详情model
            MarketListModel *goodsModel = [[MarketListModel alloc] init];
            [goodsModel setValuesForKeysWithDictionary:goodDetial];
            [self.goodsListArray addObject:goodsModel];
            for (NSDictionary *imageDic in goodDetial[@"goodimg"]) {
                [self.goodImageArray addObject:imageDic[@"path"]];
            }
            self.goodID = [NSString stringWithFormat:@"%@",goodsModel.goodid];
            NSString *isOnsale = [NSString stringWithFormat:@"%@",goodsModel.exist];
            if ([isOnsale isEqualToString:@"1"]) {
                [self.onsaleBtn setTitle:ASLocalizedString(@"off shelve") forState:UIControlStateNormal];
            } else {
                [self.onsaleBtn setTitle:ASLocalizedString(@"On sale") forState:UIControlStateNormal];
            }
            self.goodTitle.text = [NSString stringWithFormat:@"%@",goodsModel.goodname];
            
            
            NSString *strHtml = [NSString stringWithFormat:@"%@",goodsModel.introduction];
            NSAttributedString * strAtt = [[NSAttributedString alloc] initWithData:[strHtml dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            CGSize titleSize = [strHtml boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 28, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
//            if (titleSize.height > 130) {
//                self.tabHeaderView.sd_height = SCREEN_WIDTH * 1.04 + titleSize.height + 90;
//            } else {
//                self.tabHeaderView.sd_height = SCREEN_WIDTH * 1.04 + titleSize.height + 120;
//            }
            
            self.goodIntroduce.attributedText = strAtt;
            NSLog(@"goodIntroduce - %f",self.goodIntroduce.sd_height);
            self.priceLabel.text = [NSString stringWithFormat:ASLocalizedString(@"price: ฿%@"),self.marketModel.price];
            
            NSMutableAttributedString *buyCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:ASLocalizedString(@"profit: ฿%@"),self.marketModel.profit]];
            NSString *len = [NSString stringWithFormat:ASLocalizedString(@"฿%@"),self.marketModel.profit];
            NSString *allLen = [NSString stringWithFormat:ASLocalizedString(@"profit: ฿%@"),self.marketModel.profit];
            
            [buyCount addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff213b"] range:NSMakeRange(allLen.length - len.length, len.length)];
            self.profitLabel.attributedText = buyCount;
            self.saleCountLabel.text = [NSString stringWithFormat:ASLocalizedString(@"%@ distribution"),self.marketModel.discount];
            _cycleScrollView3.localizationImageNamesGroup = self.goodImageArray;
            [self.goodsListTableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.goodsListTableView.mj_header endRefreshing];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    MarketListModel *model = [self.goodsListArray firstObject];
    self.contactView = [[ContactViewController alloc] init];
    //设置控制器为弹出类型
    self.contactView.modalPresentationStyle = UIModalPresentationPopover;
    self.contactView.phoneNum = model.shopphone;
    self.contactView.facebookNum = model.facebook;
    self.contactView.lineNum = model.line;
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
    if ([self.onsaleBtn.currentTitle isEqualToString:ASLocalizedString(@"On sale")]) {
        [self onsaleWithGoodID:goodid andUserID:[nNsuserdefaul objectForKey:@"userID"]];
    } else {
        NSString *shelvrUrl = [NSString stringWithFormat:@"http://%@/Good/ShelfGood.ashx",publickUrl];
        NSMutableDictionary *diction = [NSMutableDictionary dictionary];
        diction[@"goodid"] = self.goodID;
        diction[@"userid"] = [nNsuserdefaul objectForKey:@"userID"];
        
        [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"accessToken"] forHTTPHeaderField:@"accesstoken"];
        [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"refreshToken"] forHTTPHeaderField:@"refreshtoken"];
        [PPNetworkHelper POST:shelvrUrl parameters:diction success:^(id responseObject) {
            NSLog(@"xiajia   %@",responseObject);
            NSDictionary *dic = responseObject;
            if ([dic[@"returncode"] isEqualToString:@"success"]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = ASLocalizedString(@"success");
                [hud hide:YES afterDelay:2];
//                [self.navigationController popViewControllerAnimated:YES];
            } else {
                NSString *mess = dic[@"msg"];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = mess;
                [hud hide:YES afterDelay:2];
            }
        } failure:^(NSError *error) {
            NSLog(@"goutongshib");
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = ASLocalizedString(@"failure");
            [hud hide:YES afterDelay:2];
        }];

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
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = ASLocalizedString(@"Success");
            [hud hide:YES afterDelay:2];
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
        hud.labelText = ASLocalizedString(@"网络错误");
        [hud hide:YES afterDelay:2];
    }];
}

- (void)shopList
{
    NSLog(@"noThing");
    NSString *shopInfo = [NSString stringWithFormat:@"http://%@/GoodHander/shop_preview.aspx?shopid=%@",publickUrl,self.marketModel.shopid];
    WebViewController *web = [[WebViewController alloc] init];
    web.showUrl = shopInfo;
    [self.navigationController pushViewController:web animated:YES];
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
