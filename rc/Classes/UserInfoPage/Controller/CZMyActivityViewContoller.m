//
//  CZMyActivityViewContoller.m
//  rc
//
//  Created by AlanZhang on 16/2/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZMyActivityViewContoller.h"
#import "RCMyActivityCell.h"
#import "Activity.h"

@interface CZMyActivityViewContoller()

@property(nonatomic, strong) NSMutableArray *activity;

@end

//@property(nonatomic, strong) NSMutableArray *activity;

@implementation CZMyActivityViewContoller


/**
 *  对象方法,模拟从服务器取得数据
 *
 *  @return 返回实例对象
 */
- (void) getActivityFromServer
{
    self.activity = [NSMutableArray array];
    
    Activity *activity = [Activity activity];
    activity.ac_id = 11111;
    activity.ac_poster = @"img_4";
    activity.ac_title = @"2015年沸雪北京世界单板滑雪赛与现场音乐会";
    activity.ac_time = @"时间：2015.1.1 14:00 AM";
    activity.ac_place = @"地点：光谷体育馆";
    activity.ac_tags = @"相亲 单身";
    activity.ac_collect_num = 11111;
    activity.ac_praise_num = 22222;
    activity.ac_read_num = 33333;
    [self.activity addObject:activity];
    
    Activity *activity2 = [Activity activity];
    [activity2 setSubViewsContent];
    [self.activity addObject:activity2];
    
    Activity *activity3 = [Activity activity];
    activity3.ac_id = 11111;
    
    activity3.ac_poster = @"img_2";
    activity3.ac_title = @"2015年沸雪北京世界单板滑雪赛与现场音乐会";
    activity3.ac_time = @"时间：2015.1.1 14:00 AM";
    activity3.ac_place = @"地点：光谷体育馆";
    activity3.ac_tags = @"相亲 单身";
    activity3.ac_collect_num = 11111;
    activity3.ac_praise_num = 22222;
    activity3.ac_read_num = 33333;
    [self.activity addObject:activity3];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    //模拟从服务器取得数据
    [self getActivityFromServer];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setNavigation];
}
- (void)setNavigation
{
    self.navigationItem.title = @"我的活动";
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
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.activity.count;
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"myActivity";
    RCMyActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell)
    {
        cell = [[RCMyActivityCell alloc]init];
    }
    //对cell赋值
    [self setValueOfCell:cell AtIndexPath:indexPath];
    //对cell布局
    [cell setSubViewConstraint];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCMyActivityCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.rowHeight;
    
}
- (void)setValueOfCell:(RCMyActivityCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    Activity *ac = self.activity[indexPath.section];
    cell.acImageView.image = [UIImage imageNamed:ac.ac_poster];
    cell.acName.text = ac.ac_title;
    cell.acTime.text = ac.ac_time;
    cell.acPlace.text = ac.ac_place;
    cell.acTag.text = ac.ac_tags;
}
@end
