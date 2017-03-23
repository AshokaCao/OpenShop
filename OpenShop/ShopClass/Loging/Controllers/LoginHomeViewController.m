//
//  LoginHomeViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/3/21.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "LoginHomeViewController.h"
#import "LoginMainViewController.h"
#import "PhoneNumberViewController.h"
#import "MainNavigationViewController.h"

@interface LoginHomeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet UILabel *introduction;
@property (weak, nonatomic) IBOutlet UIImageView *backgrouImageView;
@property (weak, nonatomic) IBOutlet UIButton *signupBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)signupAction:(UIButton *)sender {
    PhoneNumberViewController *phoneN = [[PhoneNumberViewController alloc] init];
    MainNavigationViewController *navc = [[MainNavigationViewController alloc] initWithRootViewController:phoneN];
    [self presentViewController:navc animated:YES completion:nil];
}
- (IBAction)loginAction:(UIButton *)sender {
    LoginMainViewController *login = [[LoginMainViewController alloc] init];
    MainNavigationViewController *navc = [[MainNavigationViewController alloc] initWithRootViewController:login];
    [self presentViewController:navc animated:YES completion:nil];
//    [self.navigationController pushViewController:login animated:YES];
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
