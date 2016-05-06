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
typedef void (^HomeViewBlock)(id);
@property (nonatomic,strong) ActivityList *acListRecived;
@property (nonatomic,strong) NSMutableArray *acList;
@property (nonatomic,strong) NSMutableArray *cityNameList;
@property (nonatomic,strong) NSString *minAcId;
@property (nonatomic,strong) ActivityModel *activitymodel;
@property (nonatomic,strong) FlashList *flashList;
@property (nonatomic,copy) HomeViewBlock refreshBlock;
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
    [self configureCity];
    [self refleshCity];
}
- (void)refleshCity
{
    if ([self.ctmodel.cityID isEqualToString:@"1"])
    {
        [self.leftButton setTitle:@"北京" forState:UIControlStateNormal];
    }else if ([self.ctmodel.cityID isEqualToString:@"2"])
    {
        [self.leftButton setTitle:@"上海" forState:UIControlStateNormal];
    }else if ([self.ctmodel.cityID isEqualToString:@"3"])
    {
        [self.leftButton setTitle:@"武汉" forState:UIControlStateNormal];
    }else
    {
        [self.leftButton setTitle:@"广州" forState:UIControlStateNormal];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self guide];
    [self configureBlocks];
    [self startget];
    [self createSubViews];
    [self configureLocation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRecomend) name:@"refresh" object:nil];
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

-(void)configureCity{
    if ([[userDefaults objectForKey:@"cityId"] isEqualToString:@""]) {
        self.ctmodel.cityID = @"1";
        [userDefaults setObject:@"1" forKey:@"cityId"];
    } else {
        self.ctmodel.cityID = [userDefaults objectForKey:@"cityId"];
    }

}

#pragma mark - 地理定位
-(void)configureLocation{
    //检测定位功能是否开启
    if([CLLocationManager locationServicesEnabled]){
        
        if(!_locationManager){
            
            self.locationManager = [[CLLocationManager alloc] init];
            
            if([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]){
                [self.locationManager requestWhenInUseAuthorization];
                [self.locationManager requestAlwaysAuthorization];
            }
            
            //设置代理
            [self.locationManager setDelegate:self];
            //设置定位精度
            [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
            //设置距离筛选
            [self.locationManager setDistanceFilter:100];
            //开始定位
            [self.locationManager startUpdatingLocation];
            //设置开始识别方向
            [self.locationManager startUpdatingHeading];
            
        }
        
    }else{
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提醒" message:@"定位功能未开启" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertView animated:YES completion:nil];
    }
}

//定位成功以后调用
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    [self.locationManager stopUpdatingLocation];
    CLLocation *location = locations.lastObject;
    
    [self reverseGeocoder:location];
}

//反地理编码
- (void)reverseGeocoder:(CLLocation *)currentLocation {
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(error || placemarks.count == 0){
            NSLog(@"error = %@",error);
        }else{
            CLPlacemark* placemark = placemarks.firstObject;
            //NSLog(@"LocationCity:%@",[[placemark addressDictionary] objectForKey:@"City"]);
            if ([self didShowLocation:[[placemark addressDictionary] objectForKey:@"City"]]) {
                UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"系统检测到您在%@，是否切换到该城市",[[placemark addressDictionary] objectForKey:@"City"]] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];

                UIAlertAction *configureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self changeCityWithLocation:[[placemark addressDictionary] objectForKey:@"City"]];
                }];
                
                [alertControl addAction:cancleAction];
                [alertControl addAction:configureAction];
                [self presentViewController:alertControl animated:YES completion:nil];
            }
        }  
        
    }];  
}

//城市切换
-(void)changeCityWithLocation:(NSString *)location{
    if ([location isEqualToString:@"北京市"]) {
        [userDefaults setObject:@"1" forKey:@"cityId"];
    }
    if ([location isEqualToString:@"上海市"]) {
        [userDefaults setObject:@"2" forKey:@"cityId"];
    }
    if ([location isEqualToString:@"武汉市"]) {
        [userDefaults setObject:@"3" forKey:@"cityId"];
    }
    if ([location isEqualToString:@"广州市"]) {
        [userDefaults setObject:@"4" forKey:@"cityId"];
    }
    //刷新数据
    [self configureCity];
    [self refleshCity];
    [self refreshRecomend];
}

//判断当前地理位置信息是否符合
-(BOOL)didShowLocation:(NSString *)location{
    NSString *locationCity = @"0";
    if ([location isEqualToString:@"北京市"]) {
        locationCity = @"1";
    } else if ([location isEqualToString:@"上海市"]) {
        locationCity = @"2";
    } else if ([location isEqualToString:@"武汉市"]) {
        locationCity = @"3";
    } else if ([location isEqualToString:@"广州市"]) {
        locationCity = @"4";
    }
    if ([locationCity isEqualToString:[userDefaults objectForKey:@"cityId"]]) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - 更新数据
- (void)loadNewData
{
    [self refreshRecomend];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

-(void)getMoreData{
    [self getMoreRecomend];
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
    
//    self.getCityListBlock = ^{
//        @strongify(self);
//        return [[DataManager manager] getCityListSuccess:^(CityList *ctList) {
//            @strongify(self);
//            self.cityList = ctList;
//        } failure:^(NSError *error) {
//            NSLog(@"Error:%@",error);
//        }];
//    };
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
}

-(void)getMoreRecomend{
    if ([self.minAcId isKindOfClass:[NSString class]]) {
        if (self.getActivityListBlock) {
            self.getActivityListBlock(self.minAcId);
        }
        [self.tableView.mj_footer endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

-(void) setFlashList:(FlashList *)flashList{
    _flashList = flashList;
    
    //设置tableHeaderView
    CZHomeHeaderView *headerView = [CZHomeHeaderView headerView];
    headerView.superView = self.view;
    
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

-(CityModel *)ctmodel{
    if (!_ctmodel) {
        _ctmodel = [[CityModel alloc]init];
    }
    return _ctmodel;
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
    if (!(self.acList.count == 0))
    {
        ActivityModel *ac = self.acList[indexPath.section];
        
        [cell.ac_poster sd_setImageWithURL:[NSURL URLWithString:ac.acPoster] placeholderImage:[UIImage imageNamed:@"20160102.png"]];
        cell.ac_title.text = ac.acTitle;
        long int len = [ac.acTime length];
        cell.ac_time.text = [NSString stringWithFormat:@"时间: %@", [ac.acTime substringWithRange:NSMakeRange(0, len - 3)]];
        cell.ac_place.text = [NSString stringWithFormat:@"地点: %@", ac.acPlace];
        [cell.ac_imageTag setImage:[UIImage imageNamed:@"tagImage"]];
        NSMutableArray *Artags = [[NSMutableArray alloc]init];
        
        for (TagModel *model in ac.tagsList.list) {
            [Artags addObject:model.tagName];
        }
        
        NSString *tags = [Artags componentsJoinedByString:@","];
        cell.ac_tags.text = tags;
        //[cell.ac_imageTag sd_setImageWithURL:[NSURL URLWithString:ac.userInfo.userPic] placeholderImage:[UIImage imageNamed:@"tagImage"]];
        //cell.ac_tags.text = ac.userInfo.userName;
        //判断当前活动是否过期
        //判断此行程是否已发生
        BOOL isHappened = [self isHappened:ac];
        if (isHappened == YES)
        {
            cell.ac_title.textColor = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
            cell.ac_time.textColor  = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
            cell.ac_place.textColor = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
            cell.ac_tags.textColor  = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
            cell.ac_imageTag.alpha  = 0.6;
        }else
        {
            cell.ac_title.textColor = [UIColor blackColor];
            cell.ac_time.textColor  = [UIColor blackColor];
            cell.ac_place.textColor = [UIColor blackColor];
            cell.ac_tags.textColor  = [UIColor blackColor];
            cell.ac_imageTag.alpha  = 1.0;
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


#pragma mark - 创建首页子控件
/**
 *  创建一个tableView和一个搜索框
 *
 */
- (void)createSubViews
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
- (IBAction)didSelectCity:(UIButton *)sender··
{
    CZCityViewController *cityViewController = [[CZCityViewController alloc]init];
    cityViewController.ctmodel = self.ctmodel;
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refresh" object:nil];
}

@end
