//
//  UIView+Help.m
//  OpenShop
//
//  Created by yuemin3 on 2017/2/23.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "UIView+Help.h"

@implementation UIView (Help)

+ (UIView *)roundedCornersWith:(NSInteger )num shadowWith:(NSInteger )shadowNum andShadowColor:(UIColor *)ShadowColor fromView:(UIView *)view
{
//    UIView *aView = [[UIView alloc] init];
//    
//    aView.frame = CGRectMake(0, 0, 300, 200);
//    aView.backgroundColor = [UIColor redColor];
    
    //设置圆角边框
    
    view.layer.cornerRadius = num;
    
    view.layer.masksToBounds = YES;
    
    //设置边框及边框颜色
    
    view.layer.borderWidth = shadowNum;
    
    view.layer.borderColor =[ShadowColor CGColor];
    
    return view;
}

@end
