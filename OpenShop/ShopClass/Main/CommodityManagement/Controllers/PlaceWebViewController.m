//
//  PlaceWebViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/4/10.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "PlaceWebViewController.h"
#import <WebKit/WebKit.h>

@interface PlaceWebViewController ()
@property (weak, nonatomic) IBOutlet UIButton *shelveBtn;
@property (weak, nonatomic) IBOutlet UIWebView *webListView;

@end

@implementation PlaceWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.webListView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
}
- (IBAction)shelveAction:(UIButton *)sender {
    NSString *shelvrUrl = [NSString stringWithFormat:@"http://%@/Good/ShelfGood.ashx",publickUrl];
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    diction[@"goodid"] = self.editModel.goodid;
    diction[@"userid"] = [nNsuserdefaul objectForKey:@"userID"];
    NSLog(@"goutongshib - %@",self.editModel.goodid);
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"accessToken"] forHTTPHeaderField:@"accesstoken"];
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"refreshToken"] forHTTPHeaderField:@"refreshtoken"];
    [PPNetworkHelper POST:shelvrUrl parameters:diction success:^(id responseObject) {
        NSLog(@"xiajia   %@",responseObject);
        NSDictionary *dic = responseObject;
        if ([dic[@"returncode"] isEqualToString:@"success"]) {
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:@"success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alerV show];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSString *mess = dic[@"msg"];
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:mess delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alerV show];
        }
    } failure:^(NSError *error) {
        NSLog(@"goutongshib");
        UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:@"链接失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alerV show];
    }];
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
