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
//usr_id 用户编号
//usr_name 用户姓名
//usr_sign 用户签名
//usr_pic 用户头像
//usr_sex 用户性别
//usr_phone 用户电话
//usr_mail 用户邮箱