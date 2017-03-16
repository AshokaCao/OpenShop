//
//  GoodListTableViewCell.m
//  OpenShop
//
//  Created by yuemin3 on 2017/2/23.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "GoodListTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation GoodListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.itemsLa.text = ASLocalizedString(@"Item");
    self.distriLa.text = ASLocalizedString(@"Distributors");
    self.imageWidth.constant = SCREEN_WIDTH * 0.141;
    NSLog(@"shopImageView - %f",self.shopImageView.sd_width);
}

- (void)getMessageForModel:(MarketListModel *)model
{
    self.model = model;
    [self.shopImageView setImageWithURL:[NSURL URLWithString:model.shopimg] placeholderImage:[UIImage imageNamed:@"dianpu_logo"]];
    self.itemsNumLabel.text = [NSString stringWithFormat:@"%@",model.item];
    self.distriNumLabel.text = [NSString stringWithFormat:@"%@",model.discount];
}

- (IBAction)shopListAction:(UIButton *)sender {
    [self.delegate shopList];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
