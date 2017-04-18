//
//  SearchViewController.h
//  OpenShop
//
//  Created by yuemin3 on 2017/3/28.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketListModel.h"

@interface SearchViewController : UIViewController
@property (nonatomic ,strong) MarketListModel *searchModel;
@property (nonatomic ,strong) NSString *searchStr;

@end
