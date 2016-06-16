//
//  PublisherModel.m
//  rc
//
//  Created by 余笃 on 16/6/14.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "PublisherModel.h"
#import "NSDictionary+NotNullKey.h"

@implementation PublisherModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super initWithDictionary:dict]) {
        self.pubId = [dict objectForSafeKey:@"publisher_id"];
        self.pubName = [dict objectForSafeKey:@"publisher_name"];
        self.pubPic = [dict objectForSafeKey:@"publisher_pic"];
        self.pubSign = [dict objectForSafeKey:@"publisher_sign"];
        self.followed = [dict objectForSafeKey:@"follewed"];
    }
    
    return self;
}

@end

@implementation PublisherList

-(instancetype)initWithArray:(NSArray *)array{
    if (self = [super init]) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in array) {
            PublisherModel *model = [[PublisherModel alloc] initWithDictionary:dict];
            [list addObject:model];
        }
        self.list = list;
    }
    return self;
}

@end