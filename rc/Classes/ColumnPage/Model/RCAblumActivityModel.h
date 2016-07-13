//
//  RCAblumActivityModel.h
//  rc
//
//  Created by LittleMian on 16/7/13.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCAblumActivityModel : NSObject
@property (nonatomic, strong) NSString *ac_id;      //活动ID
@property (nonatomic, strong) NSString *ac_img;     //活动图片URL
@property (nonatomic, strong) NSString *ac_title;   //活动标题
@property (nonatomic, strong) NSString *ac_time;    //活动开始时间
@property (nonatomic, strong) NSString *ac_place;   //活动地点
@property (nonatomic, strong) NSString *ac_des;     //主讲人简介
@end
