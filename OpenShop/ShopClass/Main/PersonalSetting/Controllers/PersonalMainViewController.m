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
#import "WebViewController.h"
#import "UIImageView+AFNetworking.h"

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
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"personCell"];
    NSDictionary *diction = @{@"one":@[@"Help&FAQ",@"About us",@"Rate us"],@"two":@[@"Invite Friends"]};
    NSArray *arr = @[@"one",@"two"];
    cell.firstLable.text = diction[arr[indexPath.section]][indexPath.row];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.imagView.image = [UIImage imageNamed:@"help_icon"];
                    break;
                case 1:
                    cell.imagView.image = [UIImage imageNamed:@"guanyu_icon"];
                    break;
                case 2:
                    cell.imagView.image = [UIImage imageNamed:@"heart_icon"];
                    break;
                    
                default:
                    break;
            }
            break;
        case 1:
            cell.imagView.image = [UIImage imageNamed:@"yaoqing_icon"];
            break;
            
        default:
            break;
    }
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
    WebViewController *webVC = [[WebViewController alloc] init];
    [self.navigationController pushViewController:webVC animated:YES];
    NSLog(@"indexPath.section - %ld indexPath.row - %ld",indexPath.section,indexPath.row);
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                
                break;
                
            case 1:
                
                break;
                
            case 2:
                
                break;
                
            default:
                break;
        }
    } else {
        
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
