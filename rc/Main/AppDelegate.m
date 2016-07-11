//
//  AppDelegate.m
//  日常
//
//  Created by AlanZhang on 15/12/17.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import "AppDelegate.h"
#import "RemindManager.h"
#import "RCNetworkingRequestOperationManager.h"
//＝＝＝＝＝＝＝＝＝＝ShareSDK头文件V3.3＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

#import "RCScheduleViewController.h"
#import "LoginViewController.h"
//================融云SDK头文件=======================
#import <RongIMKit/RongIMKit.h>

@interface AppDelegate ()<RCIMUserInfoDataSource>

@end

@implementation AppDelegate


- (void)initShareSDK
{
    //v3.3
    [ShareSDK registerApp:@"10c6f1c7e6778" activePlatforms:@[
                                                             //@(SSDKPlatformTypeSinaWeibo),
                                                             @(SSDKPlatformTypeWechat),
                                                             @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:@"2386672952"
                                                appSecret:@"9097df09bd441ac7824d67aaaff2d420"
                                              redirectUri:@"http://wwww.myrichang.com"
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wx121f7d44b47dc773"
                                            appSecret:@"e07e40dac0996340421e5d727e505754"];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"1105314728"
                                           appKey:@"BTJicvrNeJiYng6U"
                                         authType:SSDKAuthTypeBoth];
                      break;

                  default:
                      break;
              }
         }];

    
    
}

//本地通知回调函数，当应用程序在前台时调用
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification*)notification
{
    //实现本地通知的触发处理
    //NSLog(@"%@",notification.userInfo);
    //[self showAlertView:@"此处应跳转到行程界面"];
    
    RCScheduleViewController *scheduleViewController = [[RCScheduleViewController alloc]init];
    [self.window.rootViewController showDetailViewController:scheduleViewController sender:nil];
    RemindManager *remanager = [[RemindManager alloc]init];
    [remanager removeLocalNotificationWithNotificationId:[notification.userInfo objectForKey:@"id"]];
}

//在非本App界面时收到本地消息
//-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler{
//    
//}

- (void)showAlertView:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [self.window.rootViewController showDetailViewController:alert sender:nil];
}
#pragma mark - 设置聊天界面用户的头像和昵称
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    
    NSString *URLString = @"http://appv2.myrichang.com/home/Person/getPersonInfo";
    NSDictionary *fansParam = [[NSDictionary alloc]initWithObjectsAndKeys:userId,@"usr_id", nil];
    //显示粉丝数
    [RCNetworkingRequestOperationManager request:URLString requestType:POST parameters:fansParam completeBlock:^(NSData *data) {
        id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSArray *userInfo = [dict valueForKey:@"data"];
        NSString *usr_name = [userInfo valueForKey:@"usr_name"];
        NSString *usr_pic = [userInfo valueForKey:@"usr_pic"];
        RCUserInfo *info = [[RCUserInfo alloc]initWithUserId:userId name:usr_name portrait:usr_pic];
        completion(info);
    } errorBlock:^(NSError *error) {
        NSLog(@"网络请求错误:%@",error);
    }];
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[RCIM sharedRCIM] initWithAppKey:@"25wehl3uwn16w"];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setEnableTypingStatus:YES];
    if ([DataManager manager].user.isLogin == YES && ![[userDefaults valueForKey:@"token"] isEqualToString:@""])//如果用户已登录则连接融云服务器,且token不为空
    {
        NSString *token = [userDefaults valueForKey:@"token"];
        static dispatch_once_t launchedPred;
        dispatch_once(&launchedPred, ^{
            
            [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
                NSLog(@"app加载完成，登录融云成功。当前登录的用户ID：%@", userId);
            } error:^(RCConnectErrorCode status) {
                
            } tokenIncorrect:^{
                
            }];
        });
    }
    [self initShareSDK];
    //设置消息通知
    //[self settingNotification];
    
    //远程推送
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    return YES;
}
/**
 *  获取苹果服务器返回的deviceToken
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *string = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    //NSLog(@"deviceTokenString--------------》 : %@",string);
    //NSLog(@"deviceToken ------->: %@",deviceToken);
    
}
// 注册失败回调方法，处理失败情况
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //NSLog(@"远程推送注册失败：%@",error);
    
}
/**
 *  ios8之前，接收到推送消息的代理方法
 */
- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //NSLog(@"%@",userInfo);
}
/**
 *  ios8之后，接收消息的代理方法
 *  接收到推送消息后，需要判断当前程序所处的状态， 并根据公司业务做出不同处理
 *  在处理完成后，需要调用completionHandler block 回调
 *
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    if (application.applicationState == UIApplicationStateInactive)
    {
        //NSLog(@"inactive");
        completionHandler(UIBackgroundFetchResultNewData);
    }else if (application.applicationState == UIApplicationStateBackground)
    {
        //NSLog(@"background");
        completionHandler(UIBackgroundFetchResultNewData);
    }else if (application.applicationState == UIApplicationStateActive)
    {
        //NSLog(@"active");
        completionHandler(UIBackgroundFetchResultNewData);
    }
   // NSLog(@"%@",userInfo);
}
- (void)settingNotification
{

    if ([[UIApplication sharedApplication]currentUserNotificationSettings].types != UIUserNotificationTypeNone) {
        
        //[self addLocalNotification];
    }else{
        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil]];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];//进入前台取消应用消息图标
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
