//
//  UIColor+Help.h
//  SellerWaterMark
//
//  Created by yuemin3 on 2016/12/7.
//  Copyright © 2016年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Help)

+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (NSString *) hexFromUIColor: (UIColor*) color;
+ (UIColor *) colorWithHexString: (NSString *) hexString;

@end
