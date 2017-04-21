//
//  ProductsViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/4/20.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "ProductsViewController.h"
#import "SGSegmentedControl.h"

#import "SaleProductsViewController.h"
#import "ShelveProductsViewController.h"

@interface ProductsViewController () <SGSegmentedControlStaticDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) SGSegmentedControlStatic *topSView;
@property (nonatomic, strong) SGSegmentedControlBottomView *bottomSView;

@end

@implementation ProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    // Do any additional setup after loading the view from its nib.
    
    SaleProductsViewController *all = [[SaleProductsViewController alloc] init];
    [self addChildViewController:all];
    ShelveProductsViewController *women = [[ShelveProductsViewController alloc] init];
    [self addChildViewController:women];
    NSArray *childVC = @[all, women,];
    
    NSArray *title_arr = @[ASLocalizedString(@"Sale"),ASLocalizedString(@"Shelve")];
    self.bottomSView = [[SGSegmentedControlBottomView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 108)];
    _bottomSView.childViewController = childVC;
    _bottomSView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    _bottomSView.delegate = self;
    //_bottomView.scrollEnabled = NO;
    [self.view addSubview:_bottomSView];
    
    self.topSView = [SGSegmentedControlStatic segmentedControlWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) delegate:self childVcTitle:title_arr indicatorIsFull:NO];
    self.topSView.backgroundColor = [UIColor whiteColor];
    // 必须实现的方法
    [self.topSView SG_setUpSegmentedControlType:^(SGSegmentedControlStaticType *segmentedControlStaticType, NSArray *__autoreleasing *nomalImageArr, NSArray *__autoreleasing *selectedImageArr) {
        *segmentedControlStaticType = SGSegmentedControlStaticTypeHorizontal;
    }];
    self.topSView.selectedIndex = 0;
    [self.view addSubview:_topSView];
}



- (void)SGSegmentedControlStatic:(SGSegmentedControlStatic *)segmentedControlStatic didSelectTitleAtIndex:(NSInteger)index {
    NSLog(@"index - - %ld", (long)index);
    // 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.bottomSView.contentOffset = CGPointMake(offsetX, 0);
    [self.bottomSView showChildVCViewWithIndex:index outsideVC:self];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 1.添加子控制器view
    [self.bottomSView showChildVCViewWithIndex:index outsideVC:self];
    
    // 2.把对应的标题选中
    [self.topSView changeThePositionOfTheSelectedBtnWithScrollView:scrollView];
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
