//
//  FlashActivityModel.m
//  rc
//
//  Created by 余笃 on 16/3/26.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "FlashActivityModel.h"
#import "NSDictionary+NotNullKey.h"

@implementation FlashActivityModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super initWithDictionary:dict]) {
        self.acID               = [dict objectForSafeKey:@"act_id"];
        self.Image              = [dict objectForSafeKey:@"img"];
        self.acTime             = [dict objectForSafeKey:@"time"];
        self.acTitle            = [dict objectForSafeKey:@"title"];
    }
    return self;
}

@end

@implementation FlashList

-(instancetype)initWithArray:(NSArray *)array{
    if (self = [super init]) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in array) {
            FlashActivityModel *model = [[FlashActivityModel alloc] initWithDictionary:dict];
            [list addObject:model];
        }
        
        self.list = list;
    }
    return self;
}

@end