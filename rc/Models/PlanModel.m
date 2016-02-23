//
//  planModel.m
//  日常
//
//  Created by 余笃 on 16/1/26.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "PlanModel.h"

@implementation planModel

-(instancetype) initWithDictionary:(NSDictionary *)dict{
    if (self = [super initWithDictionary:dict]) {
        self.planId                         = [dict objectForKey:@"pl_id"];
        self.planContent                    = [dict objectForKey:@"pl_content"];
        self.plAlarmOne                     = [dict objectForKey:@"pl_alarm_one"];
        self.plAlarmTwo                     = [dict objectForKey:@"pl_alarm_two"];
        self.plAlarmThree                   = [dict objectForKey:@"pl_alarm_three"];
        
        self.user                           = [[UserModel alloc] initWithDictionary:dict];
        self.activity                       = [[ActivityModel alloc] initWithDictionary:dict];
        self.theme                          = [[ThemeModel alloc] initWithDictionary:dict];
    }
    return self;
}

@end

@implementation planList

-(instancetype) initWithArray:(NSArray *)array{
    if (self = [super init]) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in array) {
            planModel *model = [[planModel alloc] initWithDictionary:dict];
            [list addObject:model];
        }
        self.list = list;
    }
    return self;
}

@end