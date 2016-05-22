//
//  CityModel.h
//  日常
//
//  Created by 余笃 on 16/1/25.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "BaseModel.h"

@interface CityModel : BaseModel

@property(nonatomic,copy) NSString *cityID;
@property(nonatomic,copy) NSString *cityName;
@property (nonatomic,assign) BOOL isLocate;

@end

@interface CityList : NSObject

@property (nonatomic, strong) NSArray *list;

- (instancetype)initWithArray:(NSArray *)array;

@end
