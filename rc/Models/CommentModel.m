//
//  CommentModel.m
//  rc
//
//  Created by 余笃 on 16/7/6.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CommentModel.h"
#import "NSDictionary+NotNullKey.h"

@implementation CommentModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super initWithDictionary:dict]) {
        self.comment_id                 = [dict objectForSafeKey:@"comment_id"];
        self.commentUser           = [[UserModel alloc] init];
        self.commentUser.userId         = [dict objectForSafeKey:@"usr_id"];
        self.commentUser.userName       = [dict objectForSafeKey:@"usr_name"];
        self.commentUser.userPic        = [dict objectForSafeKey:@"usr_pic"];
        self.father_comment_id          = [dict objectForSafeKey:@"father_comment_id"];
        self.comment_time               = [dict objectForSafeKey:@"comment_time"];
        self.comment_content            = [dict objectForSafeKey:@"comment_content"];
        self.comment_praise_num         = [dict objectForSafeKey:@"comment_praise_num"];
        self.father_comment_usr_id      = [dict objectForSafeKey:@"father_comment_usr_id"];
        self.father_comment_usr_name    = [dict objectForSafeKey:@"father_comment_usr_name"];
        self.father_comment_content     = [dict objectForSafeKey:@"father_comment_content"];
    }
    
    return self;
}

@end

@implementation CommentList

-(instancetype)initWithArray:(NSArray *)array{
    if (self = [super init]) {
        NSMutableArray *list = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in array) {
            CommentModel *model = [[CommentModel alloc] initWithDictionary:dict];
            [list addObject:model];
        }
        
        self.list = list;
    }
    return self;
}

@end
