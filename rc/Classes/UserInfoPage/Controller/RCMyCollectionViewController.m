//
//  RCMyCollectionViewController.m
//  rc
//
//  Created by AlanZhang on 16/5/21.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCMyCollectionViewController.h"
#import "CZActivityInfoViewController.h"
#import "RCNetworkingRequestOperationManager.h"
#import "UserActivity.h"
#import "RCMyActivityCell.h"
#import "ActivityModel.h"
#import "RCHomeRefreshHeader.h"
#import "UINavigationBar+Awesome.h"
#import "MJRefresh.h"
#import "Masonry.h"
@interface RCMyCollectionViewController ()
@property (nonatomic, strong) NSMutableArray *acList;
@property (nonatomic, strong) UIView  *heartBrokenView;
@end

@implementation RCMyCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigation];
    [self initTableView];
    //发出网络请求
    self.acList = [[NSMutableArray alloc]init];
    [self sendURLRequest];
    self.tableView.mj_header = [RCHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer= [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - 下拉刷新
- (void)loadNewData
{
    [self.acList removeAllObjects];
    [self sendURLRequest];
    [self.tableView.mj_header endRefreshing];
}
-(void)getMoreData
{
    NSMutableArray __block *moreActivity = [[NSMutableArray alloc]initWithArray:self.acList];
    
    NSString *urlStr = @"http://app.myrichang.com/home/Person/getUserActivity";
    NetWorkingRequestType type = GET;
    NSString *usr_id = [userDefaults objectForKey:@"userId"];
    UserActivity *lastActivity = self.acList.lastObject;
    NSString *start_id = lastActivity.ac_id;

    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:usr_id,@"usr_id",@"2",@"op_type",start_id,@"start_id",nil];
    [RCNetworkingRequestOperationManager request:urlStr requestType:type parameters:parameters completeBlock:^(NSData *data) {
        id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSMutableArray *temp = [self initacListWithDict:dict];
        if (temp == nil)
        {
            [self.tableView.mj_footer endRefreshing];
        }else
        {
            for (UserActivity *ac in temp)
            {
                [moreActivity addObject:ac];
            }
            self.acList = [[NSMutableArray alloc]initWithArray:moreActivity];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"请求失败:%@",error);
        [self.tableView.mj_footer endRefreshing];
    }];

}
- (void)sendURLRequest
{
    NSString *urlStr = @"http://app.myrichang.com/home/Person/getUserActivity";
    NetWorkingRequestType type = GET;
    NSString *usr_id = [userDefaults objectForKey:@"userId"];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:usr_id,@"usr_id",@"2",@"op_type",nil];
    [RCNetworkingRequestOperationManager request:urlStr requestType:type parameters:parameters completeBlock:^(NSData *data) {
        id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSMutableArray *temp = [self initacListWithDict:dict];
        if (temp != nil)
        {
            self.acList = [[NSMutableArray alloc]initWithArray:temp];
        }
    } errorBlock:^(NSError *error) {
        NSLog(@"请求失败:%@",error);
    }];
}
- (NSMutableArray *)initacListWithDict:(NSDictionary *)dict
{
    NSNumber *code = [dict valueForKey:@"code"];
    if ([code isEqualToNumber:[[NSNumber alloc]initWithInt:200]])
    {//返回正确的数据

        NSMutableArray *temp = [[NSMutableArray alloc]init];
        NSArray *data = [dict valueForKey:@"data"];
        for (NSDictionary *dic in data)
        {
            
            [temp addObject:[self userActivityfromDict:dic]];
        }
        return temp;
    }else if ([code isEqualToNumber:[[NSNumber alloc]initWithInt:220]])
    {//返回失败:操作类型无效或用户ID为空
        NSLog(@"我的收藏:%@",[dict valueForKey:@"msg"]);
        return nil;
    }else
    {
        NSLog(@"发生未知错误");
        return nil;
    }
    
}
- (UserActivity *)userActivityfromDict:(NSDictionary *)dict
{
    UserActivity *usr_ac = [[UserActivity alloc]init];
    usr_ac.ac_id = [dict valueForKey:@"ac_id"];
    usr_ac.ac_title = [dict valueForKey:@"ac_title"];
    usr_ac.ac_poster = [dict valueForKey:@"ac_poster"];
    usr_ac.ac_poster_top = [dict valueForKey:@"ac_poster_top"];
    usr_ac.ac_desc = [dict valueForKey:@"ac_desc"];
    usr_ac.theme_name = [dict valueForKey:@"theme_name"];
    usr_ac.ac_time = [dict valueForKey:@"ac_time"];
    usr_ac.ac_sustain_time = [dict valueForKey:@"ac_sustain_time"];
    usr_ac.ac_place = [dict valueForKey:@"ac_place"];
    usr_ac.ac_size = [dict valueForKey:@"ac_size"];
    usr_ac.ac_pay = [dict valueForKey:@"ac_pay"];
    usr_ac.usr_id = [dict valueForKey:@"usr_id"];
    usr_ac.ac_type = [dict valueForKey:@"ac_type"];
    usr_ac.usr_pic = [dict valueForKey:@"usr_pic"];
    usr_ac.usr_name = [dict valueForKey:@"usr_name"];
    usr_ac.ac_tags = [dict valueForKey:@"ac_tags"];
    
    return usr_ac;
}
- (void)setAcList:(NSMutableArray *)acList
{
    _acList = acList;
    if ([_acList count] != 0)
    {
        self.tableView.hidden = NO;
        [self.tableView reloadData];
        self.heartBrokenView.hidden = YES;
    }else
    {
        self.tableView.hidden = YES;
        self.heartBrokenView.hidden = NO;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.acList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCMyActivityCell *cell = [RCMyActivityCell cellWithTableView:tableView];
    [self setValueOfCell:cell AtIndexPath:indexPath];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
#pragma mark - cell的点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZActivityInfoViewController *ac = [[CZActivityInfoViewController alloc]init];
    
    ac.activityModelPre = [self activityModeFromUserActivity:self.acList[indexPath.section]];
    [self.navigationController pushViewController:ac animated:YES];
}
- (ActivityModel *)activityModeFromUserActivity:(UserActivity *)userActivity
{
    ActivityModel *model = [[ActivityModel alloc]init];
    
    model.acID = userActivity.ac_id;
    model.acPoster = userActivity.ac_poster;
    model.acPosterTop = userActivity.ac_poster_top;
    model.acTitle = userActivity.ac_title;
    model.acTime = userActivity.ac_time;
    model.acTheme = userActivity.theme_name;
    model.acPlace = userActivity.ac_place;
    model.acCollectNum = @"zhangdy";
    model.acSize = userActivity.ac_size;
    model.acPay = userActivity.ac_pay;
    model.acDesc = userActivity.ac_desc;
    model.acReview = @"";
    model.acStatus = @"";
    model.acPraiseNum = @"";
    model.acReadNum = @"";
    model.acHtml = @"";
    model.acCollectNum = @"";
    model.plan = @"";
    model.planId = @"";
    model.userInfo.userId = userActivity.usr_id;
    model.userInfo.userName = userActivity.usr_name;
    model.userInfo.userPic = userActivity.usr_pic;
    model.tagsList.list = [[NSMutableArray alloc]initWithArray:userActivity.ac_tags];
    
    return model;
}
//给单元格进行赋值
- (void)setValueOfCell:(RCMyActivityCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    [cell.addSchedule setTitle:@"加入行程" forState:UIControlStateNormal];
    UserActivity *user_ac = self.acList[indexPath.section];
    cell.acName.text = user_ac.ac_title;
    cell.acTime.text = user_ac.ac_title;
    cell.acPlace.text = user_ac.ac_place;
    NSArray *tagArray = [[NSArray alloc]initWithArray:user_ac.ac_tags];
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in tagArray)
    {
        NSString *tag_name = [dict valueForKey:@"tag_name"];
        [temp addObject:tag_name];
    }

    NSString *tagString = [temp componentsJoinedByString:@","];
    cell.acTag.text = tagString;
    [cell.acImageView sd_setImageWithURL:[NSURL URLWithString:user_ac.ac_poster] placeholderImage:[UIImage imageNamed:@"img_1"]];
    [cell.addSchedule addTarget:self action:@selector(addToSchedule:) forControlEvents:UIControlEventTouchDown];
    [cell setSubViewConstraint];
}
#pragma mark - 加入行程
- (void)addToSchedule:(UIButton *)button
{
    NSLog(@"还没做");
}
#pragma mark - 设置标题栏

- (void)setNavigation
{
    self.navigationItem.title = @"我的收藏";
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
}
- (void)backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initTableView
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    UIView *temp = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:temp];//用于消除导航栏对tableView布局的影响
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.right.left.bottom.equalTo(self.view);
    }];
}
- (UIView *)heartBrokenView
{
    if (!_heartBrokenView)
    {
        _heartBrokenView = [[UIView alloc]init];
        [self.view addSubview:_heartBrokenView];
        UIImageView *imgeView = [[UIImageView alloc]init];
        imgeView.image = [UIImage imageNamed:@"heartbrokenIcon"];
        [_heartBrokenView addSubview:imgeView];
        
        [imgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_heartBrokenView.mas_centerX);
            make.top.equalTo(_heartBrokenView.mas_top);
            make.size.mas_equalTo(imgeView.image.size);
        }];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"您还没有收藏活动哟。";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
        [_heartBrokenView addSubview:label];
        CGSize labelSize = [self sizeWithText:label.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:14];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgeView.mas_bottom).offset(10);
            make.centerX.equalTo(imgeView.mas_centerX).offset(10);
            make.width.mas_equalTo(labelSize.width+1);
            make.height.mas_equalTo(labelSize.height+1);
        }];
        [_heartBrokenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view);
            make.height.mas_equalTo(imgeView.image.size.height+labelSize.height+1+10);
            make.width.mas_equalTo(imgeView.image.size.width>labelSize.width?imgeView.image.size.width:labelSize.width+1);
        }];
        
    }
    return _heartBrokenView;
}
/**
 *  计算文本的大小
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
