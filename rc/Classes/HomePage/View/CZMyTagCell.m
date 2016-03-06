//
//  CZMyTagCell.m
//  rc
//
//  Created by AlanZhang on 16/1/22.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZMyTagCell.h"
#import "Masonry.h"
#include <sys/sysctl.h>

@interface CZMyTagCell ()
@property (nonatomic, assign) CurrentDevice device;
@end
@implementation CZMyTagCell

+ (instancetype)initWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"CZMyTagCell";//这里的cellID就是cell的xib对应的名称,没有xib就是缓冲区的标识
    
    CZMyTagCell *cell = (CZMyTagCell *)[tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if(nil == cell)
    {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//禁用cell的点击事件
 
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.myTagButton = [[NSMutableArray alloc]init];
        self.myTags      = [[NSMutableArray alloc]init];
        self.device      = [self currentDeviceSize];
    }
    return self;
}
//1 接收数据
- (void)setMyTags:(NSMutableArray *)myTags
{
    _myTags = myTags;
    [self createButtons];
    [self setCellConstraints];
}
//2 创建button
- (void)createButtons
{
    for (int i = 0; i < self.myTags.count; i++)
    {
        UIButton *button = [[UIButton alloc]init];
       
        [self.myTagButton addObject:button];
    }
}
//3 进行布局
- (void)setCellConstraints
{
    int x = 0;
    int y = 0;
    CGFloat XPading = 0;
    CGFloat YPadding = 12;
    CGSize buttonSize = CGSizeMake(65, 30);
    for (int i = 0; i < self.myTags.count; i++)
    {
        UIButton *btn = [[UIButton alloc]init];
        [self setButton:btn WithTittle:self.myTags[i]];
        [self.contentView addSubview:btn];
        if (self.device == IPhone5)
        {
            if ((i) % 4 == 0 && i != 0 )
            {
                x = 0;
                YPadding = 12 * (y + 2) + (y+1) * 30;
                y++;
            }
            XPading = 12 * (x + 1) + x * 65;
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView.mas_left).with.offset(XPading);
                make.top.equalTo(self.contentView.mas_top).with.offset(YPadding);
                make.size.mas_equalTo(buttonSize);
            }];
            x++;
        }else if (self.device == IPhone6)
        {
            
        }else
        {
            
        }
    }
    
}
- (void)setButton:(UIButton *)button WithTittle:(NSString *)tittle
{
    [button setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:tittle forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [button.layer setCornerRadius:3];   //设置圆角
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (CurrentDevice)currentDeviceSize
{
    if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 4"] ||
        [[self getCurrentDeviceModel] isEqualToString:@"iPhone 5"] )
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

@end
