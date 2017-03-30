//
//  PictureShowCollectionViewCell.h
//  OpenShop
//
//  Created by yuemin3 on 2017/3/30.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PictureShowCollectionViewCellDelegate <NSObject>

- (void)cellDidDeleteClcik:(UICollectionViewCell *)cell;

@end

@interface PictureShowCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<PictureShowCollectionViewCellDelegate> delegate;
@property (weak, nonatomic, readonly) UIImageView *imageView;

@end
