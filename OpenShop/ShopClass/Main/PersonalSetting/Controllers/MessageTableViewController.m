//
//  MessageTableViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/2/27.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "MessageTableViewController.h"
#import "MessageTableTableViewCell.h"
#import "MessageModel.h"

@interface MessageTableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *messageTaleView;
@property (nonatomic ,strong) NSMutableArray *messageArray;
@property (nonatomic ,strong) NSString *messCount;

@end

@implementation MessageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = ASLocalizedString(@"Message");
    [self leftItem];
    [self getMessageDatel];
    [self.messageTaleView registerNib:[UINib nibWithNibName:@"MessageTableTableViewCell" bundle:nil] forCellReuseIdentifier:@"messageTableCell"];
    self.messageTaleView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.messCount = [nNsuserdefaul objectForKey:@"messageCount"];
}

- (void)leftItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    
    // 设置尺寸
    btn.size = btn.currentBackgroundImage.size;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -7;//自己设定
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space,leftItem, nil];
}

- (void)getMessageDatel
{
    NSString *message = [NSString stringWithFormat:@"http://%@/Handler/Tips.ashx?system=1",publickUrl];
    self.messageArray = [NSMutableArray array];
    [PPNetworkHelper GET:message parameters:nil success:^(id responseObject) {
        NSLog(@"--- ---  %@",responseObject);
        NSDictionary *diction = responseObject;
        NSString *returnCode = diction[@"returncode"];
        if ([returnCode isEqualToString:@"success"]) {
            for (NSDictionary *messDic in diction[@"tipslist"]) {
                MessageModel *model = [[MessageModel alloc] init];
                [model setValuesForKeysWithDictionary:messDic];
                [self.messageArray addObject:model];
                NSLog(@"%@",model.title);
            }
        }
        
        [nNsuserdefaul setObject:[NSString stringWithFormat:@"%ld",self.messageArray.count] forKey:@"messageCount"];
        [nNsuserdefaul synchronize];
        [self.messageTaleView reloadData];
    } failure:^(NSError *error) {
        
    }];
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
    return self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageTableCell"];
    if (!cell) {
        cell = [[MessageTableTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"messageTableCell"];
    }
    MessageModel *model = self.messageArray[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.timeLabel.text = model.time;
    cell.subTitleLabel.text = model.content;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SCREEN_WIDTH * 0.162;
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
