//
//  RCPersonInfoViewController.m
//  rc
//
//  Created by AlanZhang on 16/5/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCPersonInfoViewController.h"
#import "Masonry.h"
#import "DataManager.h"
#import "RCPersonCell.h"
#import "RCPersonNewsCell.h"
#import "RCNumWithLabel.h"
#import "RCTableViewCell.h"
#import "CZSettingViewController.h"
#import "RCSignupViewController.h"
#import "CZMyCollectionViewController.h"
#import "CZAboutUsViewController.h"
#import "CZFeedbackViewController.h"
#import "LoginViewController.h"
#import "CZPersonInfoViewController.h"
#import "CZMyReleseViewController.h"
#include "RCNetworkingRequestOperationManager.h"
#import "RCMyCollectionViewController.h"
#import "RCMyReleaseViewController.h"
#import "RCMyFollowTableViewController.h"
#import "RCMyFocusTableViewController.h"
//==================测试聊天=====================
#import "RCTalkTestViewController.h"

@interface RCPersonInfoViewController()
@property (nonatomic, strong) UILabel *tittleLable;
@property (nonatomic, strong) IBOutlet UIView  *tittleView;
@property (nonatomic, assign) BOOL isLogin;
@end
@implementation RCPersonInfoViewController

- (IBAction)jumpToSettingViewController:(id)sender
{
    CZSettingViewController *settingVC = [[CZSettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
    
}
#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isLogin = [DataManager manager].user.isLogin;
    if (self.isLogin == YES)
    {
        self.tittleLable.text = [userDefaults objectForKey:@"userName"];
        [self.tableView reloadData];
    }else
    {
        self.tittleLable.text = @"我的";
        [self.tableView reloadData];
    }
    CGSize size = [self sizeWithText:self.tittleLable.text maxSize:CGSizeMake(100, 35) fontSize:18];
    [self.tittleLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tittleView);
        make.height.mas_equalTo((int)size.height + 1);
        make.width.mas_equalTo((int)size.width + 1);
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *temp = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:temp];
    [self initTableView];
    [self setNavigation];

}

- (void)setNavigation
{
    self.tittleLable = [[UILabel alloc]init];
    self.tittleLable.font = [UIFont systemFontOfSize:18];
    self.tittleView .backgroundColor = [UIColor clearColor];
    [self.tittleView addSubview:self.tittleLable];

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 170;
    }else if (indexPath.row == 1)
    {
        return 55;
    }else if (indexPath.row == 2)
    {
        return 70;
    }else
    {
        return 50;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.row == 0)
    {
        RCPersonCell *cell = [[RCPersonCell alloc]init];
        [self setCellValue:cell AtIndexPath:indexPath];
        return cell;
    }else if (indexPath.row == 1)
    {
        RCPersonNewsCell *cell = [[RCPersonNewsCell alloc]init];
        [self setCellValue:cell AtIndexPath:indexPath];
        return cell;
    }else if (indexPath.row == 2)
    {
        RCTableViewCell *cell = [[RCTableViewCell alloc]init];
        cell.text_label.text = @"我的报名";
        cell.icon_imageView.image = [UIImage imageNamed:@"signup_icon_2"];
        [cell setConstraints];
        return cell;
    }else if (indexPath.row == 3)
    {
        RCTableViewCell *cell = [[RCTableViewCell alloc]init];
        cell.text_label.text = @"我的发布";
        cell.icon_imageView.image = [UIImage imageNamed:@"pencil_icon_2"];
        [cell setConstraints];
        return cell;
    }else if (indexPath.row == 4)
    {
        RCTableViewCell *cell = [[RCTableViewCell alloc]init];
        cell.text_label.text = @"我的收藏";
        cell.icon_imageView.image = [UIImage imageNamed:@"collection_icon_2"];
        [cell setConstraints];
        return cell;
    }else if (indexPath.row == 5)
    {
        RCTableViewCell *cell = [[RCTableViewCell alloc]init];
        cell.text_label.text = @"关于我们";
        cell.icon_imageView.image = [UIImage imageNamed:@"about_icon_2"];
        [cell setConstraints];
        return cell;
    }else
    {
        RCTableViewCell *cell = [[RCTableViewCell alloc]init];
        cell.text_label.text = @"建议反馈";
        cell.icon_imageView.image = [UIImage imageNamed:@"feedback_icon_2"];
        [cell setConstraints];
        return cell;
    }
    return cell;
}
/**
 *  设置单元格子控件的值并布局
 *
 *  @param cell      待设置Cell
 *  @param indexPath 待设置cell的下标
 */
- (void)setCellValue:(UITableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
         RCPersonCell *person_cell = (RCPersonCell *)cell;
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickToPersonInfo:)];
        person_cell.person_icon_imageView.userInteractionEnabled = YES;
        [person_cell.person_icon_imageView addGestureRecognizer:click];
        if (self.isLogin == YES)
        {
            person_cell.person_ID_lable.text = [userDefaults objectForKey:@"userName"];
            [person_cell.person_icon_imageView sd_setImageWithURL:[NSURL URLWithString:[userDefaults objectForKey:@"userPic"]] placeholderImage:[ UIImage imageNamed:@"20160102.png"]];
            NSString *user_sign = [userDefaults objectForKey:@"userSign"];
            if ([user_sign isEqualToString:@""] ||user_sign == nil)
            {
                person_cell.person_signature_lable.text = @"这个人很懒，什么都没有留下。";
            }else
            {
                person_cell.person_signature_lable.text = [userDefaults objectForKey:@"userSign"];
            }
            
        }
        else
        {
            person_cell.person_icon_imageView.image = [UIImage imageNamed:@"login"];
        }
        [person_cell setConstraint];
    }else if (indexPath.row == 1)
    {
        RCPersonNewsCell *person_news = (RCPersonNewsCell *)cell;
        
        if (self.isLogin == YES)
        {
            person_news.fans.numbers.text  = @"234";
            person_news.foucs.numbers.text = @"421";
            person_news.news.numbers.text  = @"100";
        }
        else
        {
            person_news.fans.numbers.text  = @"0";
            person_news.foucs.numbers.text = @"0";
            person_news.news.numbers.text  = @"0";
        }

        [person_news setConstraint];
        UITapGestureRecognizer *fans_gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickGesture:)];
        UITapGestureRecognizer *foucs_gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickGesture:)];
        UITapGestureRecognizer *news_gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickGesture:)];
        [person_news.fans addGestureRecognizer:fans_gesture];
        [person_news.foucs addGestureRecognizer:foucs_gesture];
        [person_news.news addGestureRecognizer:news_gesture];
    }
}
- (void)onClickToPersonInfo:(UITapGestureRecognizer *)click
{
    if (self.isLogin == YES)
    {
        CZPersonInfoViewController *personInfoVC = [[CZPersonInfoViewController alloc]init];
        [self.navigationController pushViewController:personInfoVC animated:YES];
    }else
    {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
#pragma mark - 获取粉丝，关注，消息
/**
 *  10表示点击的是粉丝
 *  11表示点击的是关注
 *  12表示点击的是消息
 */
- (void)onClickGesture:(UITapGestureRecognizer *)click
{
    if (self.isLogin == YES)
    {
        UIView *view = click.view;
        if (view.tag == 10)
        {
            [self getFans];
        }else if (view.tag == 11)
        {
            [self getFocus];
        }else
        {
            [self getNews];
        }
    }
    else
    {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }

}
#pragma mark - 获取我的消息
- (void) getNews
{
    RCTalkTestViewController *vc = [[RCTalkTestViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 获取我的粉丝
- (void) getFans
{
    RCMyFollowTableViewController *followTC = [[RCMyFollowTableViewController alloc]init];
    [self.navigationController pushViewController:followTC animated:YES];
    
}
#pragma mark - 获取我的关注
- (void) getFocus
{
    RCMyFocusTableViewController *focusTC = [[RCMyFocusTableViewController alloc]init];
    [self.navigationController pushViewController:focusTC animated:YES];
}
#pragma mark - 单元格的点击事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isLogin)
    {
        if (indexPath.row == 0)
        {
           
        }else if (indexPath.row == 1)
        {
            ;
//            RCTalkTestViewController *vc = [[RCTalkTestViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.row == 2)
        {//我的报名
            RCSignupViewController *signupVC = [[RCSignupViewController alloc]init];
            [self.navigationController pushViewController:signupVC animated:YES];
        }else if (indexPath.row == 3)
        {//我的发布
            //CZMyReleseViewController *releaseVC = [[CZMyReleseViewController alloc]init];
            RCMyReleaseViewController *releaseVC = [[RCMyReleaseViewController alloc]init];
            [self.navigationController pushViewController:releaseVC animated:YES];
        }else if (indexPath.row == 4)
        {//我的收藏
           // CZMyCollectionViewController *collectionVC = [[CZMyCollectionViewController alloc]init];
            RCMyCollectionViewController *collectionVC = [[RCMyCollectionViewController alloc]init];
            [self.navigationController pushViewController:collectionVC animated:YES];
        }else if (indexPath.row == 5)
        {//关于我们
            CZAboutUsViewController *aboutUS = [[CZAboutUsViewController alloc]init];
            [self.navigationController pushViewController:aboutUS animated:YES];
        }else
        {//建议反馈
            CZFeedbackViewController *feedbackVC = [[CZFeedbackViewController alloc]init];
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }

    }else
    {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}
- (void)initTableView
{
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.right.left.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-49);
    }];
}
//- (UITableView *)tableView
//{
//    if (!_tableView)
//    {
//        _tableView = [[UITableView alloc]init];
//        _tableView.backgroundColor = [UIColor clearColor];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.dataSource = self;
//        _tableView.delegate = self;
//        [self.view addSubview:_tableView];
//        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view.mas_top).offset(64);
//            make.right.left.equalTo(self.view);
//            make.bottom.equalTo(self.view).offset(-49);
//        }];
//        
//    }
//    return _tableView;
//}
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
