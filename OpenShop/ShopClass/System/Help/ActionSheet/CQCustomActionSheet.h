//
//  CQCustomActionSheet.h
//  LuckyBuy
//
//  Created by yuemin3 on 16/8/12.
//  Copyright © 2016年 yuemin3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQActionSheetButton.h"

@protocol CQCustomActionSheetDelegate <NSObject>

- (void) customActionSheetButtonClick:(CQActionSheetButton *) btn;

@end

@interface CQCustomActionSheet : UIView 
/**展示*/
- (void)showInView:(UIView *)superView contentArray:(NSArray *)contentArray;

@property (nonatomic, weak) id<CQCustomActionSheetDelegate> delegate;

@end
