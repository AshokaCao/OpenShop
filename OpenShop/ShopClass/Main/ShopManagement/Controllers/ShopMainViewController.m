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
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(shopShowAction) forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
//    [btn setBackgroundImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    [btn setTitle:@"Preview" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"#111111"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:13];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    // 设置尺寸
//    btn.size = btn.currentTitle.;
    btn.size = CGSizeMake(79, 44);
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = 14;//自己设定
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"tuiguang_icon"] forState:UIControlStateNormal];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    rightBtn.size = rightBtn.currentBackgroundImage.size;
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:space,rightItem, nil]];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:space,leftItem, nil]];
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
}

- (void)changeLogoImage
{
    
}

- (void)changShopName
{
    
}

- (void)welcomeString
{
    
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
    
}

- (void)lineNum
{
    
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
