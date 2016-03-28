//
//  ActivityModel.h
//  日常
//
//  Created by 余笃 on 15/12/26.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import "BaseModel.h"

@class UserModel,TagsList;

@interface ActivityModel : BaseModel

@property (nonatomic,copy) NSString *acID;
@property (nonatomic,copy) NSString *acPoster;
@property (nonatomic,copy) NSString *acPosterTop;
@property (nonatomic,copy) NSString *acTitle;
@property (nonatomic,copy) NSString *acTime;
@property (nonatomic,copy) NSString *acTheme;
@property (nonatomic,copy) NSString *acPlace;
@property (nonatomic,copy) NSString *acCollectNum;
@property (nonatomic,copy) NSString *acSize;
@property (nonatomic,copy) NSString *acPay;
@property (nonatomic,copy) NSString *acDesc;
@property (nonatomic,copy) NSString *acPraiseNum;
@property (nonatomic,copy) NSString *acReadNum;
@property (nonatomic,copy) NSString *acHtml;
@property (nonatomic,copy) NSString *acCollect;
@property (nonatomic,copy) NSString *plan;
@property (nonatomic,copy) NSString *planId;

@property (nonatomic,strong) UserModel *userInfo;
@property (nonatomic,strong) TagsList *tagsList;

@end


@interface ActivityList : NSObject

@property (nonatomic, strong) NSArray *list;

- (instancetype)initWithArray:(NSArray *)array;

@end

