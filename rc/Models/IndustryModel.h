//
//  IndustryModel.h
//  日常
//
//  Created by 余笃 on 16/1/26.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "BaseModel.h"

@interface IndustryModel : BaseModel

@property (nonatomic,copy) NSString *indId;
@property (nonatomic,copy) NSString *indName;

@end

@interface IndustryList : NSObject

@property (nonatomic, strong) NSArray *list;

- (instancetype)initWithArray:(NSArray *)array;

@end