//
//  HotSearchCollectionViewCell.m
//  本色堂
//
//  Created by 广州玉贝网络科技有限公司 on 16/4/12.
//  Copyright © 2016年 广州天弈歌贸易有限公司. All rights reserved.
//

#import "HotSearchCollectionViewCell.h"
#define HEX_COLOR(x_RGB) [UIColor colorWithRed:((float)((x_RGB & 0xFF0000) >> 16))/255.0 green:((float)((x_RGB & 0xFF00) >> 8))/255.0 blue:((float)(x_RGB & 0xFF))/255.0 alpha:1.0f]
@interface HotSearchCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIView *backView;


@end
@implementation HotSearchCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backView.layer.cornerRadius = 3.0f;
    self.backView.layer.masksToBounds = YES;
    self.backView.layer.borderColor = HEX_COLOR(0xDDDDDD).CGColor;
    self.backView.layer.borderWidth = 1.0f;

}

@end
