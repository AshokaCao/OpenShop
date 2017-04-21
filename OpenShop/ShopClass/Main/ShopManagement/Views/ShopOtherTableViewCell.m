//
//  ShopOtherTableViewCell.m
//  OpenShop
//
//  Created by yuemin3 on 2017/4/18.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "ShopOtherTableViewCell.h"

@implementation ShopOtherTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitleLabelText:(NSString *)text
{
    self.titileNameLabel.text = text;
    NSLog(@"self.titileNameLabel.text - - %@",self.titileNameLabel.text);
    if ([text isEqualToString:ASLocalizedString(@"identity")] || [text isEqualToString:ASLocalizedString(@"Line")]) {
        self.lineView.hidden = YES;
    } else {
        self.lineView.hidden = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
