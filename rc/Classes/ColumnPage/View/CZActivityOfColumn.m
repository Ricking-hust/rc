//
//  CZActivityOfColumn.m
//  rc
//
//  Created by AlanZhang on 16/1/26.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZActivityOfColumn.h"
#import "CZAcitivityModelOfColumn.h"
#import "Masonry.h"
#include <sys/sysctl.h>

#define TITTLE_FONTSIZE 14  //标题字体大小
#define TIME_FONTSIZE   10  //时间字体大小
#define PLACE_FONTSIZE  10  //地点字体大小
#define TAG_FONTSIZE    10  //标签字体大小

@implementation CZActivityOfColumn

+ (instancetype)activityView
{
    CZActivityOfColumn *acView = [[CZActivityOfColumn alloc]init];
    acView.backgroundColor = [UIColor whiteColor];
    [acView createSubViews];
    //添加四个边阴影
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){191.0/255.0 ,191.0/255.0,191.0/255.0,1.0});
    acView.layer.shadowColor = color;//阴影颜色
    acView.layer.shadowOffset = CGSizeMake(1, 0);//偏移距离
    acView.layer.shadowOpacity = 0.8;//不透明度
    acView.layer.shadowRadius = 1.0;//半径
    
    return acView;
}
//对子控件赋值
- (void)setActivity:(CZAcitivityModelOfColumn *)activity
{
    _activity = activity;
    self.acImage.image = [UIImage imageNamed:self.activity.ac_poster];
    self.acName.text = self.activity.ac_title;
    self.acTime.text = self.activity.ac_time;
    self.acPlace.text = self.activity.ac_place;
    self.acTagImage.image = [UIImage imageNamed:@"tagImage"];
    self.acTag.text = self.activity.ac_tags;
    [self addConstraint];
}
//给子控件添加线束
- (void)addConstraint
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    
    const CGFloat IMAGE_W  = rect.size.width * 0.44;
    const CGFloat IMAGE_H = IMAGE_W * 0.75;
    

    CGFloat labelMaxWidth = IMAGE_W * 0.88;
    CGFloat leftPadding = labelMaxWidth * 0.12/2;
    CGFloat topPadding = leftPadding;
    CGFloat paddingOfNameAndTime = 5;
    CGFloat paddingOfPlaceAndTagImage = 10;

    //添加imageView约束
    [self.acImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(IMAGE_W, IMAGE_H));
    }];
    
    //添加Name约束
    self.acName.font = [UIFont systemFontOfSize:TITTLE_FONTSIZE];
    self.acName.numberOfLines = 0;
    CGSize nameSize = [self sizeWithText:self.acName.text maxSize:CGSizeMake(labelMaxWidth, MAXFLOAT) fontSize:TITTLE_FONTSIZE];
    [self.acName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(leftPadding);
        make.top.equalTo(self.acImage.mas_bottom).with.offset(topPadding);
        make.size.mas_equalTo(CGSizeMake(nameSize.width, nameSize.height+2));
    }];
    
    //添加time约束
    self.acTime.font = [UIFont systemFontOfSize:TIME_FONTSIZE];
    self.acTime.numberOfLines = 0;
    CGSize timeSize = [self sizeWithText:self.acTime.text maxSize:CGSizeMake(IMAGE_W-20, MAXFLOAT) fontSize:TIME_FONTSIZE];
    [self.acTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.acName.mas_left);
        make.top.equalTo(self.acName.mas_bottom).with.offset(paddingOfNameAndTime);
        make.size.mas_equalTo(CGSizeMake(timeSize.width, timeSize.height+2));
    }];
    //添加place约束
    self.acPlace.font = [UIFont systemFontOfSize:PLACE_FONTSIZE];
    self.acPlace.numberOfLines = 0;
    CGSize placeSize = [self sizeWithText:self.acPlace.text maxSize:CGSizeMake(IMAGE_W-20, MAXFLOAT) fontSize:PLACE_FONTSIZE];
    [self.acPlace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.acName.mas_left);
        make.top.equalTo(self.acTime.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(placeSize.width, placeSize.height+2));
    }];
    //添加tagImage约束
    [self.acTagImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.acName.mas_left);
        make.top.equalTo(self.acPlace.mas_bottom).with.offset(paddingOfPlaceAndTagImage);
        make.size.mas_equalTo(self.acTagImage.image.size);
    }];
    //添加tag约束
    self.acTag.font = [UIFont systemFontOfSize:TAG_FONTSIZE];
    self.acTag.numberOfLines = 0;
    CGSize tagSize = [self sizeWithText:self.acPlace.text maxSize:CGSizeMake(IMAGE_W-20, MAXFLOAT) fontSize:TAG_FONTSIZE];
    [self.acTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.acTagImage.mas_right).with.offset(10);
        make.top.equalTo(self.acTagImage.mas_top).with.offset(2);
        make.size.mas_equalTo(CGSizeMake(tagSize.width, tagSize.height+2));
    }];
    self.heigth = IMAGE_H + nameSize.height + timeSize.height + placeSize.height + tagSize.height + self.acTagImage.image.size.height + 30;
    self.width = IMAGE_W;
}

//创建子控件
- (void) createSubViews
{
    self.acImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:self.acImage];
    
    self.acName = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:self.acName];
    
    self.acTime = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:self.acTime];
    
    self.acPlace = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:self.acPlace];
    
    self.acTagImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    [self addSubview:self.acTagImage];
    
    self.acTag = [[UILabel alloc]initWithFrame:CGRectZero];
    [self addSubview:self.acTag];
}
/**
 *  普通函数
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
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
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
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

@end
