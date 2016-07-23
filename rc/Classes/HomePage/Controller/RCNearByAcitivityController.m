//
//  RCNearByAcitivityController.m
//  rc
//
//  Created by AlanZhang on 16/7/23.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCNearByAcitivityController.h"
#import "MJRefresh.h"
#import "RCHomeRefreshHeader.h"
#import "RCMyActivityCell.h"
#import <CoreLocation/CoreLocation.h>
#import "RCNetworkingRequestOperationManager.h"
#import "UINavigationBar+Awesome.h"
#import "RCNearByActivtiyModel.h"
#import "MBProgressHUD.h"
#import "CZActivityInfoViewController.h"
@interface RCNearByAcitivityController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *activitySoucres;
@end

@implementation RCNearByAcitivityController
- (id)init
{
    if (self = [super init])
    {
        self.activitySoucres = [[NSArray alloc]init];
        UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        [self.navigationItem setLeftBarButtonItem:back];
        self.navigationItem.title = @"附近活动";
        self.tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.mj_header = [RCHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        self.tableView.mj_footer= [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
        // 初始化定位管理器
        self.locationManager = [[CLLocationManager alloc] init];
        // 设置代理
        self.locationManager.delegate = self;
        // 设置定位精确度到米
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // 设置过滤器为无
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        // 开始定位
        [self.locationManager startUpdatingLocation];
    }
    return self;
}
// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    [self.locationManager stopUpdatingLocation];
    CLLocation *newLocaion = locations.firstObject;
    //经度
    NSString *longitude = [NSString stringWithFormat:@"%lf", newLocaion.coordinate.longitude];
    //纬度
    NSString *latitude = [NSString stringWithFormat:@"%lf", newLocaion.coordinate.latitude];
    //NSLog(@"经度：%@ 纬度：%@",longitude,latitude);
    [self getNearByActivity:longitude latitude:latitude];
    
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadNewData
{
    [self.tableView.mj_header endRefreshing];
}
- (void)getMoreData
{
    [self.tableView.mj_footer endRefreshing];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

}
- (void)getNearByActivity:(NSString *)longitude latitude:(NSString *)latitude
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *urlStr = @"http://appv2.myrichang.com/Home/Activity/getNearbyAcs";
        NetWorkingRequestType type = POST;
        NSString *ct_id = [userDefaults valueForKey:@"cityId"];
        NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:ct_id,@"ct_id",longitude,@"usr_longitude",latitude,@"usr_latitude",@"0",@"start_id",nil];
        [RCNetworkingRequestOperationManager request:urlStr requestType:type parameters:parameters completeBlock:^(NSData *data) {
            id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            self.activitySoucres = [self extractActivityFrom:dict];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            
        } errorBlock:^(NSError *error) {
            NSLog(@"请求失败:%@",error);
        }];
        
    });

}
- (NSArray *)extractActivityFrom:(NSDictionary *)dic
{
    NSNumber *code = [dic valueForKey:@"code"];
    if ([code isEqualToNumber:[[NSNumber alloc]initWithInt:200]])
    {//返回正确的数据
        
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        NSArray *data = [dic valueForKey:@"data"];
        for (NSDictionary *dict in data)
        {
            [temp addObject:[self getActivityForm:dict]];
            
        }
        return [[NSArray alloc]initWithArray:temp];
    }else
    {
        NSLog(@"error = %@,msg = %@",code,[dic valueForKey:@"msg"]);
        return nil;
    }
}
- (RCNearByActivtiyModel *)getActivityForm:(NSDictionary *)dict
{
    RCNearByActivtiyModel *model = [[RCNearByActivtiyModel alloc]init];
    model.ac_id = [dict valueForKey:@"ac_id"];
    model.usr_id =  [dict valueForKey:@"usr_id"];
    model.usr_name =  [dict valueForKey:@"usr_name"];
    model.usr_pic =  [dict valueForKey:@"usr_pic"];
    model.ac_poster =  [dict valueForKey:@"ac_poster"];
    model.ac_poster_top =  [dict valueForKey:@"ac_poster_top"];
    model.ac_title =  [dict valueForKey:@"ac_title"];
    model.ac_time =  [dict valueForKey:@"ac_time"];
    model.ac_place =  [dict valueForKey:@"ac_place"];
    model.ac_collect_num =  [dict valueForKey:@"ac_collect_num"];
    model.ac_read_num =  [dict valueForKey:@"ac_read_num"];
    model.ac_distance =  [dict valueForKey:@"ac_distance"];
    model.ac_tags =  [dict valueForKey:@"ac_tags"];

    return model;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    if (self.activitySoucres.count == 0 || self.activitySoucres == nil)
    {
        return 0;
    }else
    {
        return self.activitySoucres.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCMyActivityCell *cell = [RCMyActivityCell cellWithTableView:tableView];
    [self setValueOfCell:cell AtIndexPath:indexPath];
    cell.addSchedule.tag = indexPath.section;
    return cell;
}
#pragma mark - cell的点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZActivityInfoViewController *ac = [[CZActivityInfoViewController alloc]init];
    
    ac.activityModelPre = [self activityModeFromUserActivity:self.activitySoucres[indexPath.section]];
    [self.navigationController pushViewController:ac animated:YES];
}
#pragma mark - 我的数据模型与余笃的数据模型的转换函数
- (ActivityModel *)activityModeFromUserActivity:(RCNearByActivtiyModel *)nearbyModel
{
    ActivityModel *model = [[ActivityModel alloc]init];
    
    model.acID = nearbyModel.ac_id;
    model.acPoster = nearbyModel.ac_poster;
    model.acPosterTop = nearbyModel.ac_poster_top;
    model.acTitle = nearbyModel.ac_title;
    model.acTime = nearbyModel.ac_time;
    model.acTheme = @"";
    model.acPlace = nearbyModel.ac_place;
    model.acCollectNum = @"zhangdy";
    model.acSize = @"";
    model.acPay = @"";
    model.acDesc = @"";
    model.acReview = @"";
    model.acStatus = @"";
    model.acPraiseNum = @"";
    model.acReadNum = @"";
    model.acHtml = @"";
    model.acCollectNum = @"";
    model.plan = @"";
    model.planId = @"";
    model.userInfo.userId = [userDefaults valueForKey:@"userId"];
    model.userInfo.userName = nearbyModel.usr_name;
    model.userInfo.userPic = nearbyModel.usr_pic;
    model.tagsList.list = [[NSMutableArray alloc]initWithArray:nearbyModel.ac_tags];
    
    return model;
}

//给单元格进行赋值
- (void)setValueOfCell:(RCMyActivityCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    [cell.addSchedule setTitle:@"加入行程" forState:UIControlStateNormal];
    RCNearByActivtiyModel *acModel = self.activitySoucres[indexPath.section];
    cell.acName.text = acModel.ac_title;
    cell.acTime.text = [acModel.ac_time substringWithRange:NSMakeRange(0, [acModel.ac_time length] - 3)];
    cell.acPlace.text = acModel.ac_place;
    NSArray *tagArray = [[NSArray alloc]initWithArray:acModel.ac_tags];
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in tagArray)
    {
        NSString *tag_name = [dict valueForKey:@"tag_name"];
        [temp addObject:tag_name];
    }
    
    NSString *tagString = [temp componentsJoinedByString:@","];
    cell.acTag.text = tagString;
    [cell.acImageView sd_setImageWithURL:[NSURL URLWithString:acModel.ac_poster] placeholderImage:[UIImage imageNamed:@"img_1"]];
    [cell.addSchedule addTarget:self action:@selector(addToSchedule:) forControlEvents:UIControlEventTouchDown];
    [cell setSubViewConstraint];
}
#pragma mark - 加入行程
- (void)addToSchedule:(UIButton *)button
{
    NSString *urlStr = @"http://appv2.myrichang.com/Home/Activity/joinTrip";
    NetWorkingRequestType type = POST;
    NSString *usr_id = [userDefaults objectForKey:@"userId"];
    RCNearByActivtiyModel *nearbyActivity = self.activitySoucres[(int)button.tag];
    NSString *ac_id = nearbyActivity.ac_id;
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:usr_id,@"usr_id",@"1",@"op_type",ac_id,@"ac_id",nil];
    [RCNetworkingRequestOperationManager request:urlStr requestType:type parameters:parameters completeBlock:^(NSData *data) {
        id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSString *msg = [dict valueForKey:@"msg"];
        if ([msg isEqualToString:@"加入行程成功！"])
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            //hud.label.text = NSLocalizedString(@"Message here!", @"HUD message title");
            hud.label.text = @"加入行程成功。";
            [hud hideAnimated:YES afterDelay:0.7];
        }else if ([msg isEqualToString:@"此活动已经加入行程！"])
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"此活动已经加入行程！";
            [hud hideAnimated:YES afterDelay:0.7];
            
        }
    } errorBlock:^(NSError *error) {
        NSLog(@"请求失败:%@",error);
    }];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
