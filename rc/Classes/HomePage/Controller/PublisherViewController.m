//
//  PublisherViewController.m
//  rc
//
//  Created by 余笃 on 16/7/23.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "PublisherViewController.h"
#import "UINavigationBar+Awesome.h"
#import "Masonry.h"
#import "EXTScope.h"
#import "CZActivitycell.h"
#import "CZActivityInfoViewController.h"
#import "PubInfoHeaderView.h"
//MJReflesh--------------------------------
#import "MJRefresh.h"
#import "RCHomeRefreshHeader.h"

@interface PublisherViewController ()

@property (nonatomic,strong) ActivityList *acListRecived;
@property (nonatomic,strong) NSMutableArray *acList;

@end

@implementation PublisherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pubInfoView.mj_header = [RCHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.pubInfoView.mj_footer= [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [self setNavigation];
    [self createSubViews];
}

#pragma mark - 创建首页子控件
- (void)createSubViews
{
    PubInfoHeaderView *pubInfoHeaderView = [[PubInfoHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    [pubInfoHeaderView setSubViewsValue];
    self.pubInfoView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, kScreenHeight-10)];
    self.pubInfoView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.pubInfoView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    self.pubInfoView.delegate = self;
    self.pubInfoView.dataSource = self;
    self.pubInfoView.tableHeaderView = pubInfoHeaderView;
    [self.view addSubview:self.pubInfoView];
}

#pragma mark - Tableview 数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1 创建可重用的自定义cell
    CZActivitycell *cell = (CZActivitycell*)[CZActivitycell activitycellWithTableView:tableView];
    
    //对cell内的控件进行赋值
    [self setCellValue:cell AtIndexPath:indexPath];
    
    //对cell内的控件进行布局
    [cell setSubViewsConstraint];
    
    //2 返回cell
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

//section头部间距
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 5;
//}
//section头部视图
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 10)];
//    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
//    return view;
//}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 5)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CZActivityInfoViewController *activityInfoViewController = [[CZActivityInfoViewController alloc]init];
    activityInfoViewController.title = @"活动介绍";
    activityInfoViewController.activityModelPre = self.acList[indexPath.section];
    [self.navigationController pushViewController:activityInfoViewController animated:YES];
    
}
//给单元格进行赋值
- (void) setCellValue:(CZActivitycell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    if (!(self.acList.count == 0))
    {
        ActivityModel *ac = self.acList[indexPath.section];
        
        [cell.ac_poster sd_setImageWithURL:[NSURL URLWithString:ac.acPoster] placeholderImage:[UIImage imageNamed:@"20160102.png"]];
        cell.ac_title.text = ac.acTitle;
        long int len = [ac.acTime length];
        cell.ac_time.text = [NSString stringWithFormat:@"时间: %@", [ac.acTime substringWithRange:NSMakeRange(0, len - 3)]];
        cell.ac_place.text = [NSString stringWithFormat:@"地点: %@", ac.acPlace];
        [cell.ac_type setImage:[UIImage imageNamed:@"biaoqian_icon"] forState:UIControlStateNormal];
        [cell.ac_type setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [cell.ac_type setTitle:@"免费活动" forState:UIControlStateNormal];
        [cell.ac_praise setImage:[UIImage imageNamed:@"eye_ icon"] forState:UIControlStateNormal];
        [cell.ac_praise setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [cell.ac_praise setTitle:@"1000" forState:UIControlStateNormal];
        
        //判断当前活动是否过期
        //判断此行程是否已发生
        BOOL isHappened = [self isHappened:ac];
        if (isHappened == YES)
        {
            cell.ac_title.textColor = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
            cell.ac_time.textColor  = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
            cell.ac_place.textColor = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
            [cell.ac_type setTitleColor:[UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0] forState:UIControlStateNormal  ];
            [cell.ac_praise setTitleColor:[UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            cell.ac_poster.alpha    = 0.6;
        }else
        {
            cell.ac_title.textColor = [UIColor blackColor];
            cell.ac_time.textColor  = [UIColor blackColor];
            cell.ac_place.textColor = [UIColor blackColor];
            [cell.ac_type setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
            [cell.ac_praise setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cell.ac_poster.alpha    = 1.0;
        }
        
    }
    
}

#pragma mark - 判断指定的行程是否已经发生
- (BOOL)isHappened:(ActivityModel *)model
{
    NSString *year = [model.acTime substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [model.acTime substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [model.acTime substringWithRange:NSMakeRange(8, 2)];
    NSString *strDate = [NSString stringWithFormat:@"%@%@%@",year,month,day];
    NSInteger intDate = [strDate integerValue];//指定行程的日期
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"yyyyMMdd"];//设置格式
    [dateformat setTimeZone:[[NSTimeZone alloc]initWithName:@"Asia/Beijing"]];//指定时区
    NSString *currentStrDate = [dateformat stringFromDate:date];
    NSInteger currentIntDate = [currentStrDate integerValue];//当前日期
    
    if (intDate > currentIntDate || intDate == currentIntDate)
    {
        return NO;
    }else
    {
        return YES;
    }
    
}

-(void)refreshRecomend{
}

-(void)getMoreRecomend{
    [self.pubInfoView.mj_footer endRefreshing];
}

- (void)loadNewData
{
    [self refreshRecomend];
    [self.pubInfoView.mj_header endRefreshing];
    [self.pubInfoView.mj_footer endRefreshing];
}

-(void)getMoreData{
    [self getMoreRecomend];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置导航栏
- (void)setNavigation
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    //设置导航标题栏
    UILabel *titleLabel     = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font         = [UIFont systemFontOfSize:18];
    titleLabel.textColor    = themeColor;
    titleLabel.textAlignment= NSTextAlignmentCenter;
    titleLabel.text = @"个人资料";
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    left.tintColor = themeColor;
    [self.navigationItem setLeftBarButtonItem:left];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"私信" style:UIBarButtonItemStylePlain target:self action:@selector(personMsg)];
    right.tintColor = themeColor;
    [self.navigationItem setRightBarButtonItem:right];
    
}

- (void)backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)personMsg{
    
}
@end
