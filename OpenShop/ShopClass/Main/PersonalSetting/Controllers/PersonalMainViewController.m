//
//  PersonalMainViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/1/10.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "PersonalMainViewController.h"
#import "PersonSettingTableViewCell.h"
#import "UserSettingViewController.h"
#import "MessageTableViewController.h"

@interface PersonalMainViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIView *userImageView;
@property (weak, nonatomic) IBOutlet UITableView *personalTableView;

@end

@implementation PersonalMainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextPage:)];
    [self.userImageView addGestureRecognizer:tap];
    self.personalTableView.scrollEnabled = NO;
    [self.personalTableView registerNib:[UINib nibWithNibName:@"PersonSettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"personCell"];
    
    [self leftItem];
}

- (void)leftItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_xiaoxi"] style:UIBarButtonItemStylePlain target:self action:@selector(messageTable)];
}

- (void)messageTable
{
    MessageTableViewController *message = [[MessageTableViewController alloc] init];
    [self.navigationController pushViewController:message animated:YES];
}

- (void)nextPage:(UITapGestureRecognizer *)tap
{
    UserSettingViewController *setting = [[UserSettingViewController alloc] init];
    [self.navigationController pushViewController:setting animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 3;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personCell"];
    NSArray *textArray = @[@"About us",@"Rate",@"Help&FAQ",@"Terms&Plicy",@"Feedback&Report&Problem",@"Invite Friends"];
    cell.firstLable.text = textArray[indexPath.section + indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_WIDTH * 0.128;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
        } else {
            
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            
        } else if (indexPath.row == 1) {
            
        } else if (indexPath.row == 2) {
            
        }
    } else if (indexPath.section == 2) {
        
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
