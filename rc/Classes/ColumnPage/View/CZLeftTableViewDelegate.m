 //
//  CZLeftTableViewDelegate.m
//  rc
//
//  Created by AlanZhang on 16/3/10.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZLeftTableViewDelegate.h"
#import "RCLeftTableView.h"
#import "RCRightTableView.h"
#import "CZColumnCell.h"
#import "ActivityModel.h"
#import "CZActivityInfoViewController.h"
#include <sys/sysctl.h>
#define NAME_FONTSIZE 14
#define TIME_FONTSIZE 12
#define PLACE_FONTSIZE 12
#define TAG_FONTSIZE  11
@implementation CZLeftTableViewDelegate
- (id)init
{
    if (self = [super init])
    {
        self.leftTableView = [[RCLeftTableView alloc]init];
        self.rightTableView = [[RCRightTableView alloc]init];
        self.array = [[NSMutableArray alloc]init];
        self.view  = [[UIView alloc]init];
    }
    return self;
}
- (void)setArray:(NSMutableArray *)array
{
    _array = array;
    [self.leftTableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityModel *model = self.array[indexPath.row];
    if ([model.planId isEqualToString:@"null"])
    {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        

    }else
    {

        //1 创建可重用的自定义cell
        CZColumnCell *cell = [CZColumnCell cellWithTableView:tableView];
        //CZColumnCell *cell = [[CZColumnCell alloc]init];
        cell.isLeft = YES;
        
        //对cell内的控件进行赋值
        [self setCellValue:cell AtIndexPath:indexPath];
        //对cell内的控件进行布局
        [cell setSubviewConstraint];
        return cell;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityModel *model = self.array[indexPath.row];
    if ([model.planId isEqualToString:@"null"])
    {
        return self.subHeight;
    }else
    {
        CGFloat height = [self contacterTableCell:self.array[indexPath.row]];
        return height;
    }
}
- (CGFloat)contacterTableCell:(ActivityModel *)model
{
    CGFloat acImageW; //图片的最大宽度,活动名的最大宽度
    CGFloat acImageH; //图片的最大高度
    CGFloat leftPaddintToContentView;
    CGFloat rightPaddingToContentView;
    if ([self currentDeviceSize] == IPhone5)
    {
        acImageW = 142;
        acImageH = 110;
        leftPaddintToContentView = 12;
        rightPaddingToContentView = leftPaddintToContentView;
        
    }else if ([self currentDeviceSize]  == IPhone6)
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
    CGSize maxSize = CGSizeMake(acImageW - 20, MAXFLOAT);
    CGSize acNameSize = [self sizeWithText:model.acTitle maxSize:maxSize fontSize:NAME_FONTSIZE];
    CGSize acTimeSize = [self sizeWithText:model.acTime maxSize:maxSize fontSize:TIME_FONTSIZE];
    CGSize acPlaceSize = [self sizeWithText:model.acPlace maxSize:maxSize fontSize:PLACE_FONTSIZE];
    CGSize acTagSize = [self sizeWithText:@"发布者死哪去了" maxSize:maxSize fontSize:TAG_FONTSIZE];
    return acImageH + 10 + acNameSize.height + 10 + acTimeSize.height + acPlaceSize.height + 10 + acTagSize.height+10;
}
//给单元格进行赋值
- (void) setCellValue:(CZColumnCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    cell.bgView.tag = indexPath.row;
    
    ActivityModel *model = self.array[indexPath.row];
    [cell.acImageView sd_setImageWithURL:[NSURL URLWithString:model.acPoster] placeholderImage:[UIImage imageNamed:@"20160102.png"]];
    cell.acNameLabel.text = model.acTitle;
    int len = (int)[model.acTime length];
    NSString *timeStr = [model.acTime substringWithRange:NSMakeRange(0, len - 3)];
    cell.acTimeLabel.text = timeStr;
    cell.acPlaceLabel.text = model.acPlace;

    cell.acTagLabel.text = @"发布者死哪去了";
    
    //添加手势
    UITapGestureRecognizer *clickGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayInfo:)];
    [cell.bgView addGestureRecognizer:clickGesture];
}

- (void)displayInfo:(UITapGestureRecognizer *)gesture
{
    UIView *view = gesture.view;
    CZActivityInfoViewController *info = [[CZActivityInfoViewController alloc]init];
    info.title = @"活动介绍";
    info.activityModelPre = self.array[view.tag];
//    UIViewController *vc = [[UIViewController alloc]init];
//    vc.view.backgroundColor = [UIColor whiteColor];

    [[self viewController].navigationController pushViewController:info animated:YES];
}
- (UIViewController *)viewController
{
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    return nil;
}

- (UIResponder *)nextResponder
{
    [super nextResponder];
    return self.view;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.rightTableView setContentOffset:self.leftTableView.contentOffset];
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

//获取当前设备
- (CurrentDevice)currentDeviceSize
{
    if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 4"] ||
        [[self getCurrentDeviceModel] isEqualToString:@"iPhone 5"])
    {
        return IPhone5;
        
    }else if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 6"] ||
              [[self getCurrentDeviceModel] isEqualToString:@"iPhone Simulator"])
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
