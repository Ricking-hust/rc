//
//  FlashActivityModel.h
//  rc
//
//  Created by 余笃 on 16/3/26.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "BaseModel.h"

@interface FlashActivityModel : BaseModel

@property (nonatomic,copy) NSString *acID;
@property (nonatomic,copy) NSString *Image;
@property (nonatomic,copy) NSString *acTime;
@property (nonatomic,copy) NSString *acTitle;

@end

@interface FlashList : NSObject

@property (nonatomic, strong) NSArray *list;

- (instancetype)initWithArray:(NSArray *)array;

@end
