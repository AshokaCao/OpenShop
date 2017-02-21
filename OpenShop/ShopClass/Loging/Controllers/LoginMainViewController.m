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

#define TESTURL @"http://192.168.1.188:88/Page/setting/SendSMS.ashx?mobile=13800571505&verifytype=register"

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
}

- (void)getCodeNumberWithPhoneNumber:(NSString *)number
{
    NSString *urlCode = [NSString stringWithFormat:@"http://%@/Page/setting/SendSMS.ashx?mobile=%@&verifytype=register",tLocalUrl,number];
    [PPNetworkHelper GET:urlCode parameters:nil success:^(id responseObject) {
        NSLog(@"success:  %@",[self jsonToString:responseObject]);
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (IBAction)loginAction:(UIButton *)sender {
    
}

- (IBAction)forgetPasswordAction:(UIButton *)sender {
    
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.phoneNumberTextField) {
        if (textField.text.length >= 1) {
            [self.logBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_selected"] forState:UIControlStateNormal];
        } else {
            [self.logBtn setBackgroundImage:[UIImage imageNamed:@"content_btn_login_default"] forState:UIControlStateNormal];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    return YES;
}







- (IBAction)registerAction:(UIButton *)sender {
    PhoneNumberViewController *registVC = [[PhoneNumberViewController alloc] init];
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
