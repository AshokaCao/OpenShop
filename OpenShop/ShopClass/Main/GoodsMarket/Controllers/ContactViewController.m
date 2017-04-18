//
//  ContactViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/3/14.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%@-%@-%@",self.phoneNum,self.lineNum,self.facebookNum);
}
- (IBAction)callPhoneAction:(UIButton *)sender {
    UIWebView *webView = [[UIWebView alloc] init];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:10086"]]];
    [self.view addSubview:webView];
}
- (IBAction)facebookAction:(UIButton *)sender {
    NSURL *faceUrl = [NSURL URLWithString:self.facebookNum];
    if ([[UIApplication sharedApplication] canOpenURL:faceUrl]) {
        [[UIApplication sharedApplication] openURL:faceUrl];
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = ASLocalizedString(@"暂无联系方式");
        [hud hide:YES afterDelay:2];
    }
}
- (IBAction)lineAction:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (self.lineNum) {
        pasteboard.string = self.lineNum;
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = ASLocalizedString(@"暂无联系方式");
        [hud hide:YES afterDelay:2];
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
