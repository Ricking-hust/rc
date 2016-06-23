//
//  RCMyFocusCell.m
//  rc
//
//  Created by LittleMian on 16/6/20.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCMyFansCell.h"
#import "RCMyFansModel.h"
#import "RCNetworkingRequestOperationManager.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
@interface RCMyFansCell()
//@property (nonatomic, strong) MBProgressHUD    *HUD;
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation RCMyFansCell

+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString *reuseId = @"focusCell";
    RCMyFansCell * cell = (RCMyFansCell*)[tableView dequeueReusableCellWithIdentifier:reuseId];
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
        self.userImageView   = [[UIImageView alloc]init];
        self.userNameLabel   = [[UILabel alloc]init];
        self.userSignLabel   = [[UILabel alloc]init];
        self.focusButton     = [[UIButton alloc]init];
        self.segmentLineView = [[UIView alloc]init];
        self.isLastCell = NO;
        [self.contentView addSubview:self.userImageView];
        [self.contentView addSubview:self.userNameLabel];
        [self.contentView addSubview:self.userSignLabel];
        [self.contentView addSubview:self.focusButton];
        [self.contentView addSubview:self.segmentLineView];
    }
    return self;
}
- (void)setModel:(RCMyFansModel *)model
{
    _model = model;
    if (_model != nil)
    {
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:_model.usr_pic]];
        self.userNameLabel.text = _model.usr_name;
        self.userSignLabel.text = _model.usr_sign;
        self.userImageView.layer.cornerRadius = 20;
        self.userImageView.layer.masksToBounds = YES;
        [self.userImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(40);
        }];
        self.userNameLabel.font = [UIFont systemFontOfSize:15];
        [self.userNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userImageView.mas_top);
            make.left.equalTo(self.userImageView.mas_right).offset(15);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(60);
        }];
        self.userSignLabel.font = [UIFont systemFontOfSize:11];
        [self.userSignLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userNameLabel.mas_bottom).offset(5);
            make.left.equalTo(self.userNameLabel.mas_left);
            make.height.mas_equalTo(16);
            make.width.mas_equalTo(kScreenWidth - 100);
        }];
        
        UIColor *color = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];
        self.focusButton.layer.borderColor = color.CGColor;
        self.focusButton.layer.borderWidth = 1.0f;
        self.focusButton.layer.cornerRadius = 3.0f;
        self.focusButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.focusButton setTitle:@"加关注" forState:UIControlStateNormal];
        [self.focusButton setTitleColor:color forState:UIControlStateNormal];
        [self.focusButton addTarget:self action:@selector(cancelFollow:) forControlEvents:UIControlEventTouchUpInside];
        [self.focusButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView.mas_right).offset(-15);
            make.width.mas_equalTo(45);
            make.height.mas_equalTo(20);
        }];
        if (self.isLastCell == NO)
        {
            self.segmentLineView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
            [self.segmentLineView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.userImageView.mas_left);
                make.right.equalTo(self.contentView.mas_right);
                make.bottom.equalTo(self.contentView.mas_bottom);
                make.height.mas_equalTo(1);
            }];
        }else
        {
            ;
        }
    }
}
#pragma mark - 添加关注或取消关注
/**
 *  op_type = 1 表示关注
 *  op_type = 2 表示取消关注
 */
- (void)cancelFollow:(UIButton *)button
{
//    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    self.HUD.removeFromSuperViewOnHide = YES;
//    [self.view addSubview:self.HUD];
//    [self.HUD showAnimated:YES];
    if ([button.titleLabel.text isEqualToString:@"加关注"])
    {
        [self cancelFollowUserRequest:self.model.usr_id WithOpertaionType:@"1"];
    }else
    {
        ;
    }
   
}

- (void)cancelFollowUserRequest:(NSString *)publisherID WithOpertaionType:(NSString *)op_type
{
    
    NSString *URLString = @"http://appv2.myrichang.com/Home/UserRelation/followUser";
    NSString *usr_id = [userDefaults objectForKey:@"userId"];
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:usr_id,@"usr_id",publisherID,@"publisher_id",op_type,@"op_type", nil];
    [RCNetworkingRequestOperationManager request:URLString requestType:GET parameters:parameters completeBlock:^(NSData *data) {
        id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSNumber *code = [dict valueForKey:@"code"];
        if ([code isEqualToNumber:[[NSNumber alloc]initWithInt:200]])//msg=操作成功
        {

        }else if ([code isEqualToNumber:[[NSNumber alloc]initWithInt:210]])//msg = 操作失败
        {
            
        }else if ([code isEqualToNumber:[[NSNumber alloc]initWithInt:220]])//msg = 关注失败
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"这只是测试";
            [hud hideAnimated:YES afterDelay:0.6f];
            
        }else//msg = 取消息关注失败
        {
            
        }

    } errorBlock:^(NSError *error) {
        
    }];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
