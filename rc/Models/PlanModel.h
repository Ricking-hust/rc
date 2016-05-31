//
//  planModel.h
//  日常
//
//  Created by 余笃 on 16/1/26.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "BaseModel.h"
#import "UserModel.h"
#import "ActivityModel.h"
#import "ThemeModel.h"

@interface PlanModel : BaseModel

@property (nonatomic,copy) NSString *planId;
@property (nonatomic,copy) NSString *planContent;
@property (nonatomic,copy) NSString *planTime;
@property (nonatomic,copy) NSString *plAlarmOne;
@property (nonatomic,copy) NSString *plAlarmTwo;
@property (nonatomic,copy) NSString *plAlarmThree;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *acId;
@property (nonatomic,copy) NSString *themeName;
@property (nonatomic,copy) NSString *acPlace;

@end

@interface PlanList : NSObject

@property (nonatomic, strong) NSArray *list;

- (instancetype)initWithArray:(NSArray *)array;

@end