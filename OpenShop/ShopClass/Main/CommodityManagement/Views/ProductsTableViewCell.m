//
//  ProductsTableViewCell.m
//  OpenShop
//
//  Created by yuemin3 on 2017/3/2.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "ProductsTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation ProductsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageViewWidth.constant = SCREEN_WIDTH * 0.213;
    [self.previewBtn setTitle:ASLocalizedString(@"Preview") forState:UIControlStateNormal];
    [self.promotionBtn setTitle:ASLocalizedString(@"Promotion") forState:UIControlStateNormal];
    [self.shareBtn setTitle:ASLocalizedString(@"share") forState:UIControlStateNormal];
    self.distributionLabel.text = ASLocalizedString(@"distribution");
}

- (void)showProductListWith:(MarketListModel *)model
{
    self.productModel = model;
    [self.goodsImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.productModel.goodimgurl]] placeholderImage:[UIImage imageNamed:@""]];
    self.goodsTitleLabel.text = [NSString stringWithFormat:@"%@",self.productModel.goodname];
    self.priceLabel.text = [NSString stringWithFormat:ASLocalizedString(@"price: ฿%@"),self.productModel.price];
    
    NSMutableAttributedString *buyCount = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:ASLocalizedString(@"profit: ฿%@"),self.productModel.profit]];
    NSString *len = [NSString stringWithFormat:ASLocalizedString(@"฿%@"),self.productModel.profit];
    NSString *allLen = [NSString stringWithFormat:ASLocalizedString(@"profit: ฿%@"),self.productModel.profit];
    [buyCount addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#ff213b"] range:NSMakeRange(allLen.length - len.length, len.length)];
    self.profitLabel.attributedText = buyCount;
    NSLog(@"%@",self.productModel.goodfrom);
    NSString *from = [NSString stringWithFormat:@"%@",self.productModel.goodfrom];
    if ([from isEqualToString:@"1"]) {
        self.distributionLabel.hidden = self.distributionImageView.hidden = NO;
    } else {
        self.distributionLabel.hidden = self.distributionImageView.hidden = YES;
    }
}

- (IBAction)previewAction:(UIButton *)sender {
    [self.delegate saleSelectPreviewBtnWithCell:self];
}
- (IBAction)promotionAction:(UIButton *)sender {
    [self.delegate saleSelectpromotionBtnWithCell:self];
}
- (IBAction)shareAction:(UIButton *)sender {
    [self.delegate didselectCellWithButton:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
