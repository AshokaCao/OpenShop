//
//  IdentificationViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/3/2.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "IdentificationViewController.h"

@interface IdentificationViewController ()

@end

@implementation IdentificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = ASLocalizedString(@"Authentiction");
    
    [self leftItem];
}

- (void)leftItem
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backToMain) image:@"nav_icon_back" highImage:@""];
}
        
- (void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
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
