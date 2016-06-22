//
//  RCMyFocusTableViewController.m
//  rc
//
//  Created by LittleMian on 16/6/21.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCMyFocusTableViewController.h"
#import "RCNetworkingRequestOperationManager.h"
#import "RCHomeRefreshHeader.h"
#import "MJRefresh.h"
#include "RCMyFocusModel.h"
#import "RCMyFocusCell.h"
#import "Masonry.h"
@interface RCMyFocusTableViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *focus;
@end

@implementation RCMyFocusTableViewController
- (id)init
{
    if (self = [super init])
    {
        self.tableView = [[UITableView alloc]init];
        self.searchBar = [[UISearchBar alloc]init];

    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSubviews];
    self.tableView.mj_header = [RCHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewFocus)];
    [self getFocusList];
    //self.tableView.mj_footer= [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreFans)];
}
#pragma mark - 发出网络请求，获取我的关注列表
- (void)getFocusList
{
    NSString *URLString = @"http://appv2.myrichang.com/home/Person/getFollows";
    NSString *usr_id = [userDefaults objectForKey:@"userId"];
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:usr_id,@"usr_id",@"2",@"op_type", nil];
    
    [RCNetworkingRequestOperationManager request:URLString requestType:GET parameters:parameters completeBlock:^(NSData *data) {
        id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSMutableArray *focus = [self initfocusListWithDict:dict];
        self.focus = focus;
        if (self.focus != nil && self.focus.count != 0)
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
- (RCMyFocusModel *)userActivityfromDict:(NSDictionary *)dict
{
    RCMyFocusModel *model = [[RCMyFocusModel alloc]init];
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
#pragma mark - 刷新我的关注列表
- (void)loadNewFocus
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setSubviews
{
    UIView *view = [[UIView alloc]init];
    [self.view addSubview:view];//消除导航栏对tableView的约束影响
    
    self.searchBar.backgroundImage = [UIImage new];//设置背景图是为了去掉上下黑线
    self.searchBar.barTintColor = [UIColor whiteColor];// 设置SearchBar的颜色主题为白色
    [self.searchBar setBackgroundColor:[UIColor whiteColor]];//KVC获得到UISearchBar的私有变量
    self.searchBar.layer.cornerRadius = 3.0f;
    self.searchBar.layer.borderColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1].CGColor;
    self.searchBar.layer.borderWidth = 1;
    self.searchBar.layer.masksToBounds = YES;
    self.searchBar.placeholder = @"搜索";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];

    [self.searchBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64+7);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(30);
    }];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom).offset(7);
        //make.top.equalTo(self.view.mas_top).offset(-64);
        make.right.left.bottom.equalTo(self.view);
    }];
    
    self.navigationItem.title = @"我的关注";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    //        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search_icon2"] style:UIBarButtonItemStylePlain target:self action:@selector(searchFocus)];
    //
    //        [self.navigationItem setRightBarButtonItem:rightButton];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (self.focus == nil)
    {
        return 0;
    }else
    {
        return self.focus.count;
    };
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCMyFocusCell *cell = [RCMyFocusCell cellWithTableView:tableView];
    if (indexPath.row == self.focus.count - 1)
    {
        cell.isLastCell = YES;
    }else
    {
        cell.isLastCell = NO;
    }
    cell.model = self.focus[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
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
