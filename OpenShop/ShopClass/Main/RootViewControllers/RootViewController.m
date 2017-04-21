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
#import "MainNavigationViewController.h"
#import "ShopViewController.h"
#import "ProductsViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    MarketMainViewController *market = [[MarketMainViewController alloc] init];
    ProductsViewController *commdity = [[ProductsViewController alloc] init];
    ShopViewController *shop = [[ShopViewController alloc] init];
    PersonalMainViewController *personal = [[PersonalMainViewController alloc] init];
    [self addChildVc:market title:ASLocalizedString(@"Market") image:@"tab_icon_market_default" selectedImage:@"tab_icon_market_selected"];
    [self addChildVc:commdity title:ASLocalizedString(@"Products") image:@"tab_icon_products_default" selectedImage:@"tab_icon_products_selected"];
    [self addChildVc:shop title:ASLocalizedString(@"Shop") image:@"tab_icon_shop_default" selectedImage:@"tab_icon_shop_selected"];
    [self addChildVc:personal title:ASLocalizedString(@"Settings") image:@"tab_icon_setting_default" selectedImage:@"tab_icon_setting_selected"];
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
    MainNavigationViewController *nav = [[MainNavigationViewController alloc] initWithRootViewController:childVc];
    
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
