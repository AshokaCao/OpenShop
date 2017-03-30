//
//  SearchViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/3/28.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addSearchView];
//    self.navigationItem.leftBarButtonItem.;
}

- (void)addSearchView
{
    UIView *bootmView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
//    bootmView.backgroundColor = [UIColor blackColor];
    UIImageView *searchImageView = [[UIImageView alloc] init];
    searchImageView.contentMode = UIViewContentModeScaleAspectFill;
    searchImageView.image = [UIImage imageNamed:@"nav_icon_sousuo"];
    searchImageView.size = searchImageView.image.size;
    searchImageView.centerY = bootmView.centerY;
    searchImageView.centerX = searchImageView.sd_width / 2 + 10;
    [bootmView addSubview:searchImageView];
    UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(44, 0, SCREEN_WIDTH - 44 - 85, 44)];
    
    [bootmView addSubview:searchTextField];
    
    [self.navigationController.navigationBar addSubview:bootmView];
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
