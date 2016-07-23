//
//  RCHotActivityModel.h
//  rc
//
//  Created by AlanZhang on 16/7/23.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCHotActivityModel : NSObject
@property (nonatomic, strong) NSString *ac_id;
@property (nonatomic, strong) NSString *ac_title;
@property (nonatomic, strong) NSString *ac_poster;
@property (nonatomic, strong) NSString *ac_poster_top;
@property (nonatomic, strong) NSString *theme_id;
@property (nonatomic, strong) NSString *ac_time;
@property (nonatomic, strong) NSString *theme_name;
@property (nonatomic, strong) NSString *ac_sustain_time;
@property (nonatomic, strong) NSString *ac_place;
@property (nonatomic, strong) NSString *ac_size;
@property (nonatomic, strong) NSString *ac_pay;
@property (nonatomic, strong) NSString *ac_type;
@property (nonatomic, strong) NSString *ac_review;
@property (nonatomic, strong) NSString *ac_status;
@property (nonatomic, strong) NSString *ac_desc;
@property (nonatomic, strong) NSArray *ac_tags;
@property (nonatomic, strong) NSString *usr_name;
@property (nonatomic, strong) NSString *usr_pic;
@property (nonatomic, strong) NSString *ac_read_num;
@property (nonatomic, strong) NSString *ac_praise_num;
@property (nonatomic, strong) NSString *ac_collect_num;
@end