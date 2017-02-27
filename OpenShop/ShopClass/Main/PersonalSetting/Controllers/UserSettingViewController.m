//
//  UserSettingViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/2/24.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "UserSettingViewController.h"
#import "ChangeUserNameViewController.h"

@interface UserSettingViewController ()
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *outView;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImage;

@end

@implementation UserSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = ASLocalizedString(@"Account");
    [self leftItem];
    
    [self changeNickNameAction];
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
    space.width = 14;//自己设定
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:space,leftItem, nil]];
}

- (void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeNickNameAction
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changUserName)];
    [self.nameView addGestureRecognizer:tap];
}

- (void)changUserName
{
    ChangeUserNameViewController *nameView = [[ChangeUserNameViewController alloc] init];
    nameView.nameStr = @"Some Thing";
    [self.navigationController pushViewController:nameView animated:YES];
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
