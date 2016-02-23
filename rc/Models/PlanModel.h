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

@interface planModel : BaseModel

@property (nonatomic,copy) NSString *planId;
@property (nonatomic,copy) NSString *planContent;
@property (nonatomic,copy) NSString *plAlarmOne;
@property (nonatomic,copy) NSString *plAlarmTwo;
@property (nonatomic,copy) NSString *plAlarmThree;

@property (nonatomic,strong) UserModel *user;
@property (nonatomic,strong) ActivityModel *activity;
@property (nonatomic,strong)  ThemeModel *theme;

@end

@interface planList : NSObject

@property (nonatomic, strong) NSArray *list;

- (instancetype)initWithArray:(NSArray *)array;

@end