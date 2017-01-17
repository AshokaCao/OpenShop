//
//  AppDelegate.h
//  OpenShop
//
//  Created by yuemin3 on 2017/1/3.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeTuiSdk.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

/// 个推开发者网站中申请App时，注册的AppId、AppKey、AppSecret
#define kGtAppId           @"Ugt493MfVQ7yddX7Y696V8"
#define kGtAppKey          @"yuFn0fPOkt86m1qfMKlYF5"
#define kGtAppSecret       @"IF7rlPcqyM6xsCX69UZoq1"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GeTuiSdkDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

