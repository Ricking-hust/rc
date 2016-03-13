//
//  CZColumnCell.m
//  rc
//
//  Created by AlanZhang on 16/3/10.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZColumnCell.h"
#import "Masonry.h"
#include <sys/sysctl.h>

@implementation CZColumnCell

- (id)init
{
    if (self = [super init])
    {
        self.acImageView = [[UIImageView alloc]init];
        self.acNameLabel = [[UILabel alloc]init];
        self.acTimeLabel = [[UILabel alloc]init];
        self.acPlaceLabel = [[UILabel alloc]init];
        self.tagImageView = [[UIImageView alloc]init];
        self.acTagLabel = [[UILabel alloc]init];
        self.device = [self currentDeviceSize];
        self.isLeft = NO;
        self.cellHeight = 44;
    }
    [self setSubViewProperty];
    return self;
}
- (void)setSubViewProperty
{
    self.acNameLabel.font = [UIFont systemFontOfSize:14];
    self.acTimeLabel.font = [UIFont systemFontOfSize:12];
    self.acPlaceLabel.font = [UIFont systemFontOfSize:12];
    self.acTagLabel.font = [UIFont systemFontOfSize:10];
    self.acTimeLabel.alpha = 0.8;
    self.acPlaceLabel.alpha = 0.8;
    [self.contentView addSubview:self.acImageView];
    [self.contentView addSubview:self.acNameLabel];
    [self.contentView addSubview:self.acTimeLabel];
    [self.contentView addSubview:self.acPlaceLabel];
    [self.contentView addSubview:self.tagImageView];
    [self.contentView addSubview:self.acTagLabel];
    
}
- (void)setSubviewConstraint
{
    CGFloat acImageW; //图片的最大宽度,活动名的最大宽度
    CGFloat acImageH; //图片的最大高度
    CGFloat leftPaddintToContentView;
    CGFloat rightPaddingToContentView;
    if (self.device == IPhone5)
    {
        acImageW = 142;
        acImageH = 110;
        leftPaddintToContentView = 12;
        rightPaddingToContentView = leftPaddintToContentView;
        
    }else if (self.device == IPhone6)
    {
        acImageW = 165;
        acImageH = 125;
        leftPaddintToContentView = 15;
        rightPaddingToContentView = leftPaddintToContentView;
    }else
    {
        acImageW = 207;
        acImageH = 135;
        leftPaddintToContentView = 20;
        rightPaddingToContentView = leftPaddintToContentView;
    }
    
    //图片的约束
    if (self.isLeft)
    {
        [self.acImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(leftPaddintToContentView);
            make.top.equalTo(self.contentView.mas_top);
            make.width.mas_equalTo(acImageW);
            make.height.mas_equalTo(acImageH);
        }];
    }else
    {
        [self.acImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(rightPaddingToContentView);
            make.top.equalTo(self.contentView.mas_top);
            make.width.mas_equalTo(acImageW);
            make.height.mas_equalTo(acImageH);
        }];
    }
    //活动名约束
    CGSize maxSize = CGSizeMake(acImageW - 20, MAXFLOAT);
    CGSize acNameSize = [self sizeWithText:self.acNameLabel.text maxSize:maxSize fontSize:14];
    [self.acNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.acImageView.mas_bottom).offset(10);
        make.left.equalTo(self.acImageView.mas_left).offset(10);
        make.width.mas_equalTo(acNameSize.width +1);
        make.height.mas_equalTo(acNameSize.height+1);
    }];
    //活动时间约束
    CGSize acTimeSize = [self sizeWithText:self.acTimeLabel.text maxSize:maxSize fontSize:12];
    [self.acTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.acNameLabel.mas_bottom).offset(20);
        make.left.equalTo(self.acNameLabel.mas_left);
        make.width.mas_equalTo(acTimeSize.width+1);
        make.height.mas_equalTo(acTimeSize.height+1);
    }];
    //地点约束
    CGSize acPlaceSize = [self sizeWithText:self.acPlaceLabel.text maxSize:maxSize fontSize:12];
    [self.acPlaceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.acTimeLabel.mas_bottom);
        make.left.equalTo(self.acTimeLabel.mas_left);
        make.width.mas_equalTo(acPlaceSize.width+1);
        make.height.mas_equalTo(acPlaceSize.height+1);
    }];
    //标志图片约束
    [self.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.acPlaceLabel.mas_left);
        make.top.equalTo(self.acPlaceLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(self.tagImageView.image.size);
    }];
    //标签约束
    CGSize acTagSize = [self sizeWithText:self.acTagLabel.text maxSize:maxSize fontSize:10];
    [self.acTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagImageView.mas_right).offset(4);
        make.top.equalTo(self.tagImageView.mas_top);
        make.width.mas_equalTo(acTagSize.width+1);
        make.height.mas_equalTo(acTagSize.height+1);
    }];
    //cell的高度
    self.cellHeight = acImageH + 10 + acNameSize.height + 20 + acTimeSize.height + acPlaceSize.height + 10 + acTagSize.height + 20;
    
}
//获取当前设备
- (CurrentDevice)currentDeviceSize
{
    if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 4"] ||
        [[self getCurrentDeviceModel] isEqualToString:@"iPhone 5"])
    {
        return IPhone5;
        
    }else if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 6"])
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
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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