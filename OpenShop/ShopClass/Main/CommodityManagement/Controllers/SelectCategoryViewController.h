//
//  SelectCategoryViewController.h
//  OpenShop
//
//  Created by yuemin3 on 2017/3/24.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)(NSString *roomName);

@interface SelectCategoryViewController : UIViewController
@property (nonatomic, copy) SelectedBlock selectedBlock;
- (void)returnRoomName:(SelectedBlock)block;
@end
