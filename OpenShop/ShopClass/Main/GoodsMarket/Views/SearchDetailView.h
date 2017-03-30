//
//  SearchDetailView.h
//  OpenShop
//
//  Created by yuemin3 on 2017/3/28.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchDetailView;
@protocol SearchViewDelegate <NSObject>

- (void)searchButtonWasPressedForSearchView:(SearchDetailView *)searchView;

@end
@interface SearchDetailView : UIView
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) id<SearchViewDelegate> delegate;

@end
