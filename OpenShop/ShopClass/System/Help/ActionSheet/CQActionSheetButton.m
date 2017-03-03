//
//  CQActionSheetButton.m
//  LuckyBuy
//
//  Created by yuemin3 on 16/8/12.
//  Copyright © 2016年 yuemin3. All rights reserved.
//

#import "CQActionSheetButton.h"

#define kTitlePrecent 0.4
#define kImageViewWH 40

#define RGB(r, g, b)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@implementation CQActionSheetButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:10];
        [self setTitleColor:RGB(40, 40, 40) forState:UIControlStateNormal];
        self.imageView.layer.cornerRadius = kImageViewWH * 0.5;
    }
    return self;
}

#pragma mark 调整文字的位置和尺寸
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleW = self.frame.size.width;
    CGFloat titleH = self.frame.size.height * kTitlePrecent;
    CGFloat titleX = 2;
    CGFloat titleY = self.frame.size.height * (1 - kTitlePrecent) + 7;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

#pragma mark 调整图片的位置和尺寸
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = kImageViewWH;
    CGFloat imageH = kImageViewWH;
    CGFloat imageX = (self.frame.size.width - kImageViewWH) * 0.5;
    CGFloat imageY = 2;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

@end
