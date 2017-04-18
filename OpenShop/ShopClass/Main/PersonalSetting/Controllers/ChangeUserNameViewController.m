//
//  ChangeUserNameViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/2/27.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "ChangeUserNameViewController.h"
#import "PhoneNumberViewController.h"

@interface ChangeUserNameViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@end

@implementation ChangeUserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = ASLocalizedString(@"Edit Nickname");
    [self chooseTitleStr];
    self.userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.userNameTextField addTarget:self action:@selector(userNameDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self leftItem];
}

- (void)chooseTitleStr
{
    if (self.nameStr.length > 1) {
        self.userNameTextField.text = self.nameStr;
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
    } else {
        if ([self.changeStr isEqualToString:@"userName"]) {
            self.userNameTextField.placeholder = ASLocalizedString(@"Please enter your name");
        } else if ([self.changeStr isEqualToString:@"shopName"]) {
            self.userNameTextField.placeholder = ASLocalizedString(@"Please enter your shop name");
        } else if ([self.changeStr isEqualToString:@"welcome"]) {
            self.userNameTextField.placeholder = ASLocalizedString(@"Please enter welcomes");
        } else if ([self.changeStr isEqualToString:@"facebook"]) {
            self.userNameTextField.placeholder = ASLocalizedString(@"Please enter your facebook");
        } else if ([self.changeStr isEqualToString:@"line"]) {
            self.userNameTextField.placeholder = ASLocalizedString(@"Please enter your line");
        } else if ([self.changeStr isEqualToString:@""]) {
            
        }
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
    
    if ([self.changeStr isEqualToString:@"userName"]) {
        self.title = ASLocalizedString(@"Edit Nickname");
        [self changeUserName];
    } else if ([self.changeStr isEqualToString:@"shopName"]) {
        [self changeShopName];
    } else if ([self.changeStr isEqualToString:@"welcome"]) {
        [self changeWelcome];
    } else if ([self.changeStr isEqualToString:@"facebook"]) {
        [self changeFacebook];
    } else if ([self.changeStr isEqualToString:@"line"]) {
        [self changeLine];
        self.title = ASLocalizedString(@"Edit Line");
    } else if ([self.changeStr isEqualToString:@""]) {
        
    }
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

- (void)changeUserName
{
    NSString *upload = [NSString stringWithFormat:@"http://%@/Account/UserModify.ashx",publickUrl];
    NSMutableDictionary *uploadShop = [NSMutableDictionary dictionary];
    uploadShop[@"userid"] = [nNsuserdefaul objectForKey:@"userID"];
    uploadShop[@"modify"] = @"Name";
    uploadShop[@"content"] = self.userNameTextField.text;
    
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"accessToken"] forHTTPHeaderField:@"accesstoken"];
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"refreshToken"] forHTTPHeaderField:@"refreshtoken"];
    [PPNetworkHelper POST:upload parameters:uploadShop success:^(id responseObject) {
        NSDictionary *diction = responseObject;
        NSString *code = diction[@"returncode"];
        if ([code isEqualToString:@"success"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = ASLocalizedString(@"成功");
            [hud hide:YES afterDelay:2];
            
            [self backToMain];
        } else {
            NSLog(@"error - - %@",responseObject);
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = ASLocalizedString(@"失败");
            [hud hide:YES afterDelay:2];
        }
        
    } failure:^(NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = ASLocalizedString(@"网络故障");
        [hud hide:YES afterDelay:2];
    }];
}

- (void)changeShopName
{
    NSString *upload = [NSString stringWithFormat:@"http://%@/Shop/UpdateShop.ashx",publickUrl];
    NSMutableDictionary *uploadShop = [NSMutableDictionary dictionary];
    uploadShop[@"userid"] = [nNsuserdefaul objectForKey:@"userID"];
    uploadShop[@"modify"] = @"Name";
    uploadShop[@"content"] = self.userNameTextField.text;
    
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"accessToken"] forHTTPHeaderField:@"accesstoken"];
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"refreshToken"] forHTTPHeaderField:@"refreshtoken"];
    [PPNetworkHelper POST:upload parameters:uploadShop success:^(id responseObject) {
        NSDictionary *diction = responseObject;
        NSString *code = diction[@"returncode"];
        if ([code isEqualToString:@"success"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = ASLocalizedString(@"成功");
            [hud hide:YES afterDelay:2];
            
            [self backToMain];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = ASLocalizedString(@"失败");
            [hud hide:YES afterDelay:2];
        }
        
    } failure:^(NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = ASLocalizedString(@"网络故障");
        [hud hide:YES afterDelay:2];
    }];
}

- (void)changeWelcome
{
    NSString *upload = [NSString stringWithFormat:@"http://%@/Shop/UpdateShop.ashx",publickUrl];
    NSMutableDictionary *uploadShop = [NSMutableDictionary dictionary];
    uploadShop[@"userid"] = [nNsuserdefaul objectForKey:@"userID"];
    uploadShop[@"modify"] = @"Slogan";
    uploadShop[@"content"] = self.userNameTextField.text;
    
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"accessToken"] forHTTPHeaderField:@"accesstoken"];
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"refreshToken"] forHTTPHeaderField:@"refreshtoken"];
    [PPNetworkHelper POST:upload parameters:uploadShop success:^(id responseObject) {
        NSDictionary *diction = responseObject;
        NSString *code = diction[@"returncode"];
        if ([code isEqualToString:@"success"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = ASLocalizedString(@"成功");
            [hud hide:YES afterDelay:2];
            [self backToMain];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = ASLocalizedString(@"失败");
            [hud hide:YES afterDelay:2];
        }
        
    } failure:^(NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = ASLocalizedString(@"网络故障");
        [hud hide:YES afterDelay:2];
    }];
}

- (void)changeFacebook
{
    NSString *upload = [NSString stringWithFormat:@"http://%@/Shop/UpdateShop.ashx",publickUrl];
    NSMutableDictionary *uploadShop = [NSMutableDictionary dictionary];
    uploadShop[@"userid"] = [nNsuserdefaul objectForKey:@"userID"];
    uploadShop[@"modify"] = @"Facebook";
    uploadShop[@"content"] = self.userNameTextField.text;
    
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"accessToken"] forHTTPHeaderField:@"accesstoken"];
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"refreshToken"] forHTTPHeaderField:@"refreshtoken"];
    [PPNetworkHelper POST:upload parameters:uploadShop success:^(id responseObject) {
        NSDictionary *diction = responseObject;
        NSString *code = diction[@"returncode"];
        if ([code isEqualToString:@"success"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = ASLocalizedString(@"成功");
            [hud hide:YES afterDelay:2];
            [self backToMain];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = ASLocalizedString(@"失败");
            [hud hide:YES afterDelay:2];
        }
        
    } failure:^(NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = ASLocalizedString(@"网络故障");
        [hud hide:YES afterDelay:2];
    }];
}

- (void)changeLine
{
    NSString *upload = [NSString stringWithFormat:@"http://%@/Shop/UpdateShop.ashx",publickUrl];
    NSMutableDictionary *uploadShop = [NSMutableDictionary dictionary];
    uploadShop[@"userid"] = [nNsuserdefaul objectForKey:@"userID"];
    uploadShop[@"modify"] = @"Line";
    uploadShop[@"content"] = self.userNameTextField.text;
    
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"accessToken"] forHTTPHeaderField:@"accesstoken"];
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"refreshToken"] forHTTPHeaderField:@"refreshtoken"];
    [PPNetworkHelper POST:upload parameters:uploadShop success:^(id responseObject) {
        NSLog(@"responseObject - -  - - %@",responseObject);
        NSDictionary *diction = responseObject;
        NSString *code = diction[@"returncode"];
        if ([code isEqualToString:@"success"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = ASLocalizedString(@"成功");
            [hud hide:YES afterDelay:2];
            [self backToMain];
        } else {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = ASLocalizedString(@"失败");
            [hud hide:YES afterDelay:2];
        }
    } failure:^(NSError *error) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = ASLocalizedString(@"网络故障");
        [hud hide:YES afterDelay:2];
    }];
}

- (void)changePhone
{
    PhoneNumberViewController *phone = [[PhoneNumberViewController alloc] init];
    [self.navigationController pushViewController:phone animated:YES];
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
