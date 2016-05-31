//
//  IndustryModel.m
//  日常
//
//  Created by 余笃 on 16/1/26.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "IndustryModel.h"

@implementation IndustryModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super initWithDictionary:dict]) {
        self.indId                      = [dict objectForKey:@"ind_id"];
        self.indName                    = [dict objectForKey:@"ind_name"];
    }
    return self;
}

@end

@implementation IndustryList

-(instancetype)initWithArray:(NSArray *)array{
    if (self = [super init]) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in array) {
            IndustryModel *model = [[IndustryModel alloc] initWithDictionary:dict];
            [list addObject:model];
        }
        self.list = list;
    }
    return self;
}


@end