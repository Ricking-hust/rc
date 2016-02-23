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
        self.userId     = [dict objectForKey:@"usr_id"];
        self.userName   = [dict objectForKey:@"usr_name"];
        self.userPhone  = [dict objectForKey:@"usr_phone"];
        self.userPic    = [dict objectForKey:@"usr_pic"];
        self.userSex    = [dict objectForKey:@"usr_sex"];
        self.userSign   = [dict objectForKey:@"usr_sign"];
        self.userMail   = [dict objectForKey:@"usr_mail"];
    }
    return self;
}

@end
