//
//  CityModel.m
//  日常
//
//  Created by 余笃 on 16/1/25.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super initWithDictionary:dict]) {
        self.cityID                     = [dict objectForKey:@"ct_id"];
        self.cityName                   = [dict objectForKey:@"ct_name"];
    }
    return self;
}

@end

@implementation CityList

-(instancetype)initWithArray:(NSArray *)array{
    if (self = [super init]) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in array) {
            CityModel *model = [[CityModel alloc] initWithDictionary:dict];
            [list addObject:model];
        }
        self.list = list;
    }
    return self;
}

@end