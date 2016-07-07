//
//  RCCommentcell.h
//  rc
//
//  Created by 余笃 on 16/7/4.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#define kCellIdentifier_CommentCell @"kCellIdentifier_CommentCell"

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface RCCommentcell : UITableViewCell

@property (nonatomic,strong) CommentModel *commentModel;
@property (nonatomic,strong) UIImageView *user;
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *commentLab;
@property (nonatomic,strong) UILabel *timeLab;
@property (nonatomic,strong) UILabel *praiseNum;
@property (nonatomic,strong) UIButton *praiseBtn;
@property (nonatomic,strong) UIButton *fatherComment;

-(void)setSubViewValue;

@end
