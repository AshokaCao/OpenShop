//
//  GoodListTableViewCell.h
//  OpenShop
//
//  Created by yuemin3 on 2017/2/23.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketListModel.h"

@protocol GoodListTableViewCellDelegate <NSObject>

- (void)shopList;

@end

@interface GoodListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *levelImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemsNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *distriNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemsLa;
@property (weak, nonatomic) IBOutlet UILabel *distriLa;
@property (nonatomic ,strong) MarketListModel *model;
@property (nonatomic ,assign) id<GoodListTableViewCellDelegate> delegate;

- (void)getMessageForModel:(MarketListModel *)model;

@end
