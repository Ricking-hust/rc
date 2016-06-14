//
//  PublisherModel.h
//  rc
//
//  Created by 余笃 on 16/6/14.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "BaseModel.h"

@interface PublisherModel : BaseModel

@property (nonatomic,copy) NSString *pubId;
@property (nonatomic,copy) NSString *pubName;
@property (nonatomic,copy) NSString *pubSign;
@property (nonatomic,copy) NSString *pubPic;
@property (nonatomic,copy) NSString *followed;

@end

@interface PublisherList : NSObject

@property (nonatomic, strong) NSArray *list;

- (instancetype)initWithArray:(NSArray *)array;

@end