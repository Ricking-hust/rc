//
//  RCAblumInfoCollection.m
//  rc
//
//  Created by LittleMian on 16/7/13.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCAblumInfoCollectionCell.h"
#import "CZActivityInfoViewController.h"
#import "RCAblumActivityModel.h"
#import "Masonry.h"
#import "ActivityModel.h"
//#import "RCButton.h"
@interface RCAblumInfoCollectionCell()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *tittleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *placeLabel;
@property (nonatomic, strong) UIButton *infoButton;
@property (nonatomic, weak)   UIView *superView;
@property (nonatomic, strong) RCAblumActivityModel *ablumInfomodel;
@end
@implementation RCAblumInfoCollectionCell
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageView = [[UIImageView alloc]init];
        self.tittleLabel = [[UILabel alloc]init];
        self.timeLabel = [[UILabel alloc]init];
        self.desLabel = [[UILabel alloc]init];
        self.placeLabel = [[UILabel alloc]init];
        self.infoButton = [[UIButton alloc]init];

        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.tittleLabel];
        [self.contentView addSubview:self.desLabel];
        [self.contentView addSubview:self.placeLabel];
        [self.contentView addSubview:self.infoButton];
    }
    self.backgroundColor = [UIColor whiteColor];
    return self;
}
- (void)setModel:(RCAblumActivityModel *)model
{
    _ablumInfomodel = model;

    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_ablumInfomodel.ac_img] placeholderImage:[UIImage imageNamed:@"img_1"]];
    self.tittleLabel.text = _ablumInfomodel.ac_title;
    NSString *time = _ablumInfomodel.ac_time;
    self.timeLabel.text = [time substringWithRange:NSMakeRange(0, [time length]-3)];
    self.desLabel.text = _ablumInfomodel.ac_des;
    self.placeLabel.text = _ablumInfomodel.ac_place;
    
//    [self.imageView setFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.height.mas_equalTo(150);
    }];

    self.tittleLabel.font = [UIFont systemFontOfSize:16];
    self.tittleLabel.alpha = 0.8;
    
//    CGSize tittleSize = [self sizeWithText:self.tittleLabel.text maxSize:CGSizeMake(kScreenWidth - 30, 20) fontSize:16];
//    CGSize timeSize = [self sizeWithText:self.timeLabel.text maxSize:CGSizeMake(kScreenWidth - 30, 17) fontSize:14];
//    CGSize desSize = [self sizeWithText:self.desLabel.text maxSize:CGSizeMake(kScreenWidth - 30, 35) fontSize:14];
//    CGSize placeSize = [self sizeWithText:self.placeLabel.text maxSize:CGSizeMake(kScreenWidth - 30, 35) fontSize:14];
    
    [self.tittleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.imageView.mas_bottom).offset(15);
        make.width.mas_equalTo((int)_ablumInfomodel.tittleSize.width + 1);
        make.height.mas_equalTo((int)_ablumInfomodel.tittleSize.height + 1);
    }];
    self.timeLabel.font = [UIFont systemFontOfSize:14];
    self.timeLabel.alpha = 0.8;

    [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tittleLabel.mas_left);
        make.top.equalTo(self.tittleLabel.mas_bottom).offset(15);
        make.width.mas_equalTo((int)_ablumInfomodel.timeSize.width+1);
        make.height.mas_equalTo((int)_ablumInfomodel.timeSize.height+1);
    }];
    self.desLabel.font = [UIFont systemFontOfSize:14];
    self.desLabel.alpha = 0.8;
    self.desLabel.numberOfLines = 0;

    [self.desLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tittleLabel.mas_left);
        make.top.equalTo(self.timeLabel.mas_bottom).offset(5);
        make.width.mas_equalTo((int)_ablumInfomodel.desSize.width+1);
        make.height.mas_equalTo((int)_ablumInfomodel.desSize.height+1);
    }];
    self.placeLabel.font = [UIFont systemFontOfSize:14];
    self.placeLabel.alpha = 0.8;
    self.placeLabel.numberOfLines = 0;

    [self.placeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tittleLabel.mas_left);
        make.top.equalTo(self.desLabel.mas_bottom).offset(5);
        make.width.mas_equalTo((int)_ablumInfomodel.placeSize.width+1);
        make.height.mas_equalTo((int)_ablumInfomodel.placeSize.height+1);
    }];
    
    self.infoButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.infoButton setTitle:@"查看更多" forState:UIControlStateNormal];
    [self.infoButton setImage:[UIImage imageNamed:@"ablumInfo"] forState:UIControlStateNormal];
    [self.infoButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.infoButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-10);
        make.width.mas_equalTo(84);
        make.height.mas_equalTo(30);
    }];
    [self.infoButton addTarget:self action:@selector(getAblumActivityInfo:) forControlEvents:UIControlEventTouchUpInside];
    self.infoButton.imageEdgeInsets = UIEdgeInsetsMake(0, 70, 0, 0);
    self.infoButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 14);

}
- (void)getAblumActivityInfo:(UIButton *)button
{
    CZActivityInfoViewController *ac = [[CZActivityInfoViewController alloc]init];
    
    ac.activityModelPre = [self activityModeFromUserActivity];
    [[self viewController].navigationController pushViewController:ac animated:YES];
}
- (ActivityModel *)activityModeFromUserActivity
{
    ActivityModel *model = [[ActivityModel alloc]init];
    
    model.acID = @"2403";
    model.acPoster = @"http://img.myrichang.com/upload/2016-06-18_13:18:51_d41d8cd98f00b204e9800998ecf8427e.png";
    model.acPosterTop = @"";
    model.acTitle = @"世界五大童声合唱团之一 巴黎男童合唱团";
    model.acTime = @"2016-07-22 19:30:00";
    model.acTheme = @"";
    model.acPlace = @"武汉 江岸区 武汉剧院";
    model.acCollectNum = @"zhangdy";
    model.acSize = @"";
    model.acPay = @"";
    model.acDesc = @"暂无";
    model.acReview = @"";
    model.acStatus = @"";
    model.acPraiseNum = @"";
    model.acReadNum = @"";
    model.acHtml = @"";
    model.acCollectNum = @"";
    model.plan = @"";
    model.planId = @"";
    model.userInfo.userId = [userDefaults valueForKey:@"userId"];
    model.userInfo.userName = [userDefaults valueForKey:@"userName"];
    model.userInfo.userPic = [userDefaults valueForKey:@"userPic"];
    model.tagsList.list = [[NSMutableArray alloc]init];

//    model.acID = self.ablumInfomodel.ac_id;
//    model.acPoster = self.ablumInfomodel.ac_img;
//    model.acPosterTop = @"";
//    model.acTitle = self.ablumInfomodel.ac_title;
//    model.acTime = self.ablumInfomodel.ac_time;
//    model.acTheme = @"";
//    model.acPlace = self.ablumInfomodel.ac_place;
//    model.acCollectNum = @"zhangdy";
//    model.acSize = @"";
//    model.acPay = @"";
//    model.acDesc = self.ablumInfomodel.ac_des;
//    model.acReview = @"";
//    model.acStatus = @"";
//    model.acPraiseNum = @"";
//    model.acReadNum = @"";
//    model.acHtml = @"";
//    model.acCollectNum = @"";
//    model.plan = @"";
//    model.planId = @"";
//    model.userInfo.userId = [userDefaults valueForKey:@"userId"];
//    model.userInfo.userName = [userDefaults valueForKey:@"userName"];
//    model.userInfo.userPic = [userDefaults valueForKey:@"userPic"];
//    model.tagsList.list = [[NSMutableArray alloc]init];
    
    return model;
}


- (void)setResponder:(UIView *)view
{
    self.superView = view;
}
- (UIResponder *)nextResponder
{
    [super nextResponder];
    return self.superView;
}
-(UIViewController *)viewController {
    /// Finds the view's view controller.
    
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    return nil;
}

/**
 *  计算字体的长和宽
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
