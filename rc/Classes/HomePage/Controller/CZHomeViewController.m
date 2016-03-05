//
//  CZHomeViewController.m
//  rc
//
//  Created by AlanZhang on 16/1/20.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZHomeViewController.h"
#import "CZHomeHeaderView.h"
#import "Masonry.h"
#import "CZActivityInfoViewController.h"
#import "CZTagSelectViewController.h"
#import "CZSearchViewController.h"
#import "CZActivitycell.h"
#import "ActivityModel.h"
#import "DataManager.h"
#import "UIImageView+WebCache.h"
#import "UINavigationBar+Awesome.h"
#import "EXTScope.h"

@interface CZHomeViewController ()
@property (nonatomic,strong) ActivityList *activityList;
@property (nonatomic,strong)  ActivityModel *activitymodel;
@property (nonatomic,copy) NSURLSessionDataTask *(^getActivityListBlock)();
@property (nonatomic, copy) NSURLSessionDataTask* (^getActivityBlock)(NSString *acID);


@end

@implementation CZHomeViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
}
- (void)configureBlocks{
    @weakify(self);
    self.getActivityListBlock = ^(){
        @strongify(self);
        return [[DataManager manager] getActivityRecommendWithCityId:@"1" startId:@"0" num:@"10" userId:@"1" success:^(ActivityList *acList) {
            @strongify(self);
            self.activityList = acList;
        } failure:^(NSError *error) {
            NSLog(@"error:%@",error);
        }];
//        return [[DataManager manager] getActivitySearchWithKeywords:@"讲座" startId:@"0" num:@"10" cityId:@"1" success:^(ActivityList *acList) {
//            @strongify(self);
//            self.activityList = acList;
//        } failure:^(NSError *error) {
//            NSLog(@"error:%@",error);
//        }];
    };
}

- (void)startget{
    if (self.getActivityListBlock) {
        self.getActivityListBlock();
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    @weakify(self);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @strongify(self);
        
        [self startget];
        
    });
}

- (void) setActivityList:(ActivityList *)activityList{
    
    _activityList = activityList;
    
    [self.tableView reloadData];
}

-(void)loadView{
    [super loadView];
    
    [self createSubViews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureBlocks];
    
    //设置tableHeaderView
    CZHomeHeaderView *headerView = [CZHomeHeaderView headerView];
    [headerView setView];
    self.tableView.tableHeaderView = headerView;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview 数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.activityList.list.count;
    
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
    CZActivitycell *cell = (CZActivitycell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 5)];
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];;
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

#pragma mark - 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CZActivityInfoViewController *activityInfoViewController = [[CZActivityInfoViewController alloc]init];
    activityInfoViewController.title = @"活动介绍";
    activityInfoViewController.activityModelPre = self.activityList.list[indexPath.section];
    [self.navigationController pushViewController:activityInfoViewController animated:YES];
    
}
//给单元格进行赋值

- (void) setCellValue:(CZActivitycell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    ActivityModel *ac = self.activityList.list[indexPath.section];
    
    [cell.ac_poster sd_setImageWithURL:[NSURL URLWithString:ac.acPoster] placeholderImage:[UIImage imageNamed:@"20160102.png"]];
    cell.ac_title.text = ac.acTitle;
    cell.ac_time.text = ac.acTime;
    cell.ac_place.text = ac.acPlace;
    NSMutableArray *Artags = [[NSMutableArray alloc]init];
    
    for (TagModel *model in ac.tagsList.list) {
        [Artags addObject:model.tagName];
    }
    
    NSString *tags = [Artags componentsJoinedByString:@","];
    cell.ac_tags.text = tags;
    
}
#pragma mark - 创建首页子控件
/**
 *  创建一个tableView和一个搜索框
 *
 */
- (void)createSubViews
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero];
    self.searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 70/2)];
    self.searchView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searchView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //创建搜索框
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    [view.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [view.layer setCornerRadius:13];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickSearch:)];
    [view addGestureRecognizer:tapGesture];
    
    
    [self.searchView addSubview:view];
    
    UIImageView *img = [[UIImageView alloc]init];
    img.image = [UIImage imageNamed:@"searchIcon"];
    [view addSubview:img];
    
    CGFloat labelFont = 12;
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:labelFont];
    label.tintColor = [UIColor colorWithRed:38.0/255.0 green:40.0/255.0 blue:50.0/255.0 alpha:0.5];
    label.text = @"搜索科技、媒体、互联网";
    CGSize labelSize = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:labelFont]} context:nil].size;
    [view addSubview:label];
    
    CGFloat leftPadding = [[UIScreen mainScreen]bounds].size.width *0.08 /2;
    CGFloat topPadding = self.searchView.frame.size.height * 0.2 / 2;
    CGSize viewSize = CGSizeMake([[UIScreen mainScreen]bounds].size.width * 0.92, self.searchView.frame.size.height * 0.8);
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchView.mas_left).with.offset(leftPadding);
        make.top.equalTo(self.searchView.mas_top).with.offset(topPadding);
        make.size.mas_equalTo(viewSize);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.centerX.equalTo(view).with.offset(15);
        make.size.mas_equalTo(labelSize);
    }];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_top);
        make.right.equalTo(label.mas_left).with.offset(-6);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(64);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(70.0 / 2);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(35);
        make.left.equalTo(self.searchView.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
- (IBAction)toTagSelectViewController:(id)sender
{
    CZTagSelectViewController *tagSelcteViewController = [[CZTagSelectViewController alloc]init];
    [self.navigationController pushViewController:tagSelcteViewController animated:YES];
}
#pragma mark - 首页搜索框点击事件
- (void) onClickSearch:(UIView *)view
{
    CZSearchViewController *searchViewController = [[CZSearchViewController alloc]init];
    [self.navigationController pushViewController:searchViewController animated:YES];
}


@end
