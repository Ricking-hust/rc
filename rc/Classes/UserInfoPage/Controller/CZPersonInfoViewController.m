//
//  CZPersonInfoViewController.m
//  rc
//
//  Created by AlanZhang on 16/2/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZPersonInfoViewController.h"
#import "CZPersonInfoCell.h"
#import "Masonry.h"
#import "RegisteViewController.h"
#import "LoginViewController.h"

@implementation CZPersonInfoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.navigationItem.title = @"个人资料";
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
}

- (void)backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 5;
    }else
    {
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 11)];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    CZPersonInfoCell *cell = [CZPersonInfoCell personInfoCellWithTableView:tableView];
    [self setCell:cell WithIndexPath:indexPath];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark - 单元格的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self didSelectCellAtIndexPath:indexPath];
}

- (void)didSelectCellAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                
            } else if(indexPath.row == 1){
                
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 单元格赋值

- (void)setCell:(CZPersonInfoCell *)cell WithIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0)
            {
                cell.tittle.text = @"头像";
                cell.personIcon.image = [UIImage imageNamed:[userDefaults objectForKey:@"userPic"]];
            }else if (indexPath.row == 1)
            {
                cell.tittle.text = @"昵称";
                cell.contentLabel.text = [userDefaults objectForKey:@"userName"];
            }else if (indexPath.row == 2)
            {
                cell.tittle.text = @"性别";
                cell.contentLabel.text = [userDefaults objectForKey:@"userSex"];
            }else if (indexPath.row == 3)
            {
                cell.tittle.text = @"手机";
                cell.contentLabel.text = [userDefaults objectForKey:@"userPhone"];
            }else if (indexPath.row == 4)
            {
                cell.tittle.text = @"邮箱";
                cell.contentLabel.text = [userDefaults objectForKey:@"userMail"];
            }
        }
        break;
            
        default:
        {
            cell.tittle.text = @"签名";
            cell.contentLabel.text = [userDefaults objectForKey:@"userSign"];
        }
            break;
    }
    cell.indecatorImageView.image = [UIImage imageNamed:@"nextIcon"];
    cell.contentLabel.alpha = 0.6;
    [self setCellConstraints:cell WithIndexPath:indexPath];
}

- (void)setCellConstraints:(CZPersonInfoCell *)cell WithIndexPath:(NSIndexPath *)indexPath
{
    CGSize tittleSize = [self sizeWithText:cell.tittle.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:14];
    [cell.tittle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).with.offset(10);
        make.centerY.equalTo(cell.contentView);
        make.size.mas_equalTo(CGSizeMake(tittleSize.width+1, tittleSize.height+1));
    }];
    [cell.indecatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView.mas_right).with.offset(-10);
        make.size.mas_equalTo(cell.indecatorImageView.image.size);
    }];
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row == 0)
            {
                [cell.personIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.contentView);
                    make.right.equalTo(cell.indecatorImageView.mas_left).with.offset(-5);
                    make.size.mas_equalTo(CGSizeMake(30, 30));
                }];
            }else
            {
                CGSize contentLabelSize = [self sizeWithText:cell.contentLabel.text maxSize:CGSizeMake(200, 20) fontSize:14];
                [cell.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.contentView);
                    make.right.equalTo(cell.indecatorImageView.mas_left).with.offset(-5);
                    make.size.mas_equalTo(CGSizeMake(contentLabelSize.width+1, contentLabelSize.height+1));
                }];
            }
        }
            break;
            
        default:
        {
            CGSize contentLabelSize = [self sizeWithText:cell.contentLabel.text maxSize:CGSizeMake(200, 20) fontSize:14];
            [cell.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.right.equalTo(cell.indecatorImageView.mas_left).with.offset(5);
                make.size.mas_equalTo(CGSizeMake(contentLabelSize.width+1, contentLabelSize.height+1));
            }];
        }
        break;
    }
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
