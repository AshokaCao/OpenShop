//
//  HomeGoodListTableViewCell.m
//  OpenShop
//
//  Created by yuemin3 on 2017/2/23.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "HomeGoodListTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation HomeGoodListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)getMarkerListWithModel:(MarketListModel *)model
{
    self.marketModel = model;
    [self.goodsImageView setImageWithURL:[NSURL URLWithString:self.marketModel.img] placeholderImage:[UIImage imageNamed:@"shangpintu_img_default"]];
    self.goodsTitleLabel.text = [NSString stringWithFormat:@"%@",self.marketModel.goodname];
    self.priceLabel.text = [NSString stringWithFormat:ASLocalizedString(@"price: ฿%@"),self.marketModel.price];
    
    NSMutableAttributedString *buyCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:ASLocalizedString(@"profit: ฿%@"),self.marketModel.profit]];
    NSString *len = [NSString stringWithFormat:ASLocalizedString(@"฿%@"),self.marketModel.profit];
    NSString *allLen = [NSString stringWithFormat:ASLocalizedString(@"profit: ฿%@"),self.marketModel.profit];
    NSLog(@"%@",allLen);
    [buyCount addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff213b"] range:NSMakeRange(allLen.length - len.length, len.length)];
    self.profitLabel.attributedText = buyCount;
    self.sellerCountLabel.text = [NSString stringWithFormat:ASLocalizedString(@"%@ distribution"),self.marketModel.discount];
}
- (IBAction)sellAction:(UIButton *)sender {
    [self.delegate selectSellWith:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
