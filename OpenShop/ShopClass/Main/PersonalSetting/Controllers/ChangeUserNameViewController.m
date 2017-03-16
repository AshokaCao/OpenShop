//
//  ChangeUserNameViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/2/27.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "ChangeUserNameViewController.h"

@interface ChangeUserNameViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@end

@implementation ChangeUserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = ASLocalizedString(@"Edit Nickname");
    [self chooseTitleStr];
    self.userNameTextField.text = self.nameStr;
    self.userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.userNameTextField addTarget:self action:@selector(userNameDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self leftItem];
}

- (void)chooseTitleStr
{
    if ([self.changeStr isEqualToString:@"userName"]) {
        self.title = ASLocalizedString(@"Edit Nickname");
    } else if ([self.changeStr isEqualToString:@"shopName"]) {
        self.title = ASLocalizedString(@"Edit Shopname");
    } else if ([self.changeStr isEqualToString:@"welcome"]) {
        self.title = ASLocalizedString(@"Edit Welcomes");
    } else if ([self.changeStr isEqualToString:@"facebook"]) {
        self.title = ASLocalizedString(@"Edit Facebook");
    } else if ([self.changeStr isEqualToString:@"line"]) {
        self.title = ASLocalizedString(@"Edit Line");
    } else if ([self.changeStr isEqualToString:@""]) {
        
    }
}

- (void)leftItem
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:ASLocalizedString(@"Done") forState:UIControlStateNormal];
//    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#111111"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(completeClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:ASLocalizedString(@"Done") style:UIBarButtonItemStylePlain target:self action:@selector(completeClick)];
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
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToMain)];
    [self isHaveUserName];
}

- (void)isHaveUserName
{
    if (self.userNameTextField.text.length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)completeClick
{
    
}

- (void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)userNameDidChange:(UITextField *)textField
{
    NSLog(@"this is your's");
    
    if (textField.text.length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
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
