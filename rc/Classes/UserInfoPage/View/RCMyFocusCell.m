//
//  RCMyFocusCell.m
//  rc
//
//  Created by LittleMian on 16/6/21.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCMyFocusCell.h"
#import "RCMyFocusModel.h"
#import "RCNetworkingRequestOperationManager.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
@interface RCMyFocusCell ()
@property (nonatomic, strong) MBProgressHUD    *HUD;
@end
@implementation RCMyFocusCell
+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *reuseId = @"fansCell";
    RCMyFocusCell * cell = (RCMyFocusCell *)[tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell)
    {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //清除cell的点击状态
    return cell;
}
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.userImageView = [[UIImageView alloc]init];
        self.userNameLabel = [[UILabel alloc]init];
        self.segmentView = [[UIView alloc]init];
        self.cancelFocus = [[UIButton alloc]init];
        self.isLastCell = NO;
        [self.contentView addSubview:self.userImageView];
        [self.contentView addSubview:self.userNameLabel];
        [self.contentView addSubview:self.segmentView];
        [self.contentView addSubview:self.cancelFocus];
        
    }
    return self;
}
- (void)setModel:(RCMyFocusModel *)model
{
    _model = model;
    if (_model != nil)
    {
        self.userImageView.layer.cornerRadius = 35.0/2.0f;
        self.userImageView.layer.masksToBounds = YES;
        NSURL *urlImg = [NSURL URLWithString:_model.usr_pic];
        [self.userImageView sd_setImageWithURL:urlImg placeholderImage:[UIImage imageNamed:@"logo"]];
        [self.userImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(35);
        }];
        self.userNameLabel.text = _model.usr_name;
        self.userNameLabel.font = [UIFont systemFontOfSize:14];
        CGSize nameLabelSize = [self sizeWithText:self.userNameLabel.text maxSize:CGSizeMake(200, 30) fontSize:14];
        [self.userNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.left.equalTo(self.userImageView.mas_right).offset(16);
            make.height.mas_equalTo((int)nameLabelSize.height + 1);
            make.width.mas_equalTo((int)nameLabelSize.width + 1);
        }];
        self.segmentView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        
        
        UIColor *color = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];
        self.cancelFocus.layer.borderColor = color.CGColor;
        self.cancelFocus.layer.borderWidth = 1.0f;
        self.cancelFocus.layer.cornerRadius = 3.0f;
        self.cancelFocus.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.cancelFocus setTitle:@"取消关注" forState:UIControlStateNormal];
        [self.cancelFocus setTitleColor:color forState:UIControlStateNormal];
        [self.cancelFocus addTarget:self action:@selector(cancelFollow:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelFocus mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.width.mas_equalTo(55);
            make.height.mas_equalTo(22);
        }];
        if (self.isLastCell == NO)
        {
            [self.segmentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.userImageView.mas_left);
                make.right.equalTo(self.contentView.mas_right);
                make.height.mas_equalTo(1);
                make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
            }];
        }else
        {
            ;
        }
    }
}
- (void)cancelFollow:(UIButton *)button
{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.view addSubview:self.HUD];
    [self.HUD showAnimated:YES];
    NSString *URLString = @"http://appv2.myrichang.com/Home/UserRelation/followUser";
    NSString *usr_id = [userDefaults objectForKey:@"userId"];
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:usr_id,@"usr_id",self.model.usr_id,@"publisher_id",@"2",@"op_type", nil];
    [RCNetworkingRequestOperationManager request:URLString requestType:GET parameters:parameters completeBlock:^(NSData *data) {
        id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSNumber *code = [dict valueForKey:@"code"];
        if ([code isEqualToNumber:[[NSNumber alloc]initWithInt:200]])//msg = 操作成功
        {
            self.HUD.mode = MBProgressHUDModeCustomView;
            self.HUD.label.text = @"取消关注成功";
            [self.HUD hideAnimated:YES afterDelay:0.6];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"cancelFollow" object:self];
        }else if ([code isEqualToNumber:[[NSNumber alloc]initWithInt:210]])//msg = 操作失败
        {
            
        }else if ([code isEqualToNumber:[[NSNumber alloc]initWithInt:220]])//msg = 关注失败
        {
            
        }else//msg = 取消息关注失败
        {
            
        }
        NSLog(@"msg = %@",[dict valueForKey:@"msg"]);

    } errorBlock:^(NSError *error) {
        
    }];

}
/**
 *  计算文本的大小
 *
 *  @param text 待计算大小的字符串
 *
 *  @param fontSize 指定绘制字符串所用的字体大小
 *
 *  @return 字符串的大小
 */
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
}



@end
