//
//  ActivityIntroduction.h
//  rc
//
//  Created by AlanZhang on 16/1/17.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "Activity.h"

@interface ActivityIntroduction : Activity

@property (nonatomic,copy)NSString *ac_size;    //活动规模
@property (nonatomic,copy)NSString *ac_pay;     //活动费用
@property (nonatomic,copy)NSString *ac_desc;    //活动须知
@end
