//
//  RCMyFocusTableViewController.m
//  rc
//
//  Created by LittleMian on 16/6/20.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCMyFollowTableViewController.h"
#import "RCNetworkingRequestOperationManager.h"
#import "RCMyFansCell.h"
#import "RCMyFansModel.h"
#import "RCHomeRefreshHeader.h"
#import "MJRefresh.h"
@interface RCMyFollowTableViewController ()
@property (nonatomic, strong) NSMutableArray *fans;
@end

@implementation RCMyFollowTableViewController

- (id)init
{
    if (self = [super init])
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.navigationItem.title = @"我的粉丝";
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
        
        [self.navigationItem setLeftBarButtonItem:leftButton];
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search_icon2"] style:UIBarButtonItemStylePlain target:self action:@selector(searchFocus)];
        
        [self.navigationItem setRightBarButtonItem:rightButton];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self getFansList];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    self.tableView.mj_header = [RCHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewFans)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉Cell之间的分割线
    //self.tableView.mj_footer= [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreFans)];
    //self.foucs = [[NSMutableArray alloc]init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
#pragma mark - 刷新粉丝列表
- (void)loadNewFans
{
    NSString *URLString = @"http://appv2.myrichang.com/home/Person/getFollows";
    NSString *usr_id = [userDefaults objectForKey:@"userId"];
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:usr_id,@"usr_id",@"2",@"op_type", nil];
    
    [RCNetworkingRequestOperationManager request:URLString requestType:GET parameters:parameters completeBlock:^(NSData *data) {
        id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSMutableArray *focus = [self initfocusListWithDict:dict];
        self.fans = focus;
        if (self.fans  != nil && self.fans .count != 0)
        {
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
    } errorBlock:^(NSError *error) {
        NSLog(@"网络请求错误:%@",error);
        [self.tableView.mj_header endRefreshing];
    }];
}
#pragma mark - 获取更多粉丝
- (void)getMoreFans
{
    NSMutableArray __block *moreActivity = [[NSMutableArray alloc]initWithArray:self.fans];
    
    NSString *urlStr = @"http://appv2.myrichang.com/home/Person/getFollows";
    NetWorkingRequestType type = GET;
    NSString *usr_id = [userDefaults objectForKey:@"userId"];
    RCMyFansModel *lastActivity = self.fans.lastObject;
    NSString *start_id = @"2";
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:usr_id,@"usr_id",@"2",@"op_type",start_id,@"start_id",nil];
    [RCNetworkingRequestOperationManager request:urlStr requestType:type parameters:parameters completeBlock:^(NSData *data) {
        id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

        
    } errorBlock:^(NSError *error) {
        NSLog(@"请求失败:%@",error);
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (void)getFansList
{
    NSString *URLString = @"http://appv2.myrichang.com/home/Person/getFollows";
    NSString *usr_id = [userDefaults objectForKey:@"userId"];
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:usr_id,@"usr_id",@"1",@"op_type", nil];
    
    [RCNetworkingRequestOperationManager request:URLString requestType:GET parameters:parameters completeBlock:^(NSData *data) {
        id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSMutableArray *focus = [self initfocusListWithDict:dict];
        self.fans = focus;
        if (self.fans != nil && self.fans.count != 0)
        {
            [self.tableView reloadData];
        }
    } errorBlock:^(NSError *error) {
        NSLog(@"网络请求错误:%@",error);
    }];
}
- (NSMutableArray *)initfocusListWithDict:(NSDictionary *)dict
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
    }else if ([code isEqualToNumber:[[NSNumber alloc]initWithInt:210]])
    {//返回失败:操作类型无效或用户ID为空
        NSLog(@"操作失败:%@",[dict valueForKey:@"msg"]);
        return nil;
    }else
    {
        NSLog(@"失败其他原因：%@",code);
        return nil;
    }
    
}
- (RCMyFansModel *)userActivityfromDict:(NSDictionary *)dict
{
    RCMyFansModel *model = [[RCMyFansModel alloc]init];
    model.usr_id = [dict valueForKey:@"usr_id"];
    model.usr_name = [dict valueForKey:@"usr_name"];
    if ([[dict valueForKey:@"usr_sign"]isEqualToString:@""])
    {
        model.usr_sign = @"这个人很懒什么都没有留下。";
    }else
    {
        model.usr_sign = [dict valueForKey:@"usr_sign"];
    }
    model.usr_pic = [dict valueForKey:@"usr_pic"];
    
    return model;
}

//- (void)setFoucs:(NSMutableArray *)foucs
//{
//    _foucs = foucs;
//    if (_foucs != nil && _foucs.count != 0)
//    {
//        [self.tableView reloadData];
//    }
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.fans == nil)
    {
        return 0;
    }else
    {
        return self.fans.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    RCMyFansCell *cell = [RCMyFansCell cellWithTableView:tableView];
    if (indexPath.row == self.fans.count - 1)
    {
        cell.isLastCell = YES;
    }
    cell.view = self.view;
    cell.model = self.fans[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:0.6];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth - 15, 10)];
    view.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:0.6];
    return view;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - 搜索好友
- (void)searchFocus
{
    
}
- (void)backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
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
