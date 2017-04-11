//
//  AppDelegate.m
//  OpenShop
//
//  Created by yuemin3 on 2017/1/3.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "LoginHomeViewController.h"
/* 分享*/
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <FBSDKMessengerShareKit/FBSDKMessengerSharer.h>

/* 语言切换 **/
static NSString *appLanguage = @"appLanguage";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
//    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:rootVC];
    NSString *userID = [nNsuserdefaul objectForKey:@"userID"];
    if (userID) {
        RootViewController *rootVC = [[RootViewController alloc] init];
        self.window.rootViewController = rootVC;
    } else {
        LoginHomeViewController *logVC = [[LoginHomeViewController alloc] init];
        self.window.rootViewController = logVC;
    }
    
    // 多语言切换
    if (![nNsuserdefaul objectForKey:appLanguage]) {
        NSArray  *languages = [NSLocale preferredLanguages];
        NSString *language = [languages objectAtIndex:0];
        if ([language hasPrefix:@"zh-Hans"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:appLanguage];
        } else if ([language hasPrefix:@"th"] ) {
            [[NSUserDefaults standardUserDefaults] setObject:@"th" forKey:appLanguage];
        } else if ([language hasPrefix:@"en"]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:appLanguage];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"th" forKey:appLanguage];
        }
    }
    
    
    [self.window makeKeyAndVisible];
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    // 注册 APNs
    [self registerRemoteNotification];
    
    return YES;
}

#pragma mark  Share
//- (void)shareOut
//{
//    [ShareSDK registerApp:@"iosv1101"
//          activePlatforms:@[
//                            @(SSDKPlatformTypeCopy),
//                            @(SSDKPlatformTypeFacebook),
//                            @(SSDKPlatformTypeTwitter),
//                            @(SSDKPlatformTypeInstagram),
//                            @(SSDKPlatformTypeLine),
//                            @(SSDKPlatformTypeFacebookMessenger),
//                            ]
//                 onImport:^(SSDKPlatformType platformType) {
//                     
//                     switch (platformType)
//                     {
//                         case SSDKPlatformTypeFacebookMessenger:
//                             [ShareSDKConnector connectFacebookMessenger:[FBSDKMessengerSharer class]];
//                             break;
//                         default:
//                             break;
//                     }
//                 }
//          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
//              
//              switch (platformType)
//              {
//                  case SSDKPlatformTypeFacebook:
//                      //设置Facebook应用信息，其中authType设置为只用SSO形式授权
//                      [appInfo SSDKSetupFacebookByApiKey:@"107704292745179"
//                                               appSecret:@"38053202e1a5fe26c80c753071f0b573"
//                                             displayName:@"shareSDK"
//                                                authType:SSDKAuthTypeBoth];
//                      break;
//                  case SSDKPlatformTypeTwitter:
//                      [appInfo SSDKSetupTwitterByConsumerKey:@"LRBM0H75rWrU9gNHvlEAA2aOy"
//                                              consumerSecret:@"gbeWsZvA9ELJSdoBzJ5oLKX0TU09UOwrzdGfo9Tg7DjyGuMe8G"
//                                                 redirectUri:@"http://mob.com"];
//                      break;
//                  case SSDKPlatformTypeWechat:
//                      [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
//                                            appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
//                      break;
//                  case SSDKPlatformTypeQQ:
//                      [appInfo SSDKSetupQQByAppId:@"100371282"
//                                           appKey:@"aed9b0303e3ed1e27bae87c33761161d"
//                                         authType:SSDKAuthTypeBoth];
//                      break;
//                  case SSDKPlatformTypeDouBan:
//                      [appInfo SSDKSetupDouBanByApiKey:@"02e2cbe5ca06de5908a863b15e149b0b"
//                                                secret:@"9f1e7b4f71304f2f"
//                                           redirectUri:@"http://www.sharesdk.cn"];
//                      break;
//                  case SSDKPlatformTypeRenren:
//                      [appInfo SSDKSetupRenRenByAppId:@"226427"
//                                               appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
//                                            secretKey:@"f29df781abdd4f49beca5a2194676ca4"
//                                             authType:SSDKAuthTypeBoth];
//                      break;
//                  case SSDKPlatformTypeKaixin:
//                      [appInfo SSDKSetupKaiXinByApiKey:@"358443394194887cee81ff5890870c7c"
//                                             secretKey:@"da32179d859c016169f66d90b6db2a23"
//                                           redirectUri:@"http://www.sharesdk.cn/"];
//                      break;
//                  case SSDKPlatformTypeGooglePlus:
//                      
//                      [appInfo SSDKSetupGooglePlusByClientID:@"232554794995.apps.googleusercontent.com"
//                                                clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
//                                                 redirectUri:@"http://localhost"];
//                      break;
//                  case SSDKPlatformTypePocket:
//                      [appInfo SSDKSetupPocketByConsumerKey:@"11496-de7c8c5eb25b2c9fcdc2b627"
//                                                redirectUri:@"pocketapp1234"
//                                                   authType:SSDKAuthTypeBoth];
//                      break;
//                  case SSDKPlatformTypeInstagram:
//                      [appInfo SSDKSetupInstagramByClientID:@"ff68e3216b4f4f989121aa1c2962d058"
//                                               clientSecret:@"1b2e82f110264869b3505c3fe34e31a1"
//                                                redirectUri:@"http://sharesdk.cn"];
//                      break;
//                  case SSDKPlatformTypeLinkedIn:
//                      [appInfo SSDKSetupLinkedInByApiKey:@"ejo5ibkye3vo"
//                                               secretKey:@"cC7B2jpxITqPLZ5M"
//                                             redirectUrl:@"http://sharesdk.cn"];
//                      break;
//                  case SSDKPlatformTypeTumblr:
//                      [appInfo SSDKSetupTumblrByConsumerKey:@"2QUXqO9fcgGdtGG1FcvML6ZunIQzAEL8xY6hIaxdJnDti2DYwM"
//                                             consumerSecret:@"3Rt0sPFj7u2g39mEVB3IBpOzKnM3JnTtxX2bao2JKk4VV1gtNo"
//                                                callbackUrl:@"http://sharesdk.cn"];
//                      break;
//                  case SSDKPlatformTypeFlickr:
//                      [appInfo SSDKSetupFlickrByApiKey:@"33d833ee6b6fca49943363282dd313dd"
//                                             apiSecret:@"3a2c5b42a8fbb8bb"];
//                      break;
//                  case SSDKPlatformTypeYouDaoNote:
//                      [appInfo SSDKSetupYouDaoNoteByConsumerKey:@"dcde25dca105bcc36884ed4534dab940"
//                                                 consumerSecret:@"d98217b4020e7f1874263795f44838fe"
//                                                  oauthCallback:@"http://www.sharesdk.cn/"];
//                      break;
//                      
//                      //印象笔记分为国内版和国际版，注意区分平台
//                      //设置印象笔记（中国版）应用信息
//                  case SSDKPlatformTypeYinXiang:
//                      
//                      //设置印象笔记（国际版）应用信息
//                  case SSDKPlatformTypeEvernote:
//                      [appInfo SSDKSetupEvernoteByConsumerKey:@"sharesdk-7807"
//                                               consumerSecret:@"d05bf86993836004"
//                                                      sandbox:YES];
//                      break;
//                  case SSDKPlatformTypeKakao:
//                      [appInfo SSDKSetupKaKaoByAppKey:@"48d3f524e4a636b08d81b3ceb50f1003"
//                                           restApiKey:@"ac360fa50b5002637590d24108e6cb10"
//                                          redirectUri:@"http://www.mob.com/oauth"
//                                             authType:SSDKAuthTypeBoth];
//                      break;
//                  case SSDKPlatformTypeAliPaySocial:
//                      [appInfo SSDKSetupAliPaySocialByAppId:@"2015072400185895"];
//                      break;
//                  case SSDKPlatformTypePinterest:
//                      [appInfo SSDKSetupPinterestByClientId:@"4797078908495202393"];
//                      break;
//                  case SSDKPlatformTypeDropbox:
//                      [appInfo SSDKSetupDropboxByAppKey:@"i5vw2mex1zcgjcj"
//                                              appSecret:@"3i9xifsgb4omr0s"
//                                          oauthCallback:@"https://www.sharesdk.cn"];
//                      break;
//                  case SSDKPlatformTypeVKontakte:
//                      [appInfo SSDKSetupVKontakteByApplicationId:@"5312801"
//                                                       secretKey:@"ZHG2wGymmNUCRLG2r6CY"];
//                      break;
//                  case SSDKPlatformTypeMingDao:
//                      [appInfo SSDKSetupMingDaoByAppKey:@"EEEE9578D1D431D3215D8C21BF5357E3"
//                                              appSecret:@"5EDE59F37B3EFA8F65EEFB9976A4E933"
//                                            redirectUri:@"http://sharesdk.cn"];
//                      break;
//                  case SSDKPlatformTypeYiXin:
//                      [appInfo SSDKSetupYiXinByAppId:@"yx0d9a9f9088ea44d78680f3274da1765f"
//                                           appSecret:@"1a5bd421ae089c3"
//                                         redirectUri:@"https://open.yixin.im/resource/oauth2_callback.html"
//                                            authType:SSDKAuthTypeBoth];
//                      break;
//                  case SSDKPlatformTypeInstapaper:
//                      [appInfo SSDKSetupInstapaperByConsumerKey:@"4rDJORmcOcSAZL1YpqGHRI605xUvrLbOhkJ07yO0wWrYrc61FA"
//                                                 consumerSecret:@"GNr1GespOQbrm8nvd7rlUsyRQsIo3boIbMguAl9gfpdL0aKZWe"];
//                      break;
//                  case SSDKPlatformTypeDingTalk:
//                      [appInfo SSDKSetupDingTalkByAppId:@"dingoanxyrpiscaovl4qlw"];
//                      break;
//                      
//                  case SSDKPlatformTypeMeiPai:
//                      [appInfo SSDKSetupMeiPaiByAppKey:@"1089867596"];//4294967196
//                      break;
//                  case SSDKPlatformTypeYouTube:
//                      [appInfo SSDKSetupYouTubeByClientId:@"906418427202-jinnbqal1niq4s8isbg2ofsqc5ddkcgr.apps.googleusercontent.com"
//                                             clientSecret:@""
//                                              redirectUri:@"http://localhost"];
//                      break;
//                      //                      v3.6.2 新增
//                      //                      需要在 info.plist 增加 ChannelID 设置
//                      //                      <key>LineSDKConfig</key>
//                      //                      <dict>
//                      //                      <key>ChannelID</key>
//                      //                      <string>1502330683</string>
//                      //                      </dict>
//                  case SSDKPlatformTypeLine:
//                      [appInfo SSDKSetupLineAuthType:SSDKAuthTypeBoth];
//                      break;
//                  default:
//                      break;
//              }
//          }];
//}

#pragma mark   注册APNs
/** 注册 APNs */
- (void)registerRemoteNotification {
    /*
     警告：Xcode8 需要手动开启"TARGETS -> Capabilities -> Push Notifications"
     */
    
    /*
     警告：该方法需要开发者自定义，以下代码根据 APP 支持的 iOS 系统不同，代码可以对应修改。
     以下为演示代码，注意根据实际需要修改，注意测试支持的 iOS 系统都能获取到 DeviceToken
     */
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
//        UIRemoteNotificationType apn_type = (UIRemoteNotificationType)(UIRemoteNotificationTypeAlert |
//                                                                       UIRemoteNotificationTypeSound |
//                                                                       UIRemoteNotificationTypeBadge);
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:apn_type];
    }
}

/** 远程通知注册成功委托 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    
    // 向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // 将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    NSLog(@"\n>>>[Receive RemoteNotification - Background Fetch]:%@\n\n",userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

//  iOS 10: App在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
    NSLog(@"willPresentNotification：%@", notification.request.content.userInfo);
    
    // 根据APP需要，判断是否要提示用户Badge、Sound、Alert
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    
    // [ GTSdk ]：将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    
    completionHandler();
}

#endif

/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    //个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}

#pragma mark 透传消息回调
/** SDK收到透传消息回调 */
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    // [ GTSdk ]：汇报个推自定义事件(反馈透传消息)
    [GeTuiSdk sendFeedbackMessage:90001 andTaskId:taskId andMsgId:msgId];
    
    // 数据转换
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
    // 控制台打印日志
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@", taskId, msgId, payloadMsg, offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>[GTSdk ReceivePayload]:%@\n\n", msg);
}

/** SDK收到sendMessage消息回调 */
- (void)GeTuiSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // 发送上行消息结果反馈
    NSString *msg = [NSString stringWithFormat:@"sendmessage=%@,result=%d", messageId, result];
    NSLog(@"\n>>[GTSdk DidSendMessage]:%@\n\n", msg);
}

/** SDK运行状态通知 */
- (void)GeTuiSDkDidNotifySdkState:(SdkStatus)aStatus {
    // 通知SDK运行状态
    NSLog(@"\n>>[GTSdk SdkState]:%u\n\n", aStatus);
}

/** SDK设置推送模式回调 */
- (void)GeTuiSdkDidSetPushMode:(BOOL)isModeOff error:(NSError *)error {
    if (error) {
        NSLog(@"\n>>[GTSdk SetModeOff Error]:%@\n\n", [error localizedDescription]);
        return;
    }
    
    NSLog(@"\n>>[GTSdk SetModeOff]:%@\n\n", isModeOff ? @"开启" : @"关闭");
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
