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
@property (nonatomic, assign) CGFloat height;       //cell的高度
@property (nonatomic, assign) CGSize tittleSize;    //tittle的大小
@property (nonatomic, assign) CGSize timeSize;      //timeSize的大小
@property (nonatomic, assign) CGSize desSize;       //desSize的大小
@property (nonatomic, assign) CGSize placeSize;     //placeSize的大小
- (id)initWithModel:(RCAblumActivityModel *)model;
@end
