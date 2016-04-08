//
//  RemindManager.h
//  rc
//
//  Created by 余笃 on 16/4/8.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemindManager : NSObject

-(void)scheduleLocalNotificationWithDate:(NSDate *)date Title:(NSString *)title notiID:(NSString *)notiID;

-(void)removeLocalNotificationWithNotificationId:(NSString *)notificationId;

- (NSDate *)dateFromString:(NSString *)string;

@end
