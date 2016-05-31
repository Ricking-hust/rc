//
//  UserActivity.h
//  rc
//
//  Created by AlanZhang on 16/5/21.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserActivity : NSObject
@property (nonatomic, strong) NSString  *code;
@property (nonatomic, strong) NSString  *msg;
@property (nonatomic, strong) NSString  *ac_id;
@property (nonatomic, strong) NSString  *ac_title;
@property (nonatomic, strong) NSString  *ac_poster;
@property (nonatomic, strong) NSString  *ac_poster_top;
@property (nonatomic, strong) NSString  *ac_desc;
@property (nonatomic, strong) NSString  *theme_name;
@property (nonatomic, strong) NSString  *ac_time;
@property (nonatomic, strong) NSString  *ac_sustain_time;
@property (nonatomic, strong) NSString  *ac_place;
@property (nonatomic, strong) NSString  *ac_size;
@property (nonatomic, strong) NSString  *ac_pay;
@property (nonatomic, strong) NSString  *usr_id;
@property (nonatomic, strong) NSString  *ac_type;
@property (nonatomic, strong) NSString  *usr_pic;
@property (nonatomic, strong) NSString  *usr_name;
@property (nonatomic, strong) NSMutableArray   *ac_tags;
@end
