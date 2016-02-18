//
//  MyInfoViewController.m
//  日常
//
//  Created by AlanZhang on 15/12/19.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import "CZMyInfoViewController.h"
#import "CZMyInfoCell.h"
#import "Masonry.h"
#import "CZPersonInfoViewController.h"
#import "CZMyActivityViewContoller.h"
#import "CZMyReleseViewController.h"
#import "CZMyCollectionViewController.h"
#import "CZAboutUsViewController.h"
#import "CZFeedbackViewController.h"
#import "CZSettingViewController.h"

@interface CZMyInfoViewController ()

@end

@implementation CZMyInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
}
- (void)back
{
    
    NSLog(@"back button");
}


- (void)showBar
{
    
}
//设置按钮点击事件
- (IBAction)settingBtn:(id)sender
{
    
    CZSettingViewController *settingViewController = [[CZSettingViewController alloc]init];
    [self.navigationController pushViewController:settingViewController animated:YES];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

   
    if (section == 0)
    {
        return 1;
    }else if (section == 1)
    {
        return 3;
    }else
    {
         return 2;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZMyInfoCell *cell = [CZMyInfoCell myInfoCellWithTableView:tableView];
    [self setCell:cell WithIndexPath:indexPath];
    return cell;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return [[UIScreen mainScreen]bounds].size.width * 0.21;
    }else
    {
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - 单元格的点击事件

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self didSelectCellAtIndexPath:indexPath];

}
- (void)didSelectCellAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            CZPersonInfoViewController *personInfoViewController = [[CZPersonInfoViewController alloc]init];
            [self.navigationController pushViewController:personInfoViewController animated:YES];
        }
        break;
            
        case 1:
        {
            if (indexPath.row == 0)
            {
                CZMyActivityViewContoller *myActivityViewController = [[CZMyActivityViewContoller alloc]init];
                [self.navigationController pushViewController:myActivityViewController animated:YES];
            }else if (indexPath.row == 1)
            {
                CZMyReleseViewController *myReleseViewController = [[CZMyReleseViewController alloc]init];
                [self.navigationController pushViewController:myReleseViewController animated:YES];
            }else
            {
                CZMyCollectionViewController *myCollectionViewController = [[CZMyCollectionViewController alloc]init];
                [self.navigationController pushViewController:myCollectionViewController animated:YES];
            }
        }
        break;
        default:
        {
            if (indexPath.row == 0)
            {
                CZAboutUsViewController *aboutUsViewController = [[CZAboutUsViewController alloc]init];
                [self.navigationController pushViewController:aboutUsViewController animated:YES];
            }else
            {
                CZFeedbackViewController *feedbackViewController = [[CZFeedbackViewController alloc]init];
                [self.navigationController pushViewController:feedbackViewController animated:YES];
            }
        }
        break;
    }
}
- (void)setCell:(CZMyInfoCell *)cell WithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        cell.imgIcon.image = [UIImage imageNamed:@"city_1"];
        cell.contentLable.text = @"完美文筱";

    }else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            cell.imgIcon.image = [UIImage imageNamed:@"addIcon"];
            cell.contentLable.text = @"我的活动";
        }else if (indexPath.row == 1)
        {
            cell.imgIcon.image = [UIImage imageNamed:@"addIcon"];
            cell.contentLable.text = @"我的发布";
        }else
        {
            cell.imgIcon.image = [UIImage imageNamed:@"addIcon"];
            cell.contentLable.text = @"我的收藏";
        }

    }else
    {
        if (indexPath.row == 0)
        {
            cell.imgIcon.image = [UIImage imageNamed:@"addIcon"];
            cell.contentLable.text = @"关于我们";
        }else
        {
            cell.imgIcon.image = [UIImage imageNamed:@"addIcon"];
            cell.contentLable.text = @"建议反馈";
        }
        
    }
    cell.indicatorImageView.image = [UIImage imageNamed:@"nextIcon"];
    [self setCellConstraints:cell];
}

- (void)setCellConstraints:(CZMyInfoCell *)cell
{
    [cell.imgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).with.offset(10);
        make.centerY.equalTo(cell.contentView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    CGSize contentLableSize = [self sizeWithText:cell.contentLable.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:14];
    [cell.contentLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.imgIcon.mas_right).with.offset(15);
        make.centerY.equalTo(cell.contentView);
        make.size.mas_equalTo(CGSizeMake(contentLableSize.width+1, contentLableSize.height+1));
    }];
    [cell.indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView.mas_right).with.offset(-10);
        make.size.mas_equalTo(cell.indicatorImageView.image.size);
    }];
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