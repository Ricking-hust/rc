//
//  RCCollectionCell.m
//  rc
//
//  Created by AlanZhang on 16/3/31.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCCollectionCell.h"
#import "Masonry.h"
#include <sys/sysctl.h>
#define NAME_FONTSIZE 14
#define TIME_FONTSIZE 12
#define PLACE_FONTSIZE 12
#define TAG_FONTSIZE  11
@implementation RCCollectionCell
- (id)init
{
    if (self = [super init])
    {
        self.device = [self currentDeviceSize];
        self.acImage = [[UIImageView alloc]init];
        self.acName = [[UILabel alloc]init];
        self.acTime = [[UILabel alloc]init];
        self.acPlace = [[UILabel alloc]init];
        self.acRelease = [[UILabel alloc]init];
        self.acTagImgeView = [[UIImageView alloc]init];
        self.bgView = [[UIView alloc]init];
        self.model = [[ActivityModel alloc]init];
    }
    [self setSubViewProperty];
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.device = [self currentDeviceSize];
        self.acImage = [[UIImageView alloc]init];
        self.acName = [[UILabel alloc]init];
        self.acTime = [[UILabel alloc]init];
        self.acPlace = [[UILabel alloc]init];
        self.acRelease = [[UILabel alloc]init];
        self.acTagImgeView = [[UIImageView alloc]init];
        self.bgView = [[UIView alloc]init];
        self.model = [[ActivityModel alloc]init];
    }
    [self setSubViewProperty];
    return self;
}
- (void)setModel:(ActivityModel *)model
{
    _model = model;
    self.acName.text = model.acTitle;
    int len = (int)[model.acTime length];
    NSString *timeStr = [model.acTime substringWithRange:NSMakeRange(0, len - 3)];
    self.acTime.text = timeStr;
    self.acPlace.text = model.acPlace;
    
    [self.acImage sd_setImageWithURL:[NSURL URLWithString:model.acPoster] placeholderImage:[UIImage imageNamed:@"20160102.png"]];
    //[cell.acTagImgeView sd_setImageWithURL:[NSURL URLWithString:model.userInfo.userPic] placeholderImage:[UIImage imageNamed:@"20160102.png"]];
    //cell.acRelease.text = model.userInfo.userName;
    [self.acTagImgeView setImage:[UIImage imageNamed:@"tagImage"]];
    NSMutableArray *Artags = [[NSMutableArray alloc]init];
    
    for (TagModel *tagmodel in model.tagsList.list) {
        [Artags addObject:tagmodel.tagName];
    }
    
    NSString *tags = [Artags componentsJoinedByString:@","];
    self.acRelease.text = tags;
    //判断当前活动是否过期
    BOOL isHappened = [self isHappened:model];
    if (isHappened == YES)
    {
        self.acName.textColor = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
        self.acTime.textColor  = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
        self.acPlace.textColor = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
        self.acRelease.textColor  = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
        self.acImage.alpha  = 0.6;
    }else
    {
        self.acName.textColor = [UIColor blackColor];
        self.acTime.textColor  = [UIColor blackColor];
        self.acPlace.textColor = [UIColor blackColor];
        self.acRelease.textColor  = [UIColor blackColor];
        self.acImage.alpha  = 1.0;
    }

    
}
#pragma mark - 判断指定的行程是否已经发生
- (BOOL)isHappened:(ActivityModel *)model
{
    NSString *year = [model.acTime substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [model.acTime substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [model.acTime substringWithRange:NSMakeRange(8, 2)];
    NSString *strDate = [NSString stringWithFormat:@"%@%@%@",year,month,day];
    NSInteger intDate = [strDate integerValue];//指定行程的日期
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"yyyyMMdd"];//设置格式
    [dateformat setTimeZone:[[NSTimeZone alloc]initWithName:@"Asia/Beijing"]];//指定时区
    NSString *currentStrDate = [dateformat stringFromDate:date];
    NSInteger currentIntDate = [currentStrDate integerValue];//当前日期
    
    if (intDate > currentIntDate || intDate == currentIntDate)
    {
        return NO;
    }else
    {
        return YES;
    }
    
}

- (void)setSubViewProperty
{
//    self.acTagImgeView.layer.cornerRadius = 5;
//    self.acTagImgeView.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.acName.font = [UIFont systemFontOfSize:NAME_FONTSIZE];
    self.acTime.font = [UIFont systemFontOfSize:TIME_FONTSIZE];
    self.acPlace.font = [UIFont systemFontOfSize:PLACE_FONTSIZE];
    self.acRelease.font = [UIFont systemFontOfSize:TAG_FONTSIZE];
    self.acTime.alpha = 0.8;
    self.acPlace.alpha = 0.8;
    self.acName.numberOfLines = 0;
    self.acTime.numberOfLines = 0;
    self.acPlace.numberOfLines = 0;
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.acImage];
    [self.contentView addSubview:self.acName];
    [self.contentView addSubview:self.acTime];
    [self.contentView addSubview:self.acPlace];
    [self.contentView addSubview:self.acRelease];
    [self.contentView addSubview:self.acTagImgeView];
    
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.bgView.layer setShadowColor:[UIColor blackColor].CGColor];//设置View的阴影颜色
    [self.bgView.layer setShadowOpacity:0.2f];//设置阴影的透明度
    [self.bgView.layer setShadowOffset:CGSizeMake(0, 0)];//设置View Shadow的偏移量
    
}
- (void)setSubviewConstraint
{
    CGFloat acImageW ; //图片的最大宽度,活动名的最大宽度
    CGFloat acImageH ; //图片的最大高度
    if (self.device == IPhone5)
    {
        acImageW = 142;
        acImageH = 142;
        
    }else if (self.device == IPhone6)
    {
        acImageW = 165;
        acImageH = 165;

    }else
    {
        
        acImageW = 177;
        acImageH = 177;
    }
    [self.acImage mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left);
        make.top.equalTo(self.bgView.mas_top);
        make.right.equalTo(self.bgView.mas_right);
        make.height.mas_equalTo(acImageH);
    }];
    CGSize maxSize = CGSizeMake(acImageW - 20, MAXFLOAT);
    CGSize acNameSize = [self sizeWithText:self.model.acTitle maxSize:maxSize fontSize:NAME_FONTSIZE];
    CGSize acTimeSize = [self sizeWithText:self.model.acTime maxSize:maxSize fontSize:TIME_FONTSIZE];
    CGSize acPlaceSize = [self sizeWithText:self.model.acPlace maxSize:maxSize fontSize:PLACE_FONTSIZE];
    CGSize acTagSize = [self sizeWithText:self.model.userInfo.userName maxSize:maxSize fontSize:TAG_FONTSIZE];
    //活动名约束
    //CGSize maxSize = CGSizeMake(acImageW - 20, MAXFLOAT);
    //CGSize acNameSize = [self sizeWithText:self.acName.text maxSize:maxSize fontSize:NAME_FONTSIZE];
    [self.acName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.acImage.mas_bottom).offset(10);
        make.left.equalTo(self.acImage.mas_left).offset(10);
        make.width.mas_equalTo(acNameSize.width +1);
        make.height.mas_equalTo(acNameSize.height+1);
    }];
    //活动时间约束
    //CGSize acTimeSize = [self sizeWithText:self.acTime.text maxSize:maxSize fontSize:TIME_FONTSIZE];
    [self.acTime mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.acName.mas_bottom).offset(10);
        make.left.equalTo(self.acName.mas_left);
        make.width.mas_equalTo(acTimeSize.width+1);
        make.height.mas_equalTo(acTimeSize.height+1);
    }];
    //地点约束
    //CGSize acPlaceSize = [self sizeWithText:self.acPlace.text maxSize:maxSize fontSize:PLACE_FONTSIZE];
    [self.acPlace mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.acTime.mas_bottom);
        make.left.equalTo(self.acTime.mas_left);
        make.width.mas_equalTo(acPlaceSize.width+1);
        make.height.mas_equalTo(acPlaceSize.height+1);
    }];
    //标志图片约束
    [self.acTagImgeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.acPlace.mas_left);
        make.top.equalTo(self.acPlace.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(7, 10));
    }];
    //标签约束
    //CGSize acTagSize = [self sizeWithText:self.acRelease.text maxSize:maxSize fontSize:TAG_FONTSIZE];
    [self.acRelease mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.acTagImgeView.mas_right).offset(4);
        make.top.equalTo(self.acTagImgeView.mas_top).offset(-2);
        make.width.mas_equalTo(maxSize.width - 10);
        make.height.mas_equalTo(acTagSize.height+1);
    }];
    
    self.height = acImageH + 10 + (int)acNameSize.height + 10 + (int)acTimeSize.height + (int)acPlaceSize.height + 10 + (int)acTagSize.height+5;
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView.mas_top);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(acImageW);
        make.height.mas_equalTo(self.height);
    }];
    
}
//获取当前设备
- (CurrentDevice)currentDeviceSize
{
    if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 4"] ||
        [[self getCurrentDeviceModel] isEqualToString:@"iPhone 5"])
    {
        return IPhone5;
        
    }else if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 6"] )
    {
        return IPhone6;
    }else
    {
        return Iphone6Plus;
    }
}
//获得设备型号
- (NSString *)getCurrentDeviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
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
