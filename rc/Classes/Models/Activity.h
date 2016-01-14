//
//  Activity.h
//  日常
//
//  Created by AlanZhang on 16/1/8.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Activity : NSObject

@property(nonatomic, assign) int ac_id; //活动id
@property(nonatomic, copy) NSString *ac_poster; //活动海报 -> ?
@property(nonatomic, copy) NSString *ac_title;  //活动标题
@property(nonatomic, copy) NSString *ac_time;   //活动时间
@property(nonatomic, copy) NSString *ac_place;  //活动地点
@property(nonatomic, copy) NSString *ac_tags;   //活动标签
@property(nonatomic, assign) int ac_collect_num;    //活动收藏人数
@property(nonatomic, assign) int ac_praise_num;     //活动点赞人数
@property(nonatomic, assign) int ac_read_num;       //活动查看人数


/**
 *  类方法,快速创建实例对象
 *
 *  @return 返回实例对象
 */
+ (instancetype) activity;



- (void)setSubViewsContent;

/**
 *  普通函数
 *
 *  @param text 待计算大小的字符串
 *
 *  @param fontSize 指定绘制字符串所用的字体大小
 *
 *  @return 字符串的大小
 */
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize;

@end
