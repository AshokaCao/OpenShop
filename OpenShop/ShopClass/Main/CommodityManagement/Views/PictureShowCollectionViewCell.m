//
//  PictureShowCollectionViewCell.m
//  OpenShop
//
//  Created by yuemin3 on 2017/3/30.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "PictureShowCollectionViewCell.h"

@interface PictureShowCollectionViewCell ()

@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UIButton *deleteBtn;
@property (weak, nonatomic) UIView *bottomView;

@end

@implementation PictureShowCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setImage:[UIImage imageNamed:@"compose_delete@2x.png"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(didDeleteClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:deleteBtn];
    self.deleteBtn = deleteBtn;
    
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    bottomView.hidden = YES;
    [self.contentView addSubview:bottomView];
    self.bottomView = bottomView;
}

- (void)didDeleteClick
{
    if ([self.delegate respondsToSelector:@selector(cellDidDeleteClcik:)]) {
        [self.delegate cellDidDeleteClcik:self];
    }
}
/*
- (void)setModel:(HXPhotoModel *)model
{
    _model = model;
    if (model.previewPhoto) {
        self.imageView.image = model.previewPhoto;
    }else {
        self.imageView.image = model.thumbPhoto;
    }
    self.videoTime.text = model.videoTime;
    self.gifIcon.hidden = YES;
    self.liveIcon.hidden = YES;
    if (model.type == HXPhotoModelMediaTypeCamera) {
        self.deleteBtn.hidden = YES;
        self.bottomView.hidden = YES;
    }else {
        self.deleteBtn.hidden = NO;
    }
    
    if ((model.type == HXPhotoModelMediaTypePhoto || model.type == HXPhotoModelMediaTypePhotoGif) || (model.type == HXPhotoModelMediaTypeCameraPhoto || model.type == HXPhotoModelMediaTypeLivePhoto)) {
        if (model.type == HXPhotoModelMediaTypePhotoGif) {
            self.gifIcon.hidden = NO;
        }else if (model.type == HXPhotoModelMediaTypeLivePhoto) {
            self.liveIcon.hidden = NO;
        }
        self.bottomView.hidden = YES;
    }else if (model.type == HXPhotoModelMediaTypeVideo || model.type == HXPhotoModelMediaTypeCameraVideo) {
        self.bottomView.hidden = NO;
    }
}
*/
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat deleteBtnW = self.deleteBtn.currentImage.size.width;
    CGFloat deleteBtnH = self.deleteBtn.currentImage.size.height;
    self.deleteBtn.frame = CGRectMake(width - deleteBtnW, 0, deleteBtnW, deleteBtnH);
    
    self.bottomView.frame = CGRectMake(0, height - 25, width, 25);
    /*
    CGFloat iconWidth = self.videoIcon.image.size.width;
    CGFloat iconHeight = self.videoIcon.image.size.height;
    self.videoIcon.frame = CGRectMake(5, 0, iconWidth, iconHeight);
    self.videoIcon.center = CGPointMake(self.videoIcon.center.x, 25 / 2);
    self.videoTime.frame = CGRectMake(CGRectGetMaxX(self.videoIcon.frame), 0, width - CGRectGetMaxX(self.videoIcon.frame) - 5, 25);
    
    self.gifIcon.frame = CGRectMake(width - self.gifIcon.image.size.width, height - self.gifIcon.image.size.height, self.gifIcon.image.size.width, self.gifIcon.image.size.height);
     */
}


@end
