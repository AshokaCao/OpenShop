//
//  RegisterViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/1/16.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "RegisterViewController.h"
#import "PPNetworkHelper.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *codeNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (nonatomic ,strong) NSString *codeStr;
@property (nonatomic ,strong) NSString *passWordNum;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.title = ASLocalizedString(@"Reset Password");
    self.codeNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self.codeNumberTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}





- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.codeNumberTextField) {
        if (textField.text.length >= 1) {
            [self.doneBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_selected"] forState:UIControlStateNormal];
        } else {
            [self.doneBtn setBackgroundImage:[UIImage imageNamed:@"content_btn_login_default"] forState:UIControlStateNormal];
        }
    }
}


- (IBAction)getCodeNumberAction:(UIButton *)sender {
    [self getCodeNumberWithPhoneNumber:self
     .phoneNum];
    __weak typeof(self) temp = self;
    __block int timeout=30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [temp.codeBtn setTitle:ASLocalizedString(@"验证码") forState:UIControlStateNormal];
                [temp.codeBtn setBackgroundImage:[UIImage imageNamed:@"btn_huoquyanzhe ngma"] forState:UIControlStateNormal];
                temp.codeBtn.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [temp.codeBtn setTitle:[NSString stringWithFormat:ASLocalizedString(@"剩余%@秒"),strTime] forState:UIControlStateNormal];
                [temp.codeBtn setBackgroundImage:[UIImage imageNamed:@"btn_huoquyanzhe ngma_daojishi"] forState:UIControlStateNormal];
                [UIView commitAnimations];
                temp.codeBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (IBAction)finishAction:(UIButton *)sender {
    self.passWordNum = self.passWordTextField.text;
    [self registerUserNum];
    NSLog(@"phoneNum - %@ codeStr - %@ passWordNum - %@",self.phoneNum,self.codeStr,self.passWordNum);
}

- (void)getCodeNumberWithPhoneNumber:(NSString *)number
{
    NSString *urlCode = [NSString stringWithFormat:@"http://%@/Page/setting/SendSMS.ashx?mobile=%@&verifytype=register",tLocalUrl,number];
    NSLog(@"%@",urlCode);
    [PPNetworkHelper GET:urlCode parameters:nil success:^(id responseObject) {
        NSLog(@"success: ----- %@",responseObject);
        if (responseObject) {
            self.codeStr = [NSString stringWithFormat:@"%@",responseObject[@"verifycode"]];
            NSLog(@"success: ----- %@",self.codeStr);
        } else {
            
        }
    } failure:^(NSError *error) {
        NSLog(@"cuwu");
    }];
}

- (void)registerUserNum
{
    NSString *regist = [NSString stringWithFormat:@"http://%@/Page/UCenter/register.ashx?mobile=%@&verifycode=%@&password=%@",tLocalUrl,self.phoneNum,self.codeStr,self.passWordNum];
    [PPNetworkHelper GET:regist parameters:nil success:^(id responseObject) {
        NSLog(@"注册 - %@",responseObject);
    } failure:^(NSError *error) {
        NSLog(@"错误 - %@",error);
    }];
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
