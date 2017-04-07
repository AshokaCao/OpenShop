//
//  EditingGoodsViewController.h
//  OpenShop
//
//  Created by yuemin3 on 2017/3/3.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketListModel.h"

@interface EditingGoodsViewController : UIViewController
@property (nonatomic ,strong) MarketListModel *editModel;
@property (nonatomic ,strong) NSString *imageCount;

@end
