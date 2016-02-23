//
//  TagModel.m
//  日常
//
//  Created by 余笃 on 16/1/28.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "TagModel.h"

@implementation TagModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super initWithDictionary:dict]) {
        
        self.tagId          = [dict objectForKey:@"tag_id"];
        self.tagName        = [dict objectForKey:@"tag_name"];
    }
    return self;
}

@end

@implementation TagsList

-(instancetype)initWithArray:(NSArray *)array{
    if (self = [super init]) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dict in array) {
            TagModel *model = [[TagModel alloc] initWithDictionary:dict];
            [list addObject:model];
        }
        self.list = list;
    }
    return self;
}

@end