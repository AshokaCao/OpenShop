//
//  SelectTableViewCell.m
//  OpenShop
//
//  Created by yuemin3 on 2017/3/24.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "SelectTableViewCell.h"

@implementation SelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showSomeList:(CategoryModel *)model
{
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.name];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
