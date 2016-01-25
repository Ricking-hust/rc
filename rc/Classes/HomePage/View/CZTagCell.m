//
//  CZTagCell.m
//  rc
//
//  Created by AlanZhang on 16/1/22.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZTagCell.h"
#import "Masonry.h"
#include <sys/sysctl.h>

@implementation CZTagCell

+ (instancetype)initWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"CZTagCell";//这里的cellID就是cell的xib对应的名称
    
    CZTagCell *cell = (CZTagCell *)[tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if(nil == cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    //设置行高
    cell.rowHeight = 200;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//禁用cell的点击事件
    return cell;
}
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubView];
        [self setSubView];
    }
    return self;
}
- (void)createSubView
{
    //创建按钮--创业者
    self.bStartupBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.bStartupBtn setTitle:@"创业者" forState:UIControlStateNormal];
    [self.contentView addSubview:self.bStartupBtn];
    
    //创建按钮--白领
    self.whiteCollarBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.whiteCollarBtn setTitle:@"白领" forState:UIControlStateNormal];
    [self.contentView addSubview:self.whiteCollarBtn];
    
    //创建按钮--清华讲座
    self.tsinghuaLectureBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.tsinghuaLectureBtn setTitle:@"清华讲座" forState:UIControlStateNormal];
    [self.contentView addSubview:self.tsinghuaLectureBtn];
    
    //创建按钮--科技
    self.technologyBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.technologyBtn setTitle:@"科技" forState:UIControlStateNormal];
    [self.contentView addSubview:self.technologyBtn];
    
    //创建按钮--沙龙
    self.salonBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.salonBtn setTitle:@"沙龙" forState:UIControlStateNormal];
    [self.contentView addSubview:self.salonBtn];
    
    //创建按钮--高层
    self.highriseBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.highriseBtn setTitle:@"高层" forState:UIControlStateNormal];
    [self.contentView addSubview:self.highriseBtn];
    //创建按钮--讲座
    self.lectureBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.lectureBtn setTitle:@"讲座" forState:UIControlStateNormal];
    [self.contentView addSubview:self.lectureBtn];
    
    //创建按钮--论坛
    self.forumBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.forumBtn setTitle:@"论坛" forState:UIControlStateNormal];
    [self.contentView addSubview:self.forumBtn];
    //创建按钮--金融
    self.financeBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [self.financeBtn setTitle:@"金融" forState:UIControlStateNormal];
    [self.contentView addSubview:self.financeBtn];
    
}

//设置按钮的约束
- (void) setSubView
{
    CGSize size = CGSizeMake(140/2, 60/2);
    if ([[self getCurrentDeviceModel:self]isEqualToString:@"iPhone 4"] ||
        [[self getCurrentDeviceModel:self]isEqualToString:@"iPhone 5"] ||
        [[self getCurrentDeviceModel:self]isEqualToString:@"iPhone Simulator"])
    {
        [self.bStartupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(15);
            make.top.equalTo(self.contentView.mas_top).with.offset(15);
            make.size.mas_equalTo(size);
        }];
        [self.tsinghuaLectureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bStartupBtn.mas_right).with.offset(30);
            make.top.equalTo(self.bStartupBtn.mas_top);
            make.size.mas_equalTo(size);
        }];
        [self.whiteCollarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tsinghuaLectureBtn.mas_right).with.offset(30);
            make.top.equalTo(self.bStartupBtn.mas_top);
            make.size.mas_equalTo(size);
        }];
        [self.technologyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bStartupBtn.mas_left);
            make.top.equalTo(self.bStartupBtn.mas_bottom).with.offset(30.0 / 2);
            make.size.mas_equalTo(size);
        }];
        [self.salonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.technologyBtn.mas_right).with.offset(30);
            make.top.equalTo(self.technologyBtn.mas_top);
            make.size.mas_equalTo(size);
        }];
        [self.highriseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.salonBtn.mas_right).with.offset(30);
            make.top.equalTo(self.technologyBtn.mas_top);
            make.size.mas_equalTo(size);
        }];
        [self.lectureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bStartupBtn.mas_left);
            make.top.equalTo(self.technologyBtn.mas_bottom).with.offset(30.0 / 2);
            make.size.mas_equalTo(size);
        }];
        [self.forumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lectureBtn.mas_right).with.offset(30);
            make.top.equalTo(self.lectureBtn.mas_top);
            make.size.mas_equalTo(size);
        }];
        [self.financeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.forumBtn.mas_right).with.offset(30);
            make.top.equalTo(self.lectureBtn.mas_top);
            make.size.mas_equalTo(size);
        }];

    }else
    {
        [self.bStartupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(15);
            make.top.equalTo(self.contentView.mas_top).with.offset(30.0 / 2);
            make.size.mas_equalTo(size);
        }];
        [self.tsinghuaLectureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.whiteCollarBtn.mas_right).with.offset(42.0 / 2);
            make.top.equalTo(self.contentView.mas_top).with.offset(30.0 / 2);
            make.size.mas_equalTo(size);
        }];
        [self.whiteCollarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bStartupBtn.mas_right).with.offset(42.0 / 2);
            make.top.equalTo(self.contentView.mas_top).with.offset(30.0 / 2);
            make.size.mas_equalTo(size);
        }];
        [self.technologyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.tsinghuaLectureBtn.mas_right).with.offset(42.0 / 2);
            make.top.equalTo(self.contentView.mas_top).with.offset(30.0 / 2);
            make.size.mas_equalTo(size);
        }];
        [self.salonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(15);
            make.top.equalTo(self.bStartupBtn.mas_bottom).with.offset(30.0 / 2);
            make.size.mas_equalTo(size);
        }];
        [self.highriseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.salonBtn.mas_right).with.offset(42.0 / 2);
            make.top.equalTo(self.whiteCollarBtn.mas_bottom).with.offset(30.0 / 2);
            make.size.mas_equalTo(size);
        }];
        [self.lectureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.highriseBtn.mas_right).with.offset(42.0 / 2);
            make.top.equalTo(self.tsinghuaLectureBtn.mas_bottom).with.offset(30.0 / 2);
            make.size.mas_equalTo(size);
        }];
        [self.forumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.lectureBtn.mas_right).with.offset(42.0 / 2);
            make.top.equalTo(self.technologyBtn.mas_bottom).with.offset(30.0 / 2);
            make.size.mas_equalTo(size);
        }];
        [self.financeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(15);
            make.top.equalTo(self.salonBtn.mas_bottom).with.offset(30.0 / 2);
            make.size.mas_equalTo(size);
        }];
    }
    //设置按钮的样式
    [self setStyleOfButton:self.bStartupBtn];
    [self setStyleOfButton:self.whiteCollarBtn];
    [self setStyleOfButton:self.tsinghuaLectureBtn];
    [self setStyleOfButton:self.technologyBtn];
    [self setStyleOfButton:self.salonBtn];
    [self setStyleOfButton:self.highriseBtn];
    [self setStyleOfButton:self.lectureBtn];
    [self setStyleOfButton:self.forumBtn];
    [self setStyleOfButton:self.financeBtn];

}
- (void)setStyleOfButton:(UIButton *)btn
{
    [btn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [btn.layer setCornerRadius:3];
    [btn.layer setBorderWidth:1];//设置边界的宽度
    
    //设置按钮的边界颜色
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){38/255 ,40/255,50/255,0.8});
    [btn.layer setBorderColor:color];
    [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //设置字体样式
    [btn setTitleColor:[UIColor colorWithRed:38/255 green:40/255 blue:50/255 alpha:0.8] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
}
//获得设备型号
- (NSString *)getCurrentDeviceModel:(CZTagCell *)cell
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

- (void)onClick:(UIButton *)btn
{
    NSLog(@"%ld", btn.tag);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
