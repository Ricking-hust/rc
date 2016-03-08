//
//  planModel.m
//  日常
//
//  Created by 余笃 on 16/1/26.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "PlanModel.h"
#import "NSDictionary+NotNullKey.h"

@implementation PlanModel

-(instancetype) initWithDictionary:(NSDictionary *)dict{
    if (self = [super initWithDictionary:dict]) {
        self.planId                         = [dict objectForSafeKey:@"pl_id"];
        self.planContent                    = [dict objectForSafeKey:@"pl_content"];
        self.planTime                      = [dict objectForSafeKey:@"pl_time"];
        self.plAlarmOne                     = [dict objectForSafeKey:@"pl_alarm_one"];
        self.plAlarmTwo                     = [dict objectForSafeKey:@"pl_alarm_two"];
        self.plAlarmThree                   = [dict objectForSafeKey:@"pl_alarm_three"];
        self.userId                         = [dict objectForSafeKey:@"usr_id"];
        self.acId                           = [dict objectForSafeKey:@"ac_id"];
        self.themeName                      = [dict objectForSafeKey:@"theme_name"];
        self.acPlace                        = [dict objectForSafeKey:@"ac_place"];
    }
    return self;
}

@end

@implementation PlanList

-(instancetype) initWithArray:(NSArray *)array{
    if (self = [super init]) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in array) {
            PlanModel *model = [[PlanModel alloc] initWithDictionary:dict];
            [list addObject:model];
        }
        self.list = list;
    }
    return self;
}

@end