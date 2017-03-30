//
//  SelectTableViewCell.h
//  OpenShop
//
//  Created by yuemin3 on 2017/3/24.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"

@interface SelectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

- (void)showSomeList:(CategoryModel *)model;

@end
