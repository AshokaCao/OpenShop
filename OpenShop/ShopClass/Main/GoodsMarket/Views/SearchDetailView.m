//
//  SearchDetailView.m
//  OpenShop
//
//  Created by yuemin3 on 2017/3/28.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "SearchDetailView.h"

@implementation SearchDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                      owner:self
                                    options:nil];
//        self.view.frame = frame;
//        [self setupViews];
//        [self addSubview:self.view];
    }
    return self;
}
- (IBAction)cancelAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(searchButtonWasPressedForSearchView:)]) {
        [self.delegate searchButtonWasPressedForSearchView:self];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
