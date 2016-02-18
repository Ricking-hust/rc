//
//  CZMyReleseViewController.m
//  rc
//
//  Created by AlanZhang on 16/2/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZMyReleseViewController.h"
#import "CZActivityCell.h"
#import "Activity.h"
#import "Masonry.h"

@interface CZMyReleseViewController()
@property(nonatomic, strong) NSMutableArray *activity;

@end
@implementation CZMyReleseViewController

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
    
    Activity *activity4 = [Activity activity];
    activity4.ac_title = @"这是第四个";
    Activity *activity5 = [Activity activity];
        activity5.ac_title = @"这是第五个";
    Activity *activity6 = [Activity activity];
        activity5.ac_title = @"这是第六个";
    Activity *activity7 = [Activity activity];
        activity7.ac_title = @"这是第七个";
    
    [self.activity addObject:activity4];
    [self.activity addObject:activity5];
    [self.activity addObject:activity6];
    [self.activity addObject:activity7];
    
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
    
    self.navigationItem.title = @"我的发布";
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    [self createButtons];
}
- (void)backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createButtons
{
    UIColor *selecteColor = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];
    UIColor *nonSelectedColor = [UIColor colorWithRed:38/255.0 green:40.0/255.0 blue:50.0/255.0 alpha:1.0];
    
    self.superOfButtons = [[UIView alloc]init];
    self.superOfButtons.backgroundColor = [UIColor whiteColor];
    
    self.willCheckButton = [[UIButton alloc]init];
    self.willCheckButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.willCheckButton setTitle:@"待审核" forState:UIControlStateNormal];
    [self.willCheckButton setTitleColor:nonSelectedColor forState:UIControlStateNormal];
    [self.willCheckButton setTitleColor:selecteColor forState:UIControlStateSelected];
    
    self.checkedButton = [[UIButton alloc]init];
    self.checkedButton.titleLabel.font = self.willCheckButton.titleLabel.font;
    [self.checkedButton setTitle:@"已审核" forState:UIControlStateNormal];
    [self.checkedButton setTitleColor:nonSelectedColor forState:UIControlStateNormal];
    [self.checkedButton setTitleColor:selecteColor forState:UIControlStateSelected];
    
    self.lineDownOfCheckButton = [[UIView alloc]init];
    self.lineDownOfWillCheckButton = [[UIView alloc]init];
    self.lineDownOfWillCheckButton.backgroundColor = selecteColor;
    self.lineDownOfCheckButton.backgroundColor = selecteColor;
    
    [self.view addSubview:self.superOfButtons];
    [self.superOfButtons addSubview:self.checkedButton];
    [self.superOfButtons addSubview:self.willCheckButton];
    [self.superOfButtons addSubview:self.lineDownOfCheckButton];
    [self.superOfButtons addSubview:self.lineDownOfWillCheckButton];
    
    [self.superOfButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).with.offset(64 + 2);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(35);
    }];
    
    CGFloat padding = [[UIScreen mainScreen]bounds].size.width * 0.2;

    CGSize buttonSize = CGSizeMake(45, 30);
    [self.willCheckButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.superOfButtons);
        make.size.mas_equalTo(buttonSize);
        make.left.equalTo(self.superOfButtons.mas_left).with.offset(padding);
    }];
    [self.lineDownOfWillCheckButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.willCheckButton.mas_left);
        make.bottom.equalTo(self.superOfButtons.mas_bottom);
        make.right.equalTo(self.willCheckButton.mas_right);
        make.height.mas_equalTo(2);
    }];
    [self.checkedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.superOfButtons);
        make.size.mas_equalTo(buttonSize);
        make.right.equalTo(self.superOfButtons.mas_right).with.offset(-padding);
    }];
    [self.lineDownOfCheckButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkedButton.mas_left);
        make.bottom.equalTo(self.superOfButtons.mas_bottom);
        make.right.equalTo(self.checkedButton.mas_right);
        make.height.mas_equalTo(2);
    }];
    //创建tabelView
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.superOfButtons.mas_bottom);
    }];
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
    
    //1 创建可重用的自定义cell
    CZActivitycell *cell = (CZActivitycell*)[CZActivitycell activitycellWithTableView:tableView];
    cell.activity = (Activity*)self.activity[indexPath.section];
    
    //2 返回cell
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZActivitycell *cell = (CZActivitycell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}
@end
