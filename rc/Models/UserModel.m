//
//  UserModel.m
//  日常
//
//  Created by 余笃 on 15/12/22.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import "UserModel.h"
#import "NSDictionary+NotNullKey.h"

@implementation UserModel
-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super initWithDictionary:dict]) {
        self.userId     = [dict objectForSafeKey:@"usr_id"];
        self.userName   = [dict objectForSafeKey:@"usr_name"];
        self.userPhone  = [dict objectForSafeKey:@"usr_phone"];
        self.userPic    = [dict objectForSafeKey:@"usr_pic"];
        self.userSex    = [dict objectForSafeKey:@"usr_sex"];
        self.userSign   = [dict objectForSafeKey:@"usr_sign"];
        self.userMail   = [dict objectForSafeKey:@"usr_mail"];
        
        self.cityId = [dict objectForSafeKey:@"ct_id"];
    }
    return self;
}

@end
