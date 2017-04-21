//
//  PersonalMainViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/1/10.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "PersonalMainViewController.h"
#import "PersonSettingTableViewCell.h"
#import "UserSettingViewController.h"
#import "MessageTableViewController.h"
#import "WebViewController.h"
#import "UIImageView+AFNetworking.h"
#import "UserModelData.h"

#import "CQCustomActionSheet.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <MOBFoundation/MOBFoundation.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface PersonalMainViewController () <UITableViewDelegate, UITableViewDataSource, CQCustomActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIView *userImageView;
@property (weak, nonatomic) IBOutlet UITableView *personalTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (nonatomic ,strong) UserModelData *setUserData;
@property (nonatomic ,strong) UIButton *itemBtn;

@end

@implementation PersonalMainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getUserData];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.imageWidth.constant = SCREEN_WIDTH * 0.173;
    [self.userHeaderImage.layer setCornerRadius:(self.userHeaderImage.sd_height/2)];
    [self.userHeaderImage.layer setMasksToBounds:YES];
    [self.userHeaderImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.userHeaderImage setClipsToBounds:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.translucent = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextPage:)];
    [self.userImageView addGestureRecognizer:tap];
    self.personalTableView.scrollEnabled = NO;
    [self.personalTableView registerNib:[UINib nibWithNibName:@"PersonSettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"personCell"];
    
    [self leftItem];
}

- (void)leftItem
{
    self.itemBtn = [[UIButton alloc] init];
    [_itemBtn setImage:[UIImage imageNamed:@"nav_icon_xiaoxi"] forState:UIControlStateNormal];
    _itemBtn.size = _itemBtn.currentImage.size;
    [_itemBtn addTarget:self action:@selector(messageTable) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_itemBtn];
    
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_xiaoxi"] style:UIBarButtonItemStylePlain target:self action:@selector(messageTable)];
}

- (void)messageTable
{
    MessageTableViewController *message = [[MessageTableViewController alloc] init];
    [self.navigationController pushViewController:message animated:YES];
}

- (void)nextPage:(UITapGestureRecognizer *)tap
{
    UserSettingViewController *setting = [[UserSettingViewController alloc] init];
    setting.userData = self.setUserData;
    [self.navigationController pushViewController:setting animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personCell"];
    NSDictionary *diction = @{@"one":@[ASLocalizedString(@"Help&FAQ"),ASLocalizedString(@"About us"),ASLocalizedString(@"Rate us")],@"two":@[ASLocalizedString(@"Invite Friends")]};
    NSArray *arr = @[@"one",@"two"];
    
    cell.firstLable.text = diction[arr[indexPath.section]][indexPath.row];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.imagView.image = [UIImage imageNamed:@"help_icon"];
                    break;
                case 1:
                    cell.imagView.image = [UIImage imageNamed:@"guanyu_icon"];
                    break;
                case 2:
                    cell.imagView.image = [UIImage imageNamed:@"heart_icon"];
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:
            cell.imagView.image = [UIImage imageNamed:@"yaoqing_icon"];
            break;
            
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_WIDTH * 0.128;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath.section - %ld indexPath.row - %ld",indexPath.section,indexPath.row);
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                WebViewController *webVC = [[WebViewController alloc] init];
                webVC.showUrl = @"https://www.baidu.com";
                [self.navigationController pushViewController:webVC animated:YES];
            }
                break;
            case 1:
            {
                WebViewController *webVC = [[WebViewController alloc] init];
                webVC.showUrl = @"https://www.baidu.com";
                [self.navigationController pushViewController:webVC animated:YES];
            }
                break;
                
            case 2:
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/id1225811041"]];
            }
                break;
                
            default:
                break;
        }
    } else {
        [self shareAction];
    }
}

- (void)getUserData
{
    NSString *userUrl = [NSString stringWithFormat:@"http://%@/Account/UserDetial.ashx?userid=%@&system=1",publickUrl,[nNsuserdefaul objectForKey:@"userID"]];
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"accessToken"] forHTTPHeaderField:@"accesstoken"];
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"refreshToken"] forHTTPHeaderField:@"refreshtoken"];
    [PPNetworkHelper GET:userUrl parameters:nil success:^(id responseObject) {
        NSLog(@"userData - %@",responseObject);
        NSDictionary *userDic = responseObject;
        NSString *returnCode = userDic[@"returncode"];
        if ([returnCode isEqualToString:@"success"]) {
            NSDictionary *listDic = userDic[@"memberinfo"];
            UserModelData *model = [[UserModelData alloc] init];
            [model setValuesForKeysWithDictionary:listDic];
            self.setUserData = model;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.userHeaderImage setImageWithURL:[NSURL URLWithString:model.headimgurl] placeholderImage:[UIImage imageNamed:@"touxiang_img_default"]];
                int messCount = [model.tipscount intValue];
                if (messCount > [[nNsuserdefaul objectForKey:@"messageCount"] intValue]) {
                    [self.itemBtn setImage:[UIImage imageNamed:@"ic_notivation"] forState:UIControlStateNormal];
                    _itemBtn.size = _itemBtn.currentImage.size;
                } else {
                    [self.itemBtn setImage:[UIImage imageNamed:@"ic_notivation_none"] forState:UIControlStateNormal];
                    _itemBtn.size = _itemBtn.currentImage.size;
                }
                self.userNameLabel.text = model.nickname;
            });
        }
    } failure:^(NSError *error) {
        NSLog(@"------failure");
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
            
            UIImage *image = [UIImage imageNamed:@"logo"];
            [shareParams SSDKSetupFacebookParamsByText:[NSString stringWithFormat:@"ไม่มีสินค้าก็สามารถสร้างรายได้โดยเปิดร้านออนไลน์ในมือถือได้ ,http://%@/GoodHander/download/download.html",publickUrl] image:image type:SSDKContentTypeAuto];
            
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
            UIImage *image = [UIImage imageNamed:@"logo"];
            [shareParams SSDKSetupLineParamsByText:[NSString stringWithFormat:@"ไม่มีสินค้าก็สามารถสร้างรายได้โดยเปิดร้านออนไลน์ในมือถือได้ ,http://%@/GoodHander/download/download.html",publickUrl] image:image type:SSDKContentTypeAuto];
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
            break;
        case 3:
        {
            //创建分享参数
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            UIImage *image = [UIImage imageNamed:@"logo"];
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
            break;
        case 4:
        {
            //创建分享参数
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            UIImage *image = [UIImage imageNamed:@"logo"];
            [shareParams SSDKSetupTwitterParamsByText:[NSString stringWithFormat:@"ไม่มีสินค้าก็สามารถสร้างรายได้โดยเปิดร้านออนไลน์ในมือถือได้ ,http://%@/GoodHander/download/download.html",publickUrl] images:image latitude:0.9 longitude:0.9 type:SSDKContentTypeImage];
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
            break;
        case 5:
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = [NSString stringWithFormat:@"ไม่มีสินค้าก็สามารถสร้างรายได้โดยเปิดร้านออนไลน์ในมือถือได้ ,http://%@/GoodHander/download/download.html",publickUrl];
        }
            break;
        default:
            break;
    }
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
