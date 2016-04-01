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
#import "LoginViewController.h"
#import "DataManager.h"

@interface CZMyInfoViewController ()

@end

@implementation CZMyInfoViewController


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.isLogin = [DataManager manager].user.isLogin;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isLogin = [DataManager manager].user.isLogin;
    
    [self.tableView reloadData];
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
        return 88;
    }else
    {
        return 47;
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
    if (self.isLogin == NO)
    {//如果用户未登录，则跳至登录界面
        //to do here ------------------------

        LoginViewController *loginViewController = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginViewController animated:YES];
        
    }else
    {//如果用户已登录，则跳至相关界面
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
}
- (void)setCell:(CZMyInfoCell *)cell WithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (self.isLogin == NO) {
            cell.imgIcon.image = [UIImage imageNamed:@"logo"];
            cell.imgIcon.layer.cornerRadius=33;
            cell.imgIcon.layer.masksToBounds = YES;
            cell.contentLable.text = @"未登录";
        } else {
            [cell.imgIcon sd_setImageWithURL:[NSURL URLWithString:[userDefaults objectForKey:@"userPic"]] placeholderImage:[ UIImage imageNamed:@"20160102.png"]];
            cell.imgIcon.layer.masksToBounds = YES;
            cell.imgIcon.layer.cornerRadius=33;
            cell.contentLable.text = [userDefaults objectForKey:@"userName"];
        }

    }else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            cell.imgIcon.image = [UIImage imageNamed:@"activity_icon"];
            cell.contentLable.text = @"我的活动";
        }else if (indexPath.row == 1)
        {
            cell.imgIcon.image = [UIImage imageNamed:@"pencil_icon"];
            cell.contentLable.text = @"我的发布";
        }else
        {
            cell.imgIcon.image = [UIImage imageNamed:@"collection_icon"];
            cell.contentLable.text = @"我的收藏";
        }

    }else
    {
        if (indexPath.row == 0)
        {
            cell.imgIcon.image = [UIImage imageNamed:@"about_icon"];
            cell.contentLable.text = @"关于我们";
        }else
        {
            cell.imgIcon.image = [UIImage imageNamed:@"feedback_icon"];
            cell.contentLable.text = @"建议反馈";
        }
        
    }
    cell.indicatorImageView.image = [UIImage imageNamed:@"nextIcon"];
    [self setCellConstraints:cell WithIndexPath:indexPath];
}

- (void)setCellConstraints:(CZMyInfoCell *)cell WithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [cell.imgIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).with.offset(10);
            make.centerY.equalTo(cell.contentView);
            make.size.mas_equalTo(CGSizeMake(66, 66));
        }];
    }else
    {
        [cell.imgIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).with.offset(10);
            make.centerY.equalTo(cell.contentView);
            make.size.mas_equalTo(cell.imgIcon.image.size);
        }];
    }
    

    CGSize contentLableSize = [self sizeWithText:cell.contentLable.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:14];
    [cell.contentLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.imgIcon.mas_right).with.offset(15);
        make.centerY.equalTo(cell.contentView);
        make.size.mas_equalTo(CGSizeMake(contentLableSize.width+200, contentLableSize.height+1));
    }];
    [cell.indicatorImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView.mas_right).with.offset(-10);
        make.size.mas_equalTo(cell.indicatorImageView.image.size);
    }];
    if (indexPath.section == 0)
    {

    }else if (indexPath.section == 1)
    {
        if (indexPath.row == 0 || indexPath.row == 1)
        {
            cell.separator.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0];

            [cell.separator mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.imgIcon.mas_left);
                make.right.equalTo(cell.indicatorImageView.mas_right);
                make.bottom.equalTo(cell.contentView.mas_bottom);
                make.height.mas_equalTo(0.5);
            }];
        }
    }else
    {
        if (indexPath.row == 0)
        {
            cell.separator.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0];
            [cell.separator mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.imgIcon.mas_left);
                make.right.equalTo(cell.indicatorImageView.mas_right);
                make.bottom.equalTo(cell.contentView.mas_bottom);
                make.height.mas_equalTo(0.5);
            }];
        }
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
