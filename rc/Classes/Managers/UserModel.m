//
//  UserModel.m
//  日常
//
//  Created by 余笃 on 15/12/22.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super initWithDictionary:dict]) {
        self.userId     = [dict objectForKey:@"user_id"];
        self.userName   = [dict objectForKey:@"user_name"];
        self.userPhone  = [dict objectForKey:@"user_phone"];
        self.userPic    = [dict objectForKey:@"user_pic"];
        self.userSex    = [dict objectForKey:@"user_sex"];
        self.userSign   = [dict objectForKey:@"user_sign"];
        self.userMail   = [dict objectForKey:@"user_mail"];
    }
    return self;
}

@end
