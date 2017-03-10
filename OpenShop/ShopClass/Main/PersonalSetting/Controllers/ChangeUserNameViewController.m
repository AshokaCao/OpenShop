//
//  ChangeUserNameViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/2/27.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "ChangeUserNameViewController.h"

@interface ChangeUserNameViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@end

@implementation ChangeUserNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = ASLocalizedString(@"Edit Nickname");
    self.userNameTextField.text = self.nameStr;
    self.userNameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self leftItem];
}

- (void)leftItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToMain)];
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
