//
//  ShopViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/4/18.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "ShopViewController.h"
#import "ShopLogoTableViewCell.h"
#import "ShopOtherTableViewCell.h"
#import "ShopListModel.h"
#import "UIImageView+AFNetworking.h"
#import "ChangeUserNameViewController.h"
#import "IdentificationViewController.h"
#import "WebViewController.h"

#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDK/ShareSDK+Base.h>
#import "CQCustomActionSheet.h"

@interface ShopViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, CQCustomActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *shopTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeight;

@property (nonatomic ,strong) UIImage *selectImage;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (nonatomic ,strong) ShopListModel *shopListModel;
@property (nonatomic ,strong) NSString *shareUrl;
@property (nonatomic ,strong) NSString *shopID;
@property (nonatomic ,strong) NSString *shareTitle;
@property (nonatomic ,strong) NSString *shareImage;
@end

@implementation ShopViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getShopListWith:[nNsuserdefaul objectForKey:@"userID"]];
    [self.shopTableView reloadData];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
//    self.tableHeight.constant = SCREEN_WIDTH * 1.14;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    [self registerTabelView];
    [self setNavigationItems];
    self.shopTableView .tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view from its nib.
}

- (void)registerTabelView
{
    [self.shopTableView registerNib:[UINib nibWithNibName:@"ShopLogoTableViewCell" bundle:nil] forCellReuseIdentifier:@"logoCell"];
    [self.shopTableView registerNib:[UINib nibWithNibName:@"ShopOtherTableViewCell" bundle:nil] forCellReuseIdentifier:@"otherCell"];
    [self.shopTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)setNavigationItems
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:ASLocalizedString(@"Preview") style:UIBarButtonItemStylePlain target:self action:@selector(shopShowAction)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName, nil] forState:UIControlStateNormal];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(shareAction) image:@"tuiguang_icon" highImage:@""];
}
- (void)getShopListWith:(NSString *)userID
{
    NSString *shopUrl = [NSString stringWithFormat:@"http://%@/Shop/ShopDetial.ashx?userid=%@",publickUrl,userID];
    
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"accessToken"] forHTTPHeaderField:@"accesstoken"];
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"refreshToken"] forHTTPHeaderField:@"refreshtoken"];
    [PPNetworkHelper GET:shopUrl parameters:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        NSLog(@"shoplist - %@",responseObject);
        NSDictionary *diction = responseObject;
        if ([diction[@"returncode"] isEqualToString:@"success"]) {
            NSMutableDictionary *listDic = diction[@"shopdetial"];
            self.shopListModel = [[ShopListModel alloc] init];
            [self.shopListModel setValuesForKeysWithDictionary:listDic];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *shopInfo = [NSString stringWithFormat:@"http://%@/Good/app/shopdetails.aspx?shopid=%@",publickUrl,self.shopListModel.shopid];
                self.shareUrl = shopInfo;
                self.shareTitle = self.shopListModel.storename;
                self.shareImage = self.shopListModel.shoplogo;
                self.shopID = self.shopListModel.shopid;
                        });
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:@"无数据" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alerV show];
        }
        [self.shopTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}
/*
 self.shopNameLabel.text = [NSString stringWithFormat:@"%@",self.shopListModel.storename];
 self.shareTitle = self.shopListModel.storename;
 self.shareImage = self.shopListModel.shoplogo;
 
 self.welcomeStrLabel.text = self.shopListModel.introduction;
 self.phoneNumLabel.text = [NSString stringWithFormat:@"%@",self.shopListModel.phone];
 self.shopID = self.shopListModel.shopid;
 if (faceStr.length > 5) {
 self.facebookLabel.text = self.shopListModel.facebook;
 } else {
 self.facebookLabel.text = ASLocalizedString(@"add your facebook");
 }
 if (linStr.length > 5) {
 self.lineLabel.text = self.shopListModel.line;
 } else {
 self.lineLabel.text = ASLocalizedString(@"add your line");
 }
 NSString *auth = [NSString stringWithFormat:@"%@",self.shopListModel.authtype];
 if ([auth isEqualToString:@"0"]) {
 self.authenticationLabel.text = ASLocalizedString(@"Unaythorized");
 UITapGestureRecognizer *identityTop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(odentityAction)];
 [self.odenttityView addGestureRecognizer:identityTop];
 } else if ([auth isEqualToString:@"1"]) {
 self.authenticationLabel.text = ASLocalizedString(@"Auditting");
 } else if ([auth isEqualToString:@"2"]) {
 self.authenticationLabel.text = ASLocalizedString(@"Success");
 } else if ([auth isEqualToString:@"3"]) {
 self.authenticationLabel.text = ASLocalizedString(@"Audit Fail");
 }
 */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    } else {
        return 3;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *faceStr = self.shopListModel.facebook;
    NSString *linStr = self.shopListModel.line;
    if (indexPath.section == 0) {
        NSArray *titleArr = @[ASLocalizedString(@"Shop Logo"),ASLocalizedString(@"Store Name"),ASLocalizedString(@"Wolcomes"),ASLocalizedString(@"identity")];
        if (indexPath.row == 0) {
            ShopLogoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"logoCell"];
            if (!cell) {
                cell = [[ShopLogoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"logoCell"];
            }
            if (self.selectImage != nil) {
                cell.logoImageView.image = self.selectImage;
            } else {
                [cell.logoImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.shopListModel.shoplogo]] placeholderImage:[UIImage imageNamed:@"shop_logo_default"]];
            }
            cell.logoLabel.text = ASLocalizedString(@"Shop Logo");
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            ShopOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherCell"];
            if (!cell) {
                cell = [[ShopOtherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"otherCell"];
            }
            [cell setTitleLabelText:titleArr[indexPath.row]];
            switch (indexPath.row) {
                case 1:
                    cell.subtitleLabel.text = self.shopListModel.storename;
                    break;
                case 2:
                    cell.subtitleLabel.text = self.shopListModel.introduction;
                    break;
                case 3:
                {
                    NSString *auth = [NSString stringWithFormat:@"%@",self.shopListModel.authtype];
                    if ([auth isEqualToString:@"0"]) {
                        cell.subtitleLabel.text = ASLocalizedString(@"Unaythorized");
                    } else if ([auth isEqualToString:@"1"]) {
                        cell.subtitleLabel.text = ASLocalizedString(@"Auditting");
                    } else if ([auth isEqualToString:@"2"]) {
                        cell.subtitleLabel.text = ASLocalizedString(@"Success");
                    } else if ([auth isEqualToString:@"3"]) {
                        cell.subtitleLabel.text = ASLocalizedString(@"Audit Fail");
                    }
                }
                    break;
                default:
                    break;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    } else {
        NSArray *titleArr = @[ASLocalizedString(@"Phone"),ASLocalizedString(@"Facebook"),ASLocalizedString(@"Line")];
        ShopOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"otherCell"];
        if (!cell) {
            cell = [[ShopOtherTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"otherCell"];
        }
        [cell setTitleLabelText:titleArr[indexPath.row]];
        switch (indexPath.row) {
            case 0:
                cell.subtitleLabel.text = self.shopListModel.phone;
                break;
            case 1:
                if (faceStr.length > 3) {
                    cell.subtitleLabel.text = self.shopListModel.facebook;
                } else {
                    cell.subtitleLabel.text = ASLocalizedString(@"add your facebook");
                }
                break;
            case 2:
                if (linStr.length > 3) {
                    cell.subtitleLabel.text = self.shopListModel.line;
                } else {
                    cell.subtitleLabel.text = ASLocalizedString(@"add your line");
                }
                break;
                
            default:
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self choosePhoto];
                break;
            case 1:
            {
                ChangeUserNameViewController *changeVc = [[ChangeUserNameViewController alloc] init];
                changeVc.changeStr = @"shopName";
                changeVc.nameStr = [NSString stringWithFormat:@"%@",self.shopListModel.storename];
                [self.navigationController pushViewController:changeVc animated:YES];
            }
                break;
            case 2:
            {
                ChangeUserNameViewController *changeVc = [[ChangeUserNameViewController alloc] init];
                changeVc.changeStr = @"welcome";
                changeVc.nameStr = [NSString stringWithFormat:@"%@",self.shopListModel.introduction];
                [self.navigationController pushViewController:changeVc animated:YES];
            }
                break;
            case 3:
            {
                IdentificationViewController *ident = [[IdentificationViewController alloc] init];
                ident.shopID = self.shopID;
                [self.navigationController pushViewController:ident animated:YES];            }
                break;
                
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
            {
//                ChangeUserNameViewController *changeVc = [[ChangeUserNameViewController alloc] init];
//                changeVc.changeStr = @"facebook";
//                changeVc.nameStr = [NSString stringWithFormat:@"%@",self.shopListModel.facebook];
//                [self.navigationController pushViewController:changeVc animated:YES];
            }
                break;
            case 1:
            {
                ChangeUserNameViewController *changeVc = [[ChangeUserNameViewController alloc] init];
                changeVc.changeStr = @"facebook";
                changeVc.nameStr = self.shopListModel.facebook;
                [self.navigationController pushViewController:changeVc animated:YES];
            }
                break;
            case 2:
            {
                ChangeUserNameViewController *changeVc = [[ChangeUserNameViewController alloc] init];
                changeVc.changeStr = @"line";
                changeVc.nameStr = self.shopListModel.line;
                [self.navigationController pushViewController:changeVc animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return SCREEN_WIDTH * 0.24;
        } else {
            return SCREEN_WIDTH * 0.128;
        }
    } else {
        return SCREEN_WIDTH * 0.128;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    } else {
        return 40;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section

{
    if (section == 1) {
        UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
        header.textLabel.text = ASLocalizedString(@"Contact information");
        header.textLabel.textColor = [UIColor colorWithHexString:@"#b7b7b7"];
        header.textLabel.font = [UIFont systemFontOfSize:13];
        header.contentView.backgroundColor = [UIColor clearColor];
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section == 1) {
//        
//        return ASLocalizedString(@"Contact information");
//    } else {
//        return nil;
//    }
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == 1) {
//        return ASLocalizedString(@"Contact information");
//    } else {
//        return nil;
//    }
//}


- (void)choosePhoto
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:ASLocalizedString(@"cancel") destructiveButtonTitle:nil otherButtonTitles:ASLocalizedString(@"Take a photo"), ASLocalizedString(@"From Album"), nil, nil];
    self.actionSheet.tag = 1000;
    [self.actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"-- %@ - %ld",actionSheet,(long)buttonIndex);
    if (actionSheet.tag == 1000) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
        if (buttonIndex == 0) {
            sourceType = UIImagePickerControllerSourceTypeCamera;
            //跳转到相机或相册页面
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.navigationBar.translucent = NO;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = sourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];
        } else if (buttonIndex == 1) {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            //跳转到相机或相册页面
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.navigationBar.translucent = NO;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = sourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];
        }
    } else {
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadShopLogo:image];
    }];
    self.selectImage = image;
    [self.shopTableView reloadData];
}

- (void)uploadShopLogo:(UIImage *)logo
{
    NSString *upload = [NSString stringWithFormat:@"http://%@/Shop/UpdateShop.ashx",publickUrl];
    NSMutableDictionary *uploadShop = [NSMutableDictionary dictionary];
    uploadShop[@"userid"] = [nNsuserdefaul objectForKey:@"userID"];
    uploadShop[@"modify"] = @"Logo";
    uploadShop[@"content"] = @"";
    
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"accessToken"] forHTTPHeaderField:@"accesstoken"];
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"refreshToken"] forHTTPHeaderField:@"refreshtoken"];
    [PPNetworkHelper uploadImagesWithURL:upload parameters:uploadShop name:@"shopImage" images:@[logo] fileNames:@[@"shopimg.png"] imageScale:0.1f imageType:@"png" progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject - %@",responseObject);
        NSDictionary *logDic = responseObject;
        NSString *returnCode = logDic[@"returncode"];
        if ([returnCode isEqualToString:@"success"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = ASLocalizedString(@"成功");
            [hud hide:YES afterDelay:2];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@",logDic[@"msg"]];
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alerV show];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:@"failure" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alerV show];
    }];
    
}


- (void)shopShowAction
{
    WebViewController *webView = [[WebViewController alloc] init];
    NSString *shopInfo = [NSString stringWithFormat:@"http://%@/GoodHander/shop_preview.aspx?shopid=%@",publickUrl,self.shopListModel.shopid];
    self.shareUrl = shopInfo;
    webView.showUrl = shopInfo;
    [self.navigationController pushViewController:webView animated:YES];
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
    NSLog(@"===========  %ld",btn.tag);
    switch (btn.tag) {
        case 0:
        {
            //创建分享参数
            NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
            
            
            [shareParams SSDKSetupFacebookParamsByText:[NSString stringWithFormat:@"%@,%@",self.shareTitle,self.shareUrl] image:self.shareImage type:SSDKContentTypeAuto];
            
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
            
            NSArray* imageArray = @[[UIImage imageNamed:@"shangpingtu_img"]];
            
            if (imageArray) {
                [shareParams SSDKSetupLineParamsByText:[NSString stringWithFormat:@"%@,%@",self.shareTitle,self.shareUrl] image:self.shareImage type:SSDKContentTypeAuto];
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
            [shareParams SSDKSetupInstagramByImage:self.shareImage menuDisplayPoint:CGPointMake(0, 0)];
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
            [shareParams SSDKSetupTwitterParamsByText:[NSString stringWithFormat:@"%@,%@",self.shareTitle,self.shareUrl] images:self.shareImage latitude:0.9 longitude:0.9 type:SSDKContentTypeImage];
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
            pasteboard.string = [NSString stringWithFormat:@"%@  %@",self.shareTitle,self.shareUrl];
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

