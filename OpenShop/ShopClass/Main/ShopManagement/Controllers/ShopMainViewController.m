//
//  ShopMainViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/1/10.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "ShopMainViewController.h"
#import "IdentificationViewController.h"
#import "CQCustomActionSheet.h"
#import "ChangeUserNameViewController.h"
#import "ShopListModel.h"
#import "UIImageView+AFNetworking.h"
#import "WebViewController.h"

@interface ShopMainViewController () <CQCustomActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIView *storeNameView;
@property (weak, nonatomic) IBOutlet UIView *welcomeView;
@property (weak, nonatomic) IBOutlet UIView *odenttityView;
@property (weak, nonatomic) IBOutlet UIView *phoneNumView;
@property (weak, nonatomic) IBOutlet UIView *facebookView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIView *logoImageView;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoImageWidth;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *welcomeStrLabel;
@property (weak, nonatomic) IBOutlet UILabel *authenticationLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *facebookLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (nonatomic ,strong) ShopListModel *shopListModel;

@property (nonatomic ,strong) NSString *shopID;

@end

@implementation ShopMainViewController


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.logoImageWidth.constant = SCREEN_WIDTH * 0.146;
    self.logoImage.contentMode = UIViewContentModeScaleAspectFill;
    self.logoImage.clipsToBounds = YES;
    self.logoImage.layer.cornerRadius = SCREEN_WIDTH * 0.146 / 2;
    self.logoImage.layer.masksToBounds = YES;
    NSLog(@"%f",self.logoImage.sd_width);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getShopListWith:[nNsuserdefaul objectForKey:@"userID"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [self addTapGens];
    [self setNavigationItems];
}

- (void)setNavigationItems
{
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Preview" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#111111"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:13];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // 设置尺寸
    //    btn.size = btn.currentTitle.;
    btn.size = CGSizeMake(79, 44);
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -7;//自己设定
//    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space,leftItem, nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:ASLocalizedString(@"Preview") style:UIBarButtonItemStylePlain target:self action:@selector(shopShowAction)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(shareAction) image:@"tuiguang_icon" highImage:@""];
}

- (void)getShopListWith:(NSString *)userID
{
    NSString *shopUrl = [NSString stringWithFormat:@"http://%@/Shop/ShopDetial.ashx?userid=%@",publickUrl,userID];
    [PPNetworkHelper GET:shopUrl parameters:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        NSLog(@"shoplist - %@",responseObject);
        NSDictionary *diction = responseObject;
        if ([diction[@"returncode"] isEqualToString:@"success"]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSMutableDictionary *listDic = diction[@"shopdetial"];
            self.shopListModel = [[ShopListModel alloc] init];
            [self.shopListModel setValuesForKeysWithDictionary:listDic];
            NSString *faceStr = self.shopListModel.facebook;
            NSString *linStr = self.shopListModel.line;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.logoImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.shopListModel.shoplogo]] placeholderImage:[UIImage imageNamed:@"gerenxinxi_touxiang_img"]];
                self.shopNameLabel.text = [NSString stringWithFormat:@"%@",self.shopListModel.storename];
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
            });
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:@"无数据" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alerV show];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)shopShowAction
{
    WebViewController *webView = [[WebViewController alloc] init];
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
    
}

- (void)addTapGens
{
    UITapGestureRecognizer *logoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeLogoImage)];
    [self.logoImage addGestureRecognizer:logoTap];
    
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changShopName)];
    [self.storeNameView addGestureRecognizer:nameTap];
    
    UITapGestureRecognizer *welcomeTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(welcomeString)];
    [self.welcomeView addGestureRecognizer:welcomeTap];
    
    UITapGestureRecognizer *identityTop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(odentityAction)];
    [self.odenttityView addGestureRecognizer:identityTop];
    
    UITapGestureRecognizer *facebookTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(facebookNum)];
    [self.facebookView addGestureRecognizer:facebookTap];
    
    UITapGestureRecognizer *lineTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lineNum)];
    [self.lineView addGestureRecognizer:lineTap];
}

- (void)changeLogoImage
{
    [self choosePhoto];
}

- (void)changShopName
{
    ChangeUserNameViewController *changeVc = [[ChangeUserNameViewController alloc] init];
    changeVc.changeStr = @"shopName";
    changeVc.nameStr = [NSString stringWithFormat:@"%@",self.shopListModel.storename];
    [self.navigationController pushViewController:changeVc animated:YES];
}

- (void)welcomeString
{
    ChangeUserNameViewController *changeVc = [[ChangeUserNameViewController alloc] init];
    changeVc.changeStr = @"welcome";
    changeVc.nameStr = [NSString stringWithFormat:@"%@",self.shopListModel.introduction];
    [self.navigationController pushViewController:changeVc animated:YES];
}

- (void)odentityAction
{
    IdentificationViewController *ident = [[IdentificationViewController alloc] init];
    ident.shopID = self.shopID;
    [self.navigationController pushViewController:ident animated:YES];
}

- (void)changePhoneNumber
{
    
}

- (void)facebookNum
{
    ChangeUserNameViewController *changeVc = [[ChangeUserNameViewController alloc] init];
    changeVc.changeStr = @"facebook";
    changeVc.nameStr = [NSString stringWithFormat:@"%@",self.shopListModel.facebook];
    [self.navigationController pushViewController:changeVc animated:YES];
}

- (void)lineNum
{
    ChangeUserNameViewController *changeVc = [[ChangeUserNameViewController alloc] init];
    changeVc.changeStr = @"line";
    changeVc.nameStr = [NSString stringWithFormat:@"%@",self.shopListModel.line];
    [self.navigationController pushViewController:changeVc animated:YES];
}
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
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.logoImage.image = [self OriginImage:image scaleToSize:CGSizeMake(image.size.width * 0.1, image.size.height * 0.1)];
    [self uploadShopLogo:[self OriginImage:image scaleToSize:CGSizeMake(image.size.width * 0.1, image.size.height * 0.1)]];
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

-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
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
