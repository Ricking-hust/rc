//
//  TagModel.h
//  日常
//
//  Created by 余笃 on 16/1/28.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "BaseModel.h"

@interface TagModel : BaseModel

@property (nonatomic,copy) NSString *tagId;
@property (nonatomic,copy) NSString *tagName;

@end

@interface TagsList : NSObject

@property (nonatomic, strong) NSArray *list;

- (instancetype)initWithArray:(NSArray *)array;

@end