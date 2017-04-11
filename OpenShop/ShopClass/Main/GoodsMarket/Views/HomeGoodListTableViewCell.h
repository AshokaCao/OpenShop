//
//  HomeGoodListTableViewCell.h
//  OpenShop
//
//  Created by yuemin3 on 2017/2/23.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketListModel.h"

@protocol HomeGoodListTableViewCellDelegate <NSObject>

- (void)selectSellWith:(UITableViewCell *)cell;

@end

@interface HomeGoodListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerCountLabel;
@property (nonatomic ,strong) MarketListModel *marketModel;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
@property (nonatomic ,assign) id<HomeGoodListTableViewCellDelegate> delegate;

- (void)getMarkerListWithModel:(MarketListModel *)model;

@end
