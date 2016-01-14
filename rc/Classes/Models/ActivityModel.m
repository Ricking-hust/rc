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
        self.acPlace            = [dict objectForKey:@"ac_place"];
        self.acTags             = [dict objectForKey:@"ac_tags"];
        self.acCollectNum       = [dict objectForKey:@"ac_collect_num"];
        self.acPraiseNum        = [dict objectForKey:@"ac_praise_num"];
    }
    return self;
}

@end
