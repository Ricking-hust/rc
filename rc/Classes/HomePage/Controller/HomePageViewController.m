//
//  HomePageViewController.m
//  日常
//
//  Created by AlanZhang on 16/1/7.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//
#import "CZActivityInfoViewController.h"

#import "HomePageViewController.h"

#import "HomeHeaderView.h"

#import "Activitycell.h"

#import "Activity.h"


@interface HomePageViewController ()

@property(nonatomic, strong) NSMutableArray *activity;

@end

@implementation HomePageViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置tableHeaderView
    HomeHeaderView *headerView = [HomeHeaderView headerView];
    [headerView setView];
    self.tableView.tableHeaderView = headerView;
    
//    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSLog(@"%@", doc);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.activity.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //1 创建可重用的自定义cell
    Activitycell *cell = (Activitycell*)[Activitycell activitycellWithTableView:tableView];
    
    cell.activity = (Activity*)self.activity[indexPath.section];
    
    //2 返回cell
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Activitycell *cell = (Activitycell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

//选中单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    CZActivityInfoViewController *activityInfoViewController = [[CZActivityInfoViewController alloc]init];
    activityInfoViewController.title = @"活动介绍";
    [self.navigationController pushViewController:activityInfoViewController animated:YES];
    
}

@end
