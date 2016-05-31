//
//  RemindManager.m
//  rc
//
//  Created by 余笃 on 16/4/8.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RemindManager.h"

@implementation RemindManager

-(void)scheduleLocalNotificationWithDate:(NSDate *)date Title:(NSString *)title notiID:(NSString *)notiID{
    //初始化本地通知
    UILocalNotification *localNotification = [[UILocalNotification alloc]init];
    
    // 通知触发时间
    localNotification.fireDate = date;
    // 触发后，弹出警告框中显示的内容
    localNotification.alertBody = title;
    // 触发时的声音（这里选择的系统默认声音）
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    // 触发频率（repeatInterval是一个枚举值，可以选择每分、每小时、每天、每年等）
    localNotification.repeatInterval = NSCalendarUnitDay;
    // 需要在App icon上显示的未读通知数（设置为1时，多个通知未读，系统会自动加1，如果不需要显示未读数，这里可以设置0）
    localNotification.applicationIconBadgeNumber = 1;
    // 设置通知的id，可用于通知移除，也可以传递其他值，当通知触发时可以获取
    localNotification.userInfo = @{@"id" : notiID};
    
    // 注册本地通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

-(void)removeLocalNotificationWithNotificationId:(NSString *)notificationId{
    // 取出全部本地通知
    NSArray *notifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    // 遍历进行移除
    for (UILocalNotification *localNotification in notifications) {
        
        // 将每个通知的id取出来进行对比
        if ([[localNotification.userInfo objectForKey:@"id"] isEqualToString:notificationId]) {
            
            // 移除某一个通知
            [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
        }
    }
}

- (NSDate *)dateFromString:(NSString *)string
{
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:string];
    return date;
}

@end
