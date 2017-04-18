//
//  HotSearchTableViewCell.h
//  本色堂
//
//  Created by 广州玉贝网络科技有限公司 on 16/4/12.
//  Copyright © 2016年 广州天弈歌贸易有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^BYDBlock)(void);
typedef void(^Myblock) (NSInteger index);
@interface HotSearchTableViewCell : UITableViewCell

- (void)infortdataArr:(NSMutableArray *)arr;
@property (nonatomic,strong) Myblock block;
@property (nonatomic,strong) BYDBlock DBlock;
@end
