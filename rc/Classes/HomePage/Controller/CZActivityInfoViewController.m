//
//  CZActivityInfoViewController.m
//  rc
//
//  Created by AlanZhang on 16/1/15.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZActivityInfoViewController.h"
#import "ActivityInfoHeaderView.h"
#import "ActivityIntroduction.h"
#import "Masonry.h"
#import "CZTimeCell.h"
#import "CZActivityInfoCell.h"
#import "CZActivityDetailCell.h"

@interface CZActivityInfoViewController ()

@property(nonatomic, strong) UIView *bottomView;

@property(nonatomic,strong) UIButton *collectionBtn;
@property(nonatomic,strong) UIButton *addToSchedule;

@property (nonatomic, strong)ActivityIntroduction *activity;
@end

@implementation CZActivityInfoViewController

//创建子控件
- (void)createSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.collectionBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    self.addToSchedule = [UIButton buttonWithType:UIButtonTypeCustom];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tableView];
    [self.bottomView addSubview:self.collectionBtn];
    [self.bottomView addSubview:self.addToSchedule];
    
    [self.collectionBtn addTarget:self action:@selector(onClickCollection) forControlEvents:UIControlEventTouchUpInside];
    [self.addToSchedule addTarget:self action:@selector(onClickAdd) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.addToSchedule setTitle:@"加入日程" forState:UIControlStateNormal];
    [self.addToSchedule setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:130.0/255.0  blue:5.0/255.0  alpha:1.0]];
    
    [self.collectionBtn setImage:[UIImage imageNamed:@"shopping"] forState:UIControlStateNormal];
    [self.collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    CGSize size = [[UIScreen mainScreen]bounds].size;
    //add tableView constraints
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(@64);
        make.size.mas_equalTo(CGSizeMake(size.width, size.height - 114));
    }];

    //add bottomView constraints
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.tableView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(size.width, 50));
    }];
    
    //add collectionBtn constraints
    [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left);
        make.top.equalTo(self.bottomView.mas_top);
        make.size.mas_equalTo(CGSizeMake(size.width * 0.33, 50));
    }];
    
    //add addToSchedule constriants
    [self.addToSchedule mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.collectionBtn.mas_right);
        make.top.equalTo(self.bottomView.mas_top);
        make.size.mas_equalTo(CGSizeMake(size.width * 0.69, 50));
    }];
    
}

- (void)onClickCollection
{
//    NSLog(@"collection");
}

- (void)onClickAdd
{
//     NSLog(@"addToSchedule");
}

//界面加载完毕
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubViews];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
#pragma mark -  测试数据

    self.activity = [ActivityIntroduction acIntroduction];
    [_activity setSubViewsContent];
    
    //设置tableVie头
    ActivityInfoHeaderView *header = [ActivityInfoHeaderView headerView];
    [header setView:_activity];
    self.tableView.tableHeaderView = header;
    
}

//左侧按钮的点击事件
- (void) back
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            CZTimeCell *cell = [CZTimeCell timeCellWithTableView:tableView];
            cell.acIntroduction = self.activity;
            return cell;
        }
            break;
        case 1:
        {
            CZActivityInfoCell *cell = [CZActivityInfoCell activityCellWithTableView:tableView];
            cell.acIntroduction = self.activity;
            return cell;
        }
            break;
        default:
        {
            CZActivityDetailCell *cell = [CZActivityDetailCell detailCellWithTableView:tableView];
            return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZTimeCell *cell = (CZTimeCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.rowHeight;
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 60.0/2;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    UIColor *textcolor = [UIColor colorWithRed:131.0/255.0 green:131.0/255.0  blue:131.0/255.0  alpha:1.0];
    if (section == 0)
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen]bounds].size.width, 1)];
    }else if(section == 1)
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen]bounds].size.width, 60.0/2)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 30)];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"活动详情";
        label.textColor = textcolor;
        [view addSubview:label];
    }else
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen]bounds].size.width, 60.0/2)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 30)];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"活动介绍";
        label.textColor = textcolor;
        [view addSubview:label];
    }
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
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
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen]bounds].size.width, 1)];
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    return view;
}




@end
