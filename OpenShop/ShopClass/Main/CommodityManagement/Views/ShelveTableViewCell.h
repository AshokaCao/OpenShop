//
//  ShelveTableViewCell.h
//  OpenShop
//
//  Created by yuemin3 on 2017/3/2.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketListModel.h"

@protocol ShelveTableViewCellDelegate <NSObject>

- (void)selectPreviewBtnWithCell:(UITableViewCell *)cell;


@end

@interface ShelveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
@property (weak, nonatomic) IBOutlet UIView *shadowView;
@property (weak, nonatomic) IBOutlet UILabel *shadowLabel;
@property (weak, nonatomic) IBOutlet UIButton *previewBtn;
@property (weak, nonatomic) IBOutlet UIButton *onsaleBtn;
@property (nonatomic ,assign) id<ShelveTableViewCellDelegate> delegate;
@property (nonatomic ,strong) MarketListModel *productModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidth;
@property (weak, nonatomic) IBOutlet UILabel *discardLabel;

- (void)showShelveListWith:(MarketListModel *)model;

@end
