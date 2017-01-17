//
//  RootViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/1/6.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "RootViewController.h"
#import "MarketMainViewController.h"
#import "CommodityMainViewController.h"
#import "ShopMainViewController.h"
#import "PersonalMainViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    MarketMainViewController *market = [[MarketMainViewController alloc] init];
    CommodityMainViewController *commdity = [[CommodityMainViewController alloc] init];
    ShopMainViewController *shop = [[ShopMainViewController alloc] init];
    PersonalMainViewController *personal = [[PersonalMainViewController alloc] init];
    [self addChildVc:market title:ASLocalizedString(@"好货市场") image:@"" selectedImage:@""];
    [self addChildVc:commdity title:ASLocalizedString(@"商品管理") image:@"" selectedImage:@""];
    [self addChildVc:shop title:ASLocalizedString(@"店铺管理") image:@"" selectedImage:@""];
    [self addChildVc:personal title:ASLocalizedString(@"设置") image:@"" selectedImage:@""];
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = ASLocalizedString(title);
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = RGB_COLOR(123, 123, 123,1);
    
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = RGB_COLOR(231, 75, 89, 1);
    
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    //    childVc.view.backgroundColor = HWRandomColor;
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    
    // 添加为子控制器
    [self addChildViewController:nav];
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
