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
}

- (IBAction)getCodeNumberAction:(UIButton *)sender {
    [self getCodeNumberWithPhoneNumber:self
     .phoneNum];
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
