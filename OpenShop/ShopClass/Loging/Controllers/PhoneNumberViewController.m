//
//  PhoneNumberViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/1/16.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "PhoneNumberViewController.h"
#import "RegisterViewController.h"
#import "WebViewController.h"

@interface PhoneNumberViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreementBtn;

@end

@implementation PhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = ASLocalizedString(@"Register Account");
    self.navigationController.navigationBar.translucent = NO;
    self.phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.phoneNumberTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.nextBtn.enabled = NO;
        if ([self.typeStr isEqualToString:ASLocalizedString(@"ForgetPassword")]) {
            self.title = ASLocalizedString(@"ForgetPassword");
        } else {
            self.title = ASLocalizedString(@"Regist");
        }
    
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    if (viewcontrollers.count > 1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == self) {
            
            [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
        }
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    }
    else{
        //present方式
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(dismissBack) image:@"nav_icon_back" highImage:@""];
    }
}

//- (void)setLiftItem
//{
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
//    // 设置图片
//    [btn setBackgroundImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
//    
//    // 设置尺寸
//    btn.size = btn.currentBackgroundImage.size;
//    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
//    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    space.width = 0;//自己设定
//    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space,leftItem, nil];
//}
- (void)dismissBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextAction:(UIButton *)sender {
    RegisterViewController *regist = [[RegisterViewController alloc] init];
    if ([self.typeStr isEqualToString:ASLocalizedString(@"ForgetPassword")]) {
        regist.typeStr = @"password";
    } else {
        regist.typeStr = @"register";
    }
    regist.phoneNum = self.phoneNumberTextField.text;
    [self.navigationController pushViewController:regist animated:YES];
}

- (IBAction)agreementAction:(UIButton *)sender {
    NSString *urlStr = @"http://api.10bbuy.com/One2Sell%20Terms%20of%20service.html";
    WebViewController *wenView = [[WebViewController alloc] init];
    wenView.showUrl = urlStr;
    [self.navigationController pushViewController:wenView animated:YES];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.phoneNumberTextField) {
        if (textField.text.length >= 1) {
            [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_selected"] forState:UIControlStateNormal];
            self.nextBtn.enabled = YES;
        } else {
            [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"content_btn_login_default"] forState:UIControlStateNormal];
            self.nextBtn.enabled = NO;
        }
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
