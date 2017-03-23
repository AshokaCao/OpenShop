//
//  SetupShopViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/2/23.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "SetupShopViewController.h"
#import "UIView+Help.h"

@interface SetupShopViewController ()
@property (weak, nonatomic) IBOutlet UIView *headerBackView;
@property (weak, nonatomic) IBOutlet UIImageView *heaserImageView;
@property (weak, nonatomic) IBOutlet UITextField *shopNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *facebookTextField;

@end

@implementation SetupShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [UIView roundedCornersWith:102 shadowWith:0 andShadowColor:nil fromView:self.headerBackView];
    
}

- (void)addChosePhoto
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePhoto)];
    [self.heaserImageView addGestureRecognizer:tap];
}

- (void)choosePhoto
{
    
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
