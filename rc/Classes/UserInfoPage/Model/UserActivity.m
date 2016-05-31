//
//  UserActivity.m
//  rc
//
//  Created by AlanZhang on 16/5/21.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "UserActivity.h"

@implementation UserActivity
- (id)init
{
    if (self = [super init])
    {
        self.code = @"";
        self.msg = @"";
        self.ac_title = @"";
        self.ac_id = @"";
        self.ac_poster = @"";
        self.ac_poster_top = @"";
        self.ac_desc = @"";
        self.theme_name = @"";
        self.ac_time = @"";
        self.ac_sustain_time = @"";
        self.ac_place = @"";
        self.ac_size = @"";
        self.ac_pay = @"";
        self.usr_id = @"";
        self.ac_type = @"";
        self.usr_pic = @"";
        self.usr_name = @"";
        self.ac_tags = [[NSMutableArray alloc]init];
    }
    return self;
}
@end
