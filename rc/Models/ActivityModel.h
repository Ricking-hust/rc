//
//  ActivityModel.h
//  日常
//
//  Created by 余笃 on 15/12/26.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface ActivityModel : BaseModel

@property (nonatomic,copy) NSString *acID;
@property (nonatomic,copy) NSString *acPoster;
@property (nonatomic,copy) NSString *acPosterTop;
@property (nonatomic,copy) NSString *acTitle;
@property (nonatomic,copy) NSString *acTime;
@property (nonatomic,copy) NSString *acPlace;
@property (nonatomic,copy) NSString *acTags;
@property (nonatomic,copy) NSString *acCollectNum;
@property (nonatomic,copy) NSString *acPraiseNum;

@end

/*
 ac_id  活动的id
 ac_poster  活动海报的url
 ac_poster_top 活动在首页幻灯片的图片
 ac_title  活动标题
 ac_time 活动开始时间，数据库里的值精确到时分秒，这里只需返回年月日
 ac_place  活动地点
 ac_tags  活动具有的标签数组
 ac_collect_num 活动收藏人数
 ac_praise_num 活动点赞人数
*/