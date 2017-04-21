//
//  MessageModel.h
//  OpenShop
//
//  Created by yuemin3 on 2017/4/20.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
@property (nonatomic ,strong) NSString *system;
@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,strong) NSString *content;
@property (nonatomic ,strong) NSString *time;

@end
