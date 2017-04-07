//
//  LoginMainViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/1/6.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "LoginMainViewController.h"
#import "PhoneNumberViewController.h"
#import "PPNetworkHelper.h"
#import "AFNetworking.h"
#import "RootViewController.h"
#import "SetupShopViewController.h"

@interface LoginMainViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *logBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;

@end

@implementation LoginMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.translucent = NO;
    self.title = ASLocalizedString(@"Login");
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f6f6f6"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:ASLocalizedString(@"Forget Password")];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#888888"] range:strRange];
    [self.forgetBtn setAttributedTitle:str forState:UIControlStateNormal];
    
    self.phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passWordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.phoneNumberTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self setLiftItem];
    self.logBtn.enabled = NO;
}

//- (void)getCodeNumberWithPhoneNumber:(NSString *)number
//{
//    NSString *urlCode = [NSString stringWithFormat:@"http://%@/Page/setting/SendSMS.ashx?mobile=%@&verifytype=register",tLocalUrl,number];
//    [PPNetworkHelper GET:urlCode parameters:nil success:^(id responseObject) {
 //       NSLog(@"success:  %@",[self jsonToString:responseObject]);
        
 //   } failure:^(NSError *error) {
  //      NSLog(@"%@",error);
 //   }];
//}//

- (IBAction)loginAction:(UIButton *)sender {
    [self.phoneNumberTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
    NSString *logUrl = [NSString stringWithFormat:@"http://%@/Account/Login.ashx",publickUrl];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"mobile"] = [NSString stringWithFormat:@"%@",self.phoneNumberTextField.text];
    dic[@"password"] = [NSString stringWithFormat:@"%@",self.passWordTextField.text];
    __block NSURLSessionTask *task = [PPNetworkHelper POST:logUrl parameters:dic success:^(id responseObject) {
        NSLog(@"responseObject  -  %@",responseObject);
        
        NSDictionary *logDic = responseObject;
        NSString *returnCode = logDic[@"returncode"];
        if ([returnCode isEqualToString:@"success"]) {
            NSDictionary *userDic = logDic[@"memberinfo"];
            NSString *userID = [NSString stringWithFormat:@"%@",userDic[@"userid"]];
            NSString *isShop = [NSString stringWithFormat:@"%@",userDic[@"shop"]];
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSDictionary *allHeaders = response.allHeaderFields;
            NSLog(@"task - %@",allHeaders);
            [nNsuserdefaul setObject:userID forKey:@"userID"];
            [nNsuserdefaul setObject:allHeaders[@"accesstoken"] forKey:@"accessToken"];
            [nNsuserdefaul setObject:allHeaders[@"refreshtoken"] forKey:@"refreshToken"];
            [nNsuserdefaul synchronize];
//            NSLog(@"userID - %@",userID);
            if ([isShop isEqualToString:@"true"]) {
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                window.rootViewController = [[RootViewController alloc] init];
            } else {
                SetupShopViewController *shopUp = [[SetupShopViewController alloc] init];
                [self.navigationController pushViewController:shopUp animated:YES];
            }
        } else if ([returnCode isEqualToString:@"error"]) {
            NSString *returnCode = logDic[@"msg"];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = returnCode;
            [hud hide:YES afterDelay:2];
        }
    } failure:^(NSError *error) {
         NSLog(@"no");
    }];
}

- (IBAction)forgetPasswordAction:(UIButton *)sender {
    PhoneNumberViewController *phoneNum = [[PhoneNumberViewController alloc] init];
    phoneNum.typeStr = @"ForgetPassword";
    [self.navigationController pushViewController:phoneNum animated:YES];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.phoneNumberTextField) {
        if (textField.text.length >= 1) {
            [self.logBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_selected"] forState:UIControlStateNormal];
            self.logBtn.enabled = YES;
        } else {
            [self.logBtn setBackgroundImage:[UIImage imageNamed:@"content_btn_login_default"] forState:UIControlStateNormal];
            self.logBtn.enabled = NO;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.phoneNumberTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.phoneNumberTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
}

- (void)setLiftItem
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
    space.width = 0;//自己设定
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space,leftItem, nil];
}

- (void)backToMain
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)registerAction:(UIButton *)sender {
    PhoneNumberViewController *registVC = [[PhoneNumberViewController alloc] init];
    registVC.typeStr = @"Regist";
    [self.navigationController pushViewController:registVC animated:YES];
}

- (NSString *)jsonToString:(NSDictionary *)dic
{
    if(!dic){
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneNumberTextField resignFirstResponder];
    [self.passWordTextField resignFirstResponder];
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
