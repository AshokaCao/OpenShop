//
//  ProductsTableViewCell.h
//  OpenShop
//
//  Created by yuemin3 on 2017/3/2.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketListModel.h"

@protocol ProductsTableViewCellDelegate <NSObject>

- (void)didselectCellWithButton:(UIButton *)btn;
- (void)saleSelectPreviewBtnWithCell:(UITableViewCell *)cell;
- (void)saleSelectpromotionBtnWithCell:(UITableViewCell *)cell;

@end

@interface ProductsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
@property (weak, nonatomic) IBOutlet UIButton *previewBtn;
@property (weak, nonatomic) IBOutlet UIButton *promotionBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIImageView *distributionImageView;
@property (weak, nonatomic) IBOutlet UILabel *distributionLabel;
@property (weak, nonatomic) IBOutlet UIView *discardView;
@property (weak, nonatomic) IBOutlet UILabel *disLabel;
@property (weak, nonatomic) IBOutlet UILabel *distributeLabel;
@property (nonatomic ,assign) id<ProductsTableViewCellDelegate> delegate;
@property (nonatomic ,strong) MarketListModel *productModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidth;

- (void)showProductListWith:(MarketListModel *)model;

@end
