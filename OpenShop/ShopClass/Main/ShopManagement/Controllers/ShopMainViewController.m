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
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space,leftItem, nil];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:ASLocalizedString(@"Preview") style:UIBarButtonItemStylePlain target:self action:@selector(shopShowAction)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(shareAction) image:@"tuiguang_icon" highImage:@""];
}

- (void)getShopListWith:(NSString *)userID
{
    NSString *shopUrl = [NSString stringWithFormat:@"http://%@/Shop/ShopDetial.ashx?userid=%@",publickUrl,userID];
    [PPNetworkHelper GET:shopUrl parameters:nil responseCache:^(id responseCache) {
        
    } success:^(id responseObject) {
        NSLog(@"shoplist - %@",responseObject);
        NSDictionary *diction = responseObject;
        NSLog(@"nNsuserdefaul - %@",[nNsuserdefaul objectForKey:@"accessToken"]);
//        [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"accessToken"] forHTTPHeaderField:@"accesstoken"];
//        [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"refreshtToken"] forHTTPHeaderField:@"refreshtoken"];
        if ([diction[@"returncode"] isEqualToString:@"success"]) {
            NSMutableDictionary *listDic = diction[@"shopdetial"];
            ShopListModel *model = [[ShopListModel alloc] init];
            [model setValuesForKeysWithDictionary:listDic];
            NSString *faceStr = [NSString stringWithFormat:@"%@",model.facebook];
            NSString *linStr = [NSString stringWithFormat:@"%@",model.line];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.logoImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.shoplogo]] placeholderImage:[UIImage imageNamed:@"gerenxinxi_touxiang_img"]];
                self.shopNameLabel.text = [NSString stringWithFormat:@"%@",model.storename];
                self.welcomeStrLabel.text = [NSString stringWithFormat:@"%@",model.introduction];
                self.phoneNumLabel.text = [NSString stringWithFormat:@"%@",model.phone];
                if (faceStr != nil) {
                    self.facebookLabel.text = [NSString stringWithFormat:@"%@",model.facebook];
                } else {
                    self.facebookLabel.text = ASLocalizedString(@"add your facebook");
                }
                if (linStr != nil) {
                    self.lineLabel.text = [NSString stringWithFormat:@"%@",model.line];
                } else {
                    self.lineLabel.text = ASLocalizedString(@"add your line");
                }
            });
        } else {
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:@"无数据" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alerV show];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)shopShowAction
{
    
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
    [self.navigationController pushViewController:changeVc animated:YES];
}

- (void)welcomeString
{
    ChangeUserNameViewController *changeVc = [[ChangeUserNameViewController alloc] init];
    changeVc.changeStr = @"welcome";
    [self.navigationController pushViewController:changeVc animated:YES];
}

- (void)odentityAction
{
    IdentificationViewController *ident = [[IdentificationViewController alloc] init];
    [self.navigationController pushViewController:ident animated:YES];
}

- (void)changePhoneNumber
{
    
}

- (void)facebookNum
{
    ChangeUserNameViewController *changeVc = [[ChangeUserNameViewController alloc] init];
    changeVc.changeStr = @"facebook";
    [self.navigationController pushViewController:changeVc animated:YES];
}

- (void)lineNum
{
    ChangeUserNameViewController *changeVc = [[ChangeUserNameViewController alloc] init];
    changeVc.changeStr = @"line";
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
        } else if (buttonIndex == 1) {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        //跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.navigationBar.translucent = NO;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    } else {
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.logoImage.image = image;
    [self uploadShopLogo:image];
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
