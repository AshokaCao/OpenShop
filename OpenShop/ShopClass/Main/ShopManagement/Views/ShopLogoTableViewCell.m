//
//  ShopLogoTableViewCell.m
//  OpenShop
//
//  Created by yuemin3 on 2017/4/18.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "ShopLogoTableViewCell.h"

@implementation ShopLogoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.logoImageView.sd_width = SCREEN_WIDTH * 0.146;
    NSLog(@"---- --  %f",self.logoImageView.sd_width);
    self.logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.logoImageView.clipsToBounds = YES;
    self.logoImageView.layer.cornerRadius = SCREEN_WIDTH * 0.146 / 2;
    self.logoImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
