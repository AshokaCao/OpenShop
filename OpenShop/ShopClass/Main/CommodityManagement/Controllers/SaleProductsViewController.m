//
//  SaleProductsViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/4/20.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "SaleProductsViewController.h"
#import "ProductsTableViewCell.h"
#import "ShelveTableViewCell.h"
#import "EditingGoodsViewController.h"
#import "CQCustomActionSheet.h"
#import "MarketListModel.h"
#import "WebViewController.h"
#import "CWActionSheet.h"
#import "MarkerGoodListViewController.h"

#import "LoginHomeViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <MOBFoundation/MOBFoundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface SaleProductsViewController () <UITableViewDelegate, UITableViewDataSource, ProductsTableViewCellDelegate, CQCustomActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *saleTableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIView *nothingView;

@property (nonatomic ,strong) NSMutableArray *productArray;
@property (nonatomic ,strong) NSString *stadeNum;
@property (nonatomic ,assign) NSInteger goodsPage;

@property (nonatomic ,strong) NSString *shareUrl;
@property (nonatomic ,strong) NSString *shareTitle;
@property (nonatomic ,strong) NSArray *shareImage;
@end

@implementation SaleProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.addBtn setTitle:ASLocalizedString(@"Add good") forState:UIControlStateNormal];
    [self registTableView];
    self.stadeNum = @"1";
    self.goodsPage = 1000;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow  animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [self getShopGoodsTableWithID:[nNsuserdefaul objectForKey:@"userID"]];
    //    NSLog(@"[nNsuserdefaul objectForKey -%@",[nNsuserdefaul objectForKey:@"userID"]);
    [self mjRefalish];
    self.saleTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)registTableView
{
    [self.saleTableView registerNib:[UINib nibWithNibName:@"ProductsTableViewCell" bundle:nil] forCellReuseIdentifier:@"productCell"];
    [self.saleTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)mjRefalish
{
    self.saleTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getShopGoodsTableWithID:[nNsuserdefaul objectForKey:@"userID"]];
    }];
}

#pragma mark  shareAction
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
    //    NSLog(@"===========  %ld",btn.tag);
    switch (btn.tag) {
        case 0:
        {
            //创建分享参数
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            
            NSMutableArray* imageArray = [NSMutableArray array];
            for (NSDictionary *diction in self.shareImage) {
                [imageArray addObject:diction[@"path"]];
                NSLog(@"- - - - - - - - - - - %@",diction[@"path"]);
            }
            if (imageArray) {
                UIImage *image = imageArray[0];
                [shareParams SSDKSetupFacebookParamsByText:[NSString stringWithFormat:@"%@,%@",self.shareTitle,self.shareUrl] image:image type:SSDKContentTypeAuto];
                
                //进行分享
                [ShareSDK share:SSDKPlatformTypeFacebook
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     
                     switch (state) {
                         case SSDKResponseStateSuccess:
                         {
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alertView show];
                             break;
                         }
                         case SSDKResponseStateFail:
                         {
                             NSLog(@"%@",error);
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"  message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alertView show];
                             break;
                         }
                         case SSDKResponseStateCancel:
                         {
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alertView show];
                             break;
                         }
                         default:
                             break;
                     }
                 }];
            }
        }
            break;
        case 1:
        {
            
            FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
            content.contentURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/id1145763548"];
            //            content.imageURL = [NSURL URLWithString:[self.imageArray firstObject]];
            [FBSDKMessageDialog showWithContent:content delegate:nil];        }
            break;
        case 2:
        {
            //创建分享参数
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            
            NSArray* imageArray = @[[UIImage imageNamed:@"shangpingtu_img"]];
            
            if (imageArray) {
                [shareParams SSDKSetupLineParamsByText:@"haode" image:imageArray type:SSDKContentTypeAuto];
                //进行分享
                [ShareSDK share:SSDKPlatformTypeLine
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     
                     switch (state) {
                         case SSDKResponseStateSuccess:
                         {
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alertView show];
                             break;
                         }
                         case SSDKResponseStateFail:
                         {
                             NSLog(@"%@",error);
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"  message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alertView show];
                             break;
                         }
                         case SSDKResponseStateCancel:
                         {
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alertView show];
                             break;
                         }
                         default:
                             break;
                     }
                 }];
            }
            
        }
            break;
        case 3:
        {
            //创建分享参数
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            NSMutableArray* imageArray = [NSMutableArray array];
            for (NSDictionary *diction in self.shareImage) {
                [imageArray addObject:diction[@"path"]];
                //                NSLog(@"- - - - - - - - - - - %@",diction[@"path"]);
            }
            if (imageArray) {
                UIImage *image = imageArray[0];
                [shareParams SSDKSetupInstagramByImage:image menuDisplayPoint:CGPointMake(0, 0)];
                //进行分享
                [ShareSDK share:SSDKPlatformTypeInstagram
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     
                     switch (state) {
                         case SSDKResponseStateSuccess:
                         {
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alertView show];
                             break;
                         }
                         case SSDKResponseStateFail:
                         {
                             NSLog(@"%@",error);
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"  message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alertView show];
                             break;
                         }
                         case SSDKResponseStateCancel:
                         {
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alertView show];
                             break;
                         }
                         default:
                             break;
                     }
                 }];
            }
            
        }
            break;
        case 4:
        {
            //创建分享参数
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            NSMutableArray* imageArray = [NSMutableArray array];
            for (NSDictionary *diction in self.shareImage) {
                [imageArray addObject:diction[@"path"]];
                //                NSLog(@"- - - - - - - - - - - %@",diction[@"path"]);
            }
            
            if (imageArray) {
                [shareParams SSDKSetupTwitterParamsByText:@"share goods" images:imageArray latitude:0.9 longitude:0.9 type:SSDKContentTypeImage];
                //进行分享
                [ShareSDK share:SSDKPlatformTypeTwitter
                     parameters:shareParams
                 onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                     
                     switch (state) {
                         case SSDKResponseStateSuccess:
                         {
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alertView show];
                             break;
                         }
                         case SSDKResponseStateFail:
                         {
                             NSLog(@"%@",error);
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"  message:[NSString stringWithFormat:@"%@", error] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alertView show];
                             break;
                         }
                         case SSDKResponseStateCancel:
                         {
                             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                             [alertView show];
                             break;
                         }
                         default:
                             break;
                     }
                 }];
            }
        }
            break;
        case 5:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [NSString stringWithFormat:@"%@  %@",self.shareTitle,self.shareUrl];
        }
            break;
        default:
            break;
    }
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
    ProductsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[ProductsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"productCell"];
    }
    
    if (self.productArray.count > 0) {
        MarketListModel *model = self.productArray[indexPath.section];
        [cell showProductListWith:model];
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
    NSIndexPath *prePath = [self.saleTableView indexPathForCell:cell];
    MarketListModel *marke = self.productArray[prePath.section];
    NSString *goodUrl = [NSString stringWithFormat:@"http://%@/Good/app/gooddetails.aspx?goodid=%@",publickUrl,marke.goodid];
    self.shareUrl = goodUrl;
    self.shareTitle = marke.goodname;
    self.shareImage = [NSArray arrayWithArray:marke.goodimgs];
    //    NSLog(@"shareImage - - - - %@",self.shareImage);
    [self shareAction];
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
        [self.saleTableView.mj_header endRefreshing];
        [self.saleTableView.mj_footer endRefreshing];
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
                [self.saleTableView.mj_header endRefreshing];
                [self.saleTableView.mj_footer endRefreshing];
                [self.saleTableView reloadData];
            } else {
                self.nothingView.hidden = NO;
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
                [self.saleTableView.mj_header endRefreshing];
                [self.saleTableView.mj_footer endRefreshing];
            }
        });
        
    } else {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
        NSString *mess = marketDict[@"msg"];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = mess;
        [hud hide:YES afterDelay:2];
        if ([mess isEqualToString:@"token is wrong"]) {
            LoginHomeViewController *login = [[LoginHomeViewController alloc] init];
            [self.navigationController pushViewController:login animated:YES];
        }
        [self.saleTableView.mj_header endRefreshing];
        [self.saleTableView.mj_footer endRefreshing];
    }
}

- (void)saleSelectpromotionBtnWithCell:(UITableViewCell *)cell
{
    NSIndexPath *selectPath =  [self.saleTableView indexPathForCell:cell];
    MarketListModel *mark = self.productArray[selectPath.section];
    //    NSLog(@"---------%@,%@",mark.goodimgs,mark.line);
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSArray *title = @[ASLocalizedString(@"Save the picture"), ASLocalizedString(@"copy the name & link") , ASLocalizedString(@"copy the name"),ASLocalizedString(@"copy the link")];
    CWActionSheet *sheet = [[CWActionSheet alloc] initWithTitles:title clickAction:^(CWActionSheet *sheet, NSIndexPath *indexPath) {
        NSLog(@"点击了%ldd",(long) indexPath.row);
        switch (indexPath.row) {
            case 0:
            {
                NSArray *urlArray = mark.goodimgs;
                if (urlArray.count > 0) {
                    for (NSDictionary *urlDic in urlArray) {
                        NSString *urlString = urlDic[@"path"];
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL  URLWithString:urlString]];
                        UIImage *image = [UIImage imageWithData:data]; // 取得图片
                        //                        NSLog(@"image  =  %@",image);
                        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
                    }
                }
            }
                break;
            case 1:
                pasteboard.string = [NSString stringWithFormat:@"%@,%@",mark.goodname,mark.line];
                break;
                
            case 2:
                pasteboard.string = [NSString stringWithFormat:@"%@,",mark.goodname];
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
    NSIndexPath *prePath = [self.saleTableView indexPathForCell:cell];
    MarketListModel *marke = self.productArray[prePath.section];
    //    NSString *goodUrl = [NSString stringWithFormat:@"http://%@/Good/app/gooddetails.aspx?goodid=%@",publickUrl,marke.goodid];
    NSString *goodUrl = [NSString stringWithFormat:@"http://%@/GoodHander/product.aspx?goodid=%@",publickUrl,marke.goodid];
    //    NSLog(@"%@",goodUrl);
    WebViewController *webView = [[WebViewController alloc] init];
    webView.showUrl = goodUrl;
    [self.navigationController pushViewController:webView animated:YES];
}


- (IBAction)addProductAction:(UIButton *)sender {
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
