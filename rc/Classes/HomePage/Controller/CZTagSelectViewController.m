//
//  CZTagSelectViewController.m
//  rc
//
//  Created by AlanZhang on 16/1/22.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZTagSelectViewController.h"
#import "Masonry.h"
#import "CZTagCell.h"
#import "CZMyTagCell.h"
#include <sys/sysctl.h>

typedef NS_ENUM(NSInteger, CurrentDevice)
{
    IPhone5     = 0,    //4寸    568 X 320
    IPhone6     = 1,    //4.7寸  667 X 375
    Iphone6Plus = 2     //5.5寸  736 X 414
};
@interface CZTagSelectViewController ()

@property (nonatomic, assign) CurrentDevice device;
@property (nonatomic, strong) NSArray *tags;

@end

@implementation CZTagSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
#pragma mark - test
    self.tags = [[NSArray alloc]initWithObjects:@"创业", @"新闻",@"媒体",@"感觉",
                                                @"屁事",@"发票",@"分割",@"尼玛",nil];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉Cell之间的分割线
    //获取当前的设备
    [self currentDeviceSize];
}
- (void)currentDeviceSize
{
    if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 4"] ||
        [[self getCurrentDeviceModel] isEqualToString:@"iPhone 5"] )
    {
        self.device = IPhone5;
        
    }else if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 6"])
    {
        self.device = IPhone6;
    }else
    {
        self.device = Iphone6Plus;
    }
}
//导航栏左侧取消按钮
- (IBAction)onClickCancel:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//导航栏右侧确定按钮
- (IBAction)onClickConfirm:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZTagCell *cell = (CZTagCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.rowHeight;
}
//设置section header 高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0/2;
}
//设置section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 1)];
    view.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255  blue:245.0/255  alpha:1.0];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 40)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithRed:140.0/255.0 green:140.0/255.0  blue:140.0/255.0  alpha:1.0];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).with.offset(10);
        make.left.equalTo(view.mas_left).with.offset(10);
    }];
    
    if (0 == section)
    {
        label.text = @"我的标签";
    }
    else
    {
        label.text = @"点击添加标签";
    }
    
    return view;
}

//设置section footer高度
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
//设置section footer
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 1)];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (0 == indexPath.section)
    {//我的标签
        CZMyTagCell *cell = [CZMyTagCell initWithTableView:tableView];
        UIButton *button = [[UIButton alloc]init];
        [cell.contentView addSubview:button];
        [self setButton:button WithTittle:@"在工在在" AtCell:cell];
        
        return cell;
    }
    else
    {//点击添加标签
        CZTagCell *cell = [CZTagCell initWithTableView:tableView];
        [self setCell:cell];
        return cell;
    }

}
- (void)setCell:(CZTagCell *)cell
{
    for (int i = 0; i < self.tags.count; i++)
    {
        UIButton *btn = [[UIButton alloc]init];
        [cell.contentView addSubview:btn];
        if (self.device == IPhone5)
        {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
               
            }];
            if (i % 4 == 0)
            {
                
            }
        }else if (self.device == IPhone6)
        {
            
        }else
        {
            
        }
    }
    
}
- (void)setButton:(UIButton *)button WithTittle:(NSString *)tittle AtCell:(UITableViewCell *)cell;
{
    if ([cell isKindOfClass:[CZTagCell class]])
    {
        CZMyTagCell *myTagCell = (CZMyTagCell *)cell;
        
    }else
    {
        CZTagCell *tagCell = (CZTagCell *)cell;
        
    }

}
/**
 *  计算字符串的长度
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
