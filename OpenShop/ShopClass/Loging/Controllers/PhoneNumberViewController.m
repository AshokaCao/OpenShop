//
//  PhoneNumberViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/1/16.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "PhoneNumberViewController.h"
#import "RegisterViewController.h"

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
    self.phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.phoneNumberTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (IBAction)nextAction:(UIButton *)sender {
    RegisterViewController *regist = [[RegisterViewController alloc] init];
    regist.phoneNum = self.phoneNumberTextField.text;
    [self.navigationController pushViewController:regist animated:YES];
}

- (IBAction)agreementAction:(UIButton *)sender {
    
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.phoneNumberTextField) {
        if (textField.text.length >= 1) {
            [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_selected"] forState:UIControlStateNormal];
        } else {
            [self.nextBtn setBackgroundImage:[UIImage imageNamed:@"content_btn_login_default"] forState:UIControlStateNormal];
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
