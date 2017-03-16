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

@interface ShopMainViewController () <CQCustomActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIView *storeNameView;
@property (weak, nonatomic) IBOutlet UIView *welcomeView;
@property (weak, nonatomic) IBOutlet UIView *odenttityView;
@property (weak, nonatomic) IBOutlet UIView *phoneNumView;
@property (weak, nonatomic) IBOutlet UIView *facebookView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation ShopMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    // Do any additional setup after loading the view from its nib.
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
