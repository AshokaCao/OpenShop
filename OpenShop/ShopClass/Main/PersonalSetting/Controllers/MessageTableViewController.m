//
//  MessageTableViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/2/27.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "MessageTableViewController.h"
#import "MessageTableTableViewCell.h"

@interface MessageTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *messageTaleView;

@end

@implementation MessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = ASLocalizedString(@"Message");
    [self leftItem];
    
    [self.messageTaleView registerNib:[UINib nibWithNibName:@"MessageTableTableViewCell" bundle:nil] forCellReuseIdentifier:@"messageTableCell"];
}

- (void)leftItem
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backToMain) image:@"nav_icon_back" highImage:@""];
}

- (void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageTableCell"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_WIDTH * 0.128;
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
