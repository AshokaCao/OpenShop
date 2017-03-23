//
//  ShelveTableViewCell.m
//  OpenShop
//
//  Created by yuemin3 on 2017/3/2.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "ShelveTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation ShelveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageViewWidth.constant = SCREEN_WIDTH * 0.213;
    self.shadowLabel.text = ASLocalizedString(@"discard");
    self.discardLabel.text = ASLocalizedString(@"The supplier has crased to distribute the goods");
}

- (void)showShelveListWith:(MarketListModel *)model
{
    self.productModel = model;
    [self.productImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.productModel.goodimgurl]] placeholderImage:[UIImage imageNamed:@""]];
    self.productNameLabel.text = [NSString stringWithFormat:@"%@",self.productModel.goodname];
    self.priceLabel.text = [NSString stringWithFormat:ASLocalizedString(@"price: $%@"),self.productModel.price];
    
    NSMutableAttributedString *buyCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:ASLocalizedString(@"profit: $%@"),self.productModel.profit]];
    NSString *len = [NSString stringWithFormat:ASLocalizedString(@"$%@"),self.productModel.profit];
    NSString *allLen = [NSString stringWithFormat:ASLocalizedString(@"profit: $%@"),self.productModel.profit];
    [buyCount addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff213b"] range:NSMakeRange(allLen.length - len.length, len.length)];
    self.profitLabel.attributedText = buyCount;
    NSLog(@"%@",self.productModel.state);
    NSString *stateNum = [NSString stringWithFormat:@"%@",self.productModel.state];
    if ([stateNum isEqualToString:@"2"]) {
        [self.productNameLabel setTextColor:[UIColor colorWithHexString:@"#111111"]];
        self.shadowView.hidden = self.shadowLabel.hidden = self.discardLabel.hidden = YES;
        self.priceLabel.hidden = self.profitLabel.hidden = NO;
    } else if ([stateNum isEqualToString:@"3"]) {
        [self.productNameLabel setTextColor:[UIColor colorWithHexString:@"#b7b7b7"]];
        self.shadowView.hidden = self.shadowLabel.hidden = self.discardLabel.hidden = NO;
        self.priceLabel.hidden = self.profitLabel.hidden = YES;
    }
}

- (IBAction)previewAction:(UIButton *)sender {
    [self.delegate selectPreviewBtnWithCell:self];
}
- (IBAction)saleAction:(UIButton *)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
