//
//  RCCommentcell.m
//  rc
//
//  Created by 余笃 on 16/7/4.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCCommentcell.h"
#import "Masonry.h"
#import "RCUtils.h"

#define COMFONT 14
#define NAMEFONT 11
#define PADDING  10
static const CGFloat userSize = 40;
static const CGFloat praiseSzie = 15;

@implementation RCCommentcell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        if (!_user) {
            _user = [[UIImageView alloc]init];
            _user.layer.masksToBounds = YES;
            _user.layer.cornerRadius = 20;
            _user.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(turnToUsererView)];
            [_user addGestureRecognizer:tap];
            [self.contentView addSubview:_user];
        }
        
        if (!_nameLab) {
            _nameLab = [[UILabel alloc]init];
            [_nameLab setFont:[UIFont systemFontOfSize:NAMEFONT]];
            [_nameLab setTextColor:[UIColor blackColor]];
            [self.contentView addSubview:_nameLab];
        }
        
        if (!_commentLab) {
            _commentLab = [[UILabel alloc]init];
            [_commentLab setFont:[UIFont systemFontOfSize:COMFONT]];
            [_commentLab setTextColor:RGB(0x464646, 0.8)];
            _commentLab.lineBreakMode = NSLineBreakByCharWrapping;
            _commentLab.numberOfLines = 0;
            [self.contentView addSubview:_commentLab];
        }
        
        if (!_timeLab) {
            _timeLab = [[UILabel alloc]init];
            [_timeLab setFont:[UIFont systemFontOfSize:NAMEFONT]];
            [_timeLab setTextColor:RGB(0x464646, 0.6)];
            [self.contentView addSubview:_timeLab];
        }
        
        if (!_praiseNum) {
            _praiseNum = [[UILabel alloc]init];
            [_praiseNum setFont:[UIFont systemFontOfSize:COMFONT]];
            [_praiseNum setTextColor:[UIColor blackColor]];
            [_praiseNum setTextAlignment:NSTextAlignmentRight];
            [self.contentView addSubview:_praiseNum];
        }
        
        if (!_praiseBtn) {
            _praiseBtn = [[UIButton alloc]init];
            [self.contentView addSubview:_praiseBtn];
        }
        
        if(!_fatherComment){
            _fatherComment = [[UIButton alloc]init];
            [self.contentView addSubview:_fatherComment];
        }
    }
    return  self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize maxSize = CGSizeMake(kScreenWidth - PADDING*5 - userSize - praiseSzie*2, MAXFLOAT);
    CGSize commentLabSize = [RCUtils sizeWithText:self.commentModel.comment_content maxSize:maxSize fontSize:COMFONT];
    
    [self.user mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(PADDING);
        make.top.equalTo(self.contentView.mas_top).offset(PADDING);
        make.size.mas_equalTo(CGSizeMake(userSize, userSize));
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-PADDING);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(150, 14));
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.user.mas_right).offset(PADDING);
        make.right.equalTo(self.timeLab.mas_left).offset(-PADDING);
        make.top.equalTo(self.timeLab.mas_top);
        make.bottom.equalTo(self.timeLab.mas_bottom);
    }];
    
    
    if (self.isPreComment) {
        [self.commentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLab.mas_bottom).offset(9);
            make.left.equalTo(self.nameLab.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-PADDING);
            make.height.mas_equalTo(35);
        }];
    } else {
        [self.commentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLab.mas_bottom).offset(9);
            make.left.equalTo(self.nameLab.mas_left);
            make.right.equalTo(self.contentView.mas_right).offset(-PADDING);
            make.height.mas_equalTo((int)commentLabSize.height+1);
        }];
    }
    
    [self.praiseNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.praiseBtn.mas_left).offset(-PADDING);
        make.bottom.equalTo(self.praiseBtn.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(praiseSzie * 5, praiseSzie));
    }];
    
    [self.praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-PADDING);
        make.top.equalTo(self.commentLab.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(praiseSzie, praiseSzie));
    }];
}

-(void)setSubViewValue{
    [self.user sd_setImageWithURL:[NSURL URLWithString:self.commentModel.commentUser.userPic] placeholderImage:[UIImage imageNamed:@"MyIconNormal" ] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    [self.timeLab setText:self.commentModel.comment_time];
    [self.nameLab setText:self.commentModel.commentUser.userName];
    [self.commentLab setText:self.commentModel.comment_content];
    [self.praiseNum setText:self.commentModel.comment_praise_num];
    [self.praiseBtn setImage:[UIImage imageNamed:@"zan_done icon"] forState:UIControlStateNormal];
    
}

-(void)turnToUsererView{
    NSLog(@"turnToUsererView");
}

@end
