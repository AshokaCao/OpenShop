//
//  SelectCategoryViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/3/24.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "SelectCategoryViewController.h"
#import "SelectTableViewCell.h"
#import "CategoryModel.h"


@interface SelectCategoryViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *selectTableView;
@property (nonatomic ,strong) NSIndexPath *lastIndexPath;
@property (nonatomic ,strong) NSMutableArray *typeArray;

@end

@implementation SelectCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.selectTableView registerNib:[UINib nibWithNibName:@"SelectTableViewCell" bundle:nil] forCellReuseIdentifier:@"selectCell"];
    self.selectTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.selectTableView.scrollEnabled = NO;
    [self getCategoryTable];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.typeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCell"];
    if (!cell) {
        cell = [[SelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"selectCell"];
    }
    CategoryModel *model = self.typeArray[indexPath.row];
    cell.selectImageView.hidden = YES;
    [cell showSomeList:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当前cell row
    NSInteger newRow = [indexPath row];
    //记录上一次cell row
    NSInteger oldRow = (self.lastIndexPath != nil) ? [self.lastIndexPath row] : -1;
    if (newRow != oldRow)
    {
        //选中cell
        SelectTableViewCell *newcell =  [tableView cellForRowAtIndexPath:indexPath];
        newcell.selectImageView.hidden = NO;
        //取消上一次选中cell
        SelectTableViewCell *oldCell = [tableView cellForRowAtIndexPath:self.lastIndexPath];
        oldCell.selectImageView.hidden = YES;
    }
    self.lastIndexPath = indexPath;
    CategoryModel *model = self.typeArray[indexPath.row];
    NSString *typeNum = [NSString stringWithFormat:@"%@",model.tyid];
    self.selectedBlock(typeNum);
}
- (void)returnRoomName:(SelectedBlock)block{
    self.selectedBlock = block;
}
- (void)getCategoryTable
{
    self.typeArray = [NSMutableArray array];
    NSString *category = [NSString stringWithFormat:@"http://%@/Good/GoodTypes.ashx",publickUrl];
    [PPNetworkHelper GET:category parameters:nil success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        NSLog(@"34567876543456 ---%@",responseObject);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dict[@"returncode"] isEqualToString:@"success"]) {
                NSMutableArray *array = [dict valueForKey:@"goodtypes"];
                for (NSDictionary *diction in array) {
                    CategoryModel *model = [[CategoryModel alloc] init];
                    [model setValuesForKeysWithDictionary:diction];
                    [self.typeArray addObject:model];
                }
            } else {
                
            }
            [self.selectTableView reloadData];
        });
    } failure:^(NSError *error) {
        NSLog(@"34567876543456");
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
