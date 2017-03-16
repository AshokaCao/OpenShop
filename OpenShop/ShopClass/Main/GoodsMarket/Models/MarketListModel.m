//
//  MarketListModel.m
//  OpenShop
//
//  Created by yuemin3 on 2017/3/15.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "MarketListModel.h"

@implementation MarketListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.idGood = value;
    }
}

@end
