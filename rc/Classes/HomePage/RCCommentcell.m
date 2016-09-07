//
//  RCCommentcell.m
//  rc
//
//  Created by 余笃 on 16/7/4.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCCommentcell.h"
#import "RCCommentViewController.h"
#import "CZActivityInfoViewController.h"
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
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(turnToUserView)];
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
            [_praiseBtn addTarget:self action:@selector(praise:) forControlEvents:UIControlEventTouchUpInside];
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
    if ([self.commentModel.isPraised isEqualToString:@"1"]) {
        [self.praiseBtn setImage:[UIImage imageNamed:@"zan_done icon"] forState:UIControlStateNormal];
    } else {
        [self.praiseBtn setImage:[UIImage imageNamed:@"zan_icon"] forState:UIControlStateNormal];
    }
    
}

-(void)praise:(UIButton *)btn{
    RCCommentViewController *fatherVC = [[RCCommentViewController alloc]init];
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[RCCommentViewController class]]) {
            fatherVC = (RCCommentViewController *)nextResponder;
        }
    }
    if ([DataManager manager].user.isLogin){
        if ([self.commentModel.isPraised isEqualToString:@"1"]) {
            [[DataManager manager] praiseCommentWithUsrId:[userDefaults objectForKey:@"userId"] commentId:self.commentModel.comment_id opType:@"2" success:^(NSString *msg) {
                if ([msg isEqualToString:@"200"]) {
                    [btn setImage:[UIImage imageNamed:@"zan_icon"] forState:UIControlStateNormal];
                    fatherVC.HUD.mode = MBProgressHUDModeCustomView;
                    fatherVC.HUD.label.text = @"取消点赞成功";
                    self.commentModel.isPraised = @"0";
                    [fatherVC.HUD hideAnimated:YES afterDelay:0.6];
                } else {
                    fatherVC.HUD.mode = MBProgressHUDModeCustomView;
                    fatherVC.HUD.label.text = @"取消点赞失败";
                    [fatherVC.HUD hideAnimated:YES afterDelay:0.6];
                }
            } failure:^(NSError *error) {
                fatherVC.HUD.mode = MBProgressHUDModeCustomView;
                fatherVC.HUD.label.text = @"操作失败";
                [fatherVC.HUD hideAnimated:YES afterDelay:0.6];
                NSLog(@"Error:%@",error);
            }];
        } else {
            [[DataManager manager] praiseCommentWithUsrId:[userDefaults objectForKey:@"userId"] commentId:self.commentModel.comment_id opType:@"1" success:^(NSString *msg) {
                if ([msg isEqualToString:@"200"]) {
                    [btn setImage:[UIImage imageNamed:@"zan_done icon"] forState:UIControlStateNormal];
                    fatherVC.HUD.mode = MBProgressHUDModeCustomView;
                    fatherVC.HUD.label.text = @"点赞成功";
                    self.commentModel.isPraised = @"1";
                    [fatherVC.HUD hideAnimated:YES afterDelay:0.6];
                } else {
                    fatherVC.HUD.mode = MBProgressHUDModeCustomView;
                    fatherVC.HUD.label.text = @"点赞失败";
                    [fatherVC.HUD hideAnimated:YES afterDelay:0.6];
                }
            } failure:^(NSError *error) {
                fatherVC.HUD.mode = MBProgressHUDModeCustomView;
                fatherVC.HUD.label.text = @"操作失败";
                [fatherVC.HUD hideAnimated:YES afterDelay:0.6];
                NSLog(@"Error:%@",error);
            }];
        }
    } else
    {
        fatherVC.HUD.mode = MBProgressHUDModeCustomView;
        fatherVC.HUD.label.text = @"请登录";
        [fatherVC.HUD hideAnimated:YES afterDelay:0.6];
    }
}

-(void)turnToUserView{
    NSLog(@"turnToUserView");
}

@end
