//
//  MarketListModel.h
//  OpenShop
//
//  Created by yuemin3 on 2017/3/15.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MarketListModel : NSObject
/* 商品编号 */
@property (nonatomic ,strong) NSString *goodid;
/* 店铺编号 */
@property (nonatomic ,strong) NSString *shopid;
/* 商品名字 */
@property (nonatomic ,strong) NSString *goodname;
/*  */
@property (nonatomic ,strong) NSString *price;
@property (nonatomic ,strong) NSString *profit;
@property (nonatomic ,strong) NSString *img;
/*  */
@property (nonatomic ,strong) NSString *goodtype;
/*  */
@property (nonatomic ,strong) NSString *introduction;
/*  */
@property (nonatomic ,strong) NSString *state;
/*  */
@property (nonatomic ,strong) NSString *discount;
/*  */
@property (nonatomic ,strong) NSString *idGood;
/* 店铺名字 */
@property (nonatomic ,strong) NSString *shopname;
/*  */
@property (nonatomic ,strong) NSString *auth;
/*  */
@property (nonatomic ,strong) NSString *item;
/* 商店logo */
@property (nonatomic ,strong) NSString *shopimg;
/* 用户ID */
@property (nonatomic ,strong) NSString *userid;
/*  */
@property (nonatomic ,strong) NSString *createtime;
/*  */
@property (nonatomic ,strong) NSString *isreview;
/*  */
@property (nonatomic ,strong) NSString *isdelete;
/* 商品缩略图 */
@property (nonatomic ,strong) NSString *goodimgurl;
/* 是否为代销 */
@property (nonatomic ,assign) BOOL isdistribution;
/* 已经上架*/
@property (nonatomic ,strong) NSString *exist;
/* 是否我添加的商品*/
@property (nonatomic ,strong) NSString *goodfrom;
/* 下架商品的状态*/
@property (nonatomic ,strong) NSString *offsale;

@property (nonatomic ,strong) NSString *line;

@property (nonatomic ,strong) NSString *imgcount;

@property (nonatomic ,strong) NSArray *goodimgs;

@end
