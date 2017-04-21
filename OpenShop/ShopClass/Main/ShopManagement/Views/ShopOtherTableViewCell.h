//
//  ShopOtherTableViewCell.h
//  OpenShop
//
//  Created by yuemin3 on 2017/4/18.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopOtherTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
- (void)setTitleLabelText:(NSString *)text;
@end
