//
//  UserModel.h
//  日常
//
//  Created by 余笃 on 15/12/22.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel

@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *userName;
@property (nonatomic,copy) NSString *userSign;
@property (nonatomic,copy) NSString *userPic;
@property (nonatomic,copy) NSString *userSex;
@property (nonatomic,copy) NSString *userPhone;
@property (nonatomic,copy) NSString *userMail;
@property (nonatomic, assign, getter = isLogin) BOOL login;


@end