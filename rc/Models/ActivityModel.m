//
//  ActivityModel.m
//  日常
//
//  Created by 余笃 on 15/12/26.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import "ActivityModel.h"
#import "NSDictionary+NotNullKey.h"

@implementation ActivityModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super initWithDictionary:dict]) {
        self.acID               = [dict objectForSafeKey:@"ac_id"];
        self.userInfo           = [[UserModel alloc] init];
        self.userInfo.userId    = [dict objectForSafeKey:@"usr_id"];
        self.userInfo.userPic   = [dict objectForSafeKey:@"usr_pic"];
        self.userInfo.userName  = [dict objectForSafeKey:@"usr_name"];
        self.acPoster           = [dict objectForSafeKey:@"ac_poster"];
        self.acPosterTop        = [dict objectForSafeKey:@"ac_poster_top"];
        self.acTitle            = [dict objectForSafeKey:@"ac_title"];
        self.acTime             = [dict objectForSafeKey:@"ac_time"];
        self.acTheme            = [dict objectForSafeKey:@"ac_theme"];
        self.acPlace            = [dict objectForSafeKey:@"ac_place"];
        self.acCollectNum       = [dict objectForSafeKey:@"ac_collect_num"];
        self.acSize             = [dict objectForSafeKey:@"ac_size"];
        self.acPay              = [dict objectForSafeKey:@"ac_pay"];
        self.acDesc             = [dict objectForSafeKey:@"ac_desc"];
        self.acPraiseNum        = [dict objectForSafeKey:@"ac_praise_num"];
        self.acReview           = [dict objectForSafeKey:@"ac_review"];
        self.acStatus           = [dict objectForSafeKey:@"ac_status"];
        self.acReadNum          = [dict objectForSafeKey:@"ac_read_num"];
        self.acHtml             = [dict objectForSafeKey:@"ac_html"];
        self.acCollect          = [dict objectForSafeKey:@"ac_collect"];
        self.plan               = [dict objectForSafeKey:@"plan"];
        if ([[dict objectForSafeKey:@"pl_id"] isKindOfClass:[NSString class]]) {
            self.planId             = [dict objectForSafeKey:@"pl_id"];
        }else {
            self.planId = @"";
        }
        if ([[dict objectForSafeKey:@"ac_tags"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *tagList = [[NSMutableArray alloc] initWithArray:[dict objectForSafeKey:@"ac_tags"]];
            self.tagsList            = [[TagsList alloc] initWithArray:tagList];
        }else{
            NSLog(@"活动标签为空");
        }
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
