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
#import "CZCityButton.h"
#import "CZCityViewController.h"
#import "CZActivityInfoViewController.h"
#import "RCSettingTagTableViewController.h"
#import "LoginViewController.h"
#import "CZSearchViewController.h"
#import "CZActivitycell.h"
#import "ActivityModel.h"
#import "DataManager.h"
#import "UIImageView+WebCache.h"
#import "UINavigationBar+Awesome.h"
#import "EXTScope.h"
//MJReflesh--------------------------------
#import "MJRefresh.h"
#import "RCHomeRefreshHeader.h"
//引导员
#import "KSGuideManager.h"

@interface CZHomeViewController ()
@property (nonatomic,strong) ActivityList *acListRecived;
@property (nonatomic,strong) NSMutableArray *acList;
@property (nonatomic,strong) CityList *cityList;
@property (nonatomic,strong) NSString *cityId;
@property (nonatomic,strong) NSMutableArray *cityNameList;
@property (nonatomic,strong) NSString *minAcId;
@property (nonatomic,strong) ActivityModel *activitymodel;
@property (nonatomic,strong) FlashList *flashList;
@property (nonatomic,copy) NSURLSessionDataTask *(^getActivityListBlock)(NSString *minAcId);
@property (nonatomic,copy) NSURLSessionDataTask *(^getFlash)();
@property (nonatomic,copy) NSURLSessionDataTask *(^getCityListBlock)();
@property (weak, nonatomic) IBOutlet CZCityButton *leftButton;

@end

@implementation CZHomeViewController

#pragma  mark - 刷新数据
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    //刷新数据
    [self refleshDataByCity];
}
- (void)refleshDataByCity
{
    if (self.city == Beijing)
    {
        [self.leftButton setTitle:@"北京" forState:UIControlStateNormal];
        self.cityId = @"1";
    }else if (self.city == Shanghai)
    {
        [self.leftButton setTitle:@"上海" forState:UIControlStateNormal];
        self.cityId = @"2";
    }else if (self.city == Wuhan)
    {
        [self.leftButton setTitle:@"武汉" forState:UIControlStateNormal];
        self.cityId = @"3";
    }else
    {
        [self.leftButton setTitle:@"广州" forState:UIControlStateNormal];
        self.cityId = @"4";
    }
    //刷新
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self guide];
    self.city = Beijing;
    self.cityId =@"1";
    [self configureBlocks];
    [self startget];
    [self createSubViews];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.city = Beijing;
    self.cityId = @"1";
    self.tableView.mj_header = [RCHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer= [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
}
#pragma mark - 设置引导页
- (void)guide
{
    NSMutableArray *paths = [NSMutableArray new];
    
    [paths addObject:[[NSBundle mainBundle] pathForResource:@"tutor1" ofType:@"jpg"]];
    [paths addObject:[[NSBundle mainBundle] pathForResource:@"tutor2" ofType:@"jpg"]];
    [paths addObject:[[NSBundle mainBundle] pathForResource:@"tutor3" ofType:@"jpg"]];
    [paths addObject:[[NSBundle mainBundle] pathForResource:@"tutor4" ofType:@"jpg"]];
    [[KSGuideManager shared] showGuideViewWithImages:paths];
}

#pragma mark - 更新数据
- (void)loadNewData
{
    [self refreshRecomend];
    [self.tableView.mj_header endRefreshing];
}

-(void)getMoreData{
    [self getMoreRecomend];
    [self.tableView.mj_footer endRefreshing];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - get data

- (void)configureBlocks{
    @weakify(self);
    self.getFlash = ^{
        @strongify(self)
        return [[DataManager manager] getFlashWithSuccess:^(FlashList *fLashList) {
            self.flashList = fLashList;
        } failure:^(NSError *error) {
            NSLog(@"Error:%@",error);
        }];
    };
    
    self.getActivityListBlock = ^(NSString *minAcId){
        @strongify(self);
        NSString *userId = [[NSString alloc]init];
        if ([userDefaults objectForKey:@"userId"]) {
            userId = [userDefaults objectForKey:@"userId"];
        } else {
            userId = @"-1";
        }
        NSString *cityId = [[NSString alloc]init];
        if ([userDefaults objectForKey:@"cityId"]) {
            cityId = [userDefaults objectForKey:@"cityId"];
        } else {
            cityId = @"1";
        }
        return [[DataManager manager] getActivityRecommendWithCityId:cityId startId:minAcId num:@"10" userId:userId success:^(ActivityList *acList) {
            @strongify(self);
            self.acListRecived = acList;
        } failure:^(NSError *error) {
            NSLog(@"error:%@",error);
        }];
    };
    
    self.getCityListBlock = ^{
        @strongify(self);
        return [[DataManager manager] getCityListSuccess:^(CityList *ctList) {
            @strongify(self);
            self.cityList = ctList;
        } failure:^(NSError *error) {
            NSLog(@"Error:%@",error);
        }];
    };
}

- (void)startget{
    
    if (self.getActivityListBlock) {
        self.getActivityListBlock(@"0");
    }
    
    if (self.getFlash) {
        self.getFlash();
    }
}

-(void)refreshRecomend{
    if (self.getActivityListBlock) {
        self.getActivityListBlock(@"0");
    }
    [self.acList removeAllObjects];
    for (ActivityModel *model in self.acListRecived.list) {
        [self.acList addObject:model];
    }
}

-(void)getMoreRecomend{
    if (self.getActivityListBlock) {
        self.getActivityListBlock(self.minAcId);
    }
}

-(void) setFlashList:(FlashList *)flashList{
    _flashList = flashList;
    
    //设置tableHeaderView
    CZHomeHeaderView *headerView = [CZHomeHeaderView headerView];
    [headerView setView:flashList.list];
    self.tableView.tableHeaderView = headerView;
}

-(void) setAcListRecived:(ActivityList *)acListRecived{
    _acListRecived = acListRecived;
    for (ActivityModel *model in acListRecived.list) {
        [self.acList addObject:model];
    }
    ActivityModel *minModel = _acListRecived.list.lastObject;
    self.minAcId = minModel.acID;
    [self.tableView reloadData];
}

-(NSMutableArray *)acList{
    if (!_acList) {
        _acList = [[NSMutableArray alloc]init];
    }
    return _acList;
}

-(void) setCityList:(CityList *)cityList{
    _cityList = cityList;
}

#pragma mark - Tableview 数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.acList.count;
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
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
    activityInfoViewController.activityModelPre = self.acList[indexPath.section];
    [self.navigationController pushViewController:activityInfoViewController animated:YES];
    
}
//给单元格进行赋值
- (void) setCellValue:(CZActivitycell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    ActivityModel *ac = self.acList[indexPath.section];
    
    [cell.ac_poster sd_setImageWithURL:[NSURL URLWithString:ac.acPoster] placeholderImage:[UIImage imageNamed:@"20160102.png"]];
    cell.ac_title.text = ac.acTitle;
    long int len = [ac.acTime length];
    cell.ac_time.text = [NSString stringWithFormat:@"时间: %@", [ac.acTime substringWithRange:NSMakeRange(0, len - 3)]];
    cell.ac_place.text = [NSString stringWithFormat:@"地点: %@", ac.acPlace];
    cell.ac_tags.text = ac.userInfo.userName;
    
}
#pragma mark - 创建首页子控件
/**
 *  创建一个tableView和一个搜索框
 *
 */
- (void)createSubViews
{
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
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
    label.alpha = 0.7;
    CGSize labelSize = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:labelFont]} context:nil].size;
    [view addSubview:label];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchView.mas_left).with.offset(15);
        make.centerY.equalTo(self.searchView.mas_centerY);
        make.right.equalTo(self.searchView.mas_right).offset(-15);
        make.height.mas_equalTo(28);
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
        make.height.mas_equalTo(38);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(35);
        make.left.equalTo(self.searchView.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
#pragma mark - 城市选择
- (IBAction)didSelectCity:(UIButton *)sender
{
    CZCityViewController *cityViewController = [[CZCityViewController alloc]init];
    cityViewController.city = self.city;
    [self.navigationController pushViewController:cityViewController animated:YES];

}
- (IBAction)toTagSelectViewController:(id)sender
{
    if ([DataManager manager].user.isLogin) {
        RCSettingTagTableViewController *tagVC = [[RCSettingTagTableViewController alloc]init];
        [self.navigationController pushViewController:tagVC animated:YES];
    } else {
        LoginViewController *loginViewController = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }
}
#pragma mark - 首页搜索框点击事件
- (void) onClickSearch:(UIView *)view
{
    CZSearchViewController *searchViewController = [[CZSearchViewController alloc]init];
    [self.navigationController pushViewController:searchViewController animated:YES];
}


@end
