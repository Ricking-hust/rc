//
//  ActivityModel.m
//  日常
//
//  Created by 余笃 on 15/12/26.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super initWithDictionary:dict]) {
        self.acID               = [dict objectForKey:@"ac_id"];
        self.acPoster           = [dict objectForKey:@"ac_poster"];
        self.acPosterTop        = [dict objectForKey:@"ac_poster_top"];
        self.acTitle            = [dict objectForKey:@"ac_title"];
        self.acTime             = [dict objectForKey:@"ac_time"];
        self.acTheme            = [dict objectForKey:@"ac_theme"];
        self.acPlace            = [dict objectForKey:@"ac_place"];
        self.acCollectNum       = [dict objectForKey:@"ac_collect_num"];
        self.acSize             = [dict objectForKey:@"ac_size"];
        self.acPay              = [dict objectForKey:@"ac_pay"];
        self.acDesc             = [dict objectForKey:@"ac_desc"];
        self.acPraiseNum        = [dict objectForKey:@"ac_praise_num"];
        self.acReadNum          = [dict objectForKey:@"ac_read_num"];
        self.acHtml             = [dict objectForKey:@"ac_html"];
        self.acCollect          = [dict objectForKey:@"ac_collect"];
        self.plan               = [dict objectForKey:@"plan"];
        
        NSMutableArray *tagList = [[NSMutableArray alloc] initWithArray:[dict objectForKey:@"ac_tags"]];
        self.tagsList            = [[TagsList alloc] initWithArray:tagList];
    }
    return self;
}

@end


@implementation ActivityList

-(instancetype)initWithArray:(NSArray *)array{
    if (self = [super init]) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in array) {
            ActivityModel *model = [[ActivityModel alloc] initWithDictionary:dict];
            [list addObject:model];
        }
        
        self.list = list;
    }
    return self;
}

@end
