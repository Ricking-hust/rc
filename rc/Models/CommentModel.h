//
//  CommentModel.h
//  rc
//
//  Created by 余笃 on 16/7/6.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "BaseModel.h"
#import "UserModel.h"

@interface CommentModel : BaseModel

@property (nonatomic,copy) NSString *comment_id;
@property (nonatomic,copy) NSString *father_comment_id;
@property (nonatomic,copy) NSString *comment_content;
@property (nonatomic,copy) NSString *comment_time;
@property (nonatomic,copy) NSString *comment_praise_num;
@property (nonatomic,copy) NSString *father_comment_usr_id;
@property (nonatomic,copy) NSString *father_comment_usr_name;
@property (nonatomic,copy) NSString *father_comment_content;
@property (nonatomic,copy) NSString *isPraised;

@property (nonatomic,strong) UserModel *commentUser;

@end

@interface CommentList : NSObject

@property (nonatomic, strong) NSArray *list;

- (instancetype)initWithArray:(NSArray *)array;

@end
