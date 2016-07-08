//
//  RCMyReleaseViewController.m
//  rc
//
//  Created by AlanZhang on 16/5/23.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCMyReleaseViewController.h"
#import "RCNetworkingRequestOperationManager.h"
#import "RCHomeRefreshHeader.h"
#import "MJRefresh.h"
#import "UserActivity.h"
#import "ActivityModel.h"
#import "CZActivityCell.h"
#import "Masonry.h"

typedef NS_ENUM(NSInteger, RefleshType)
{
    RCRefleshNone = 0,  //不刷新
    RCRefleshUp   = 1,  //上拉刷新
    RCRefleshDown = 2   //下拉刷新
};
@interface RCMyReleaseViewController()
@property (nonatomic, strong) NSMutableArray *releasedAc;
@property (nonatomic, strong) NSMutableArray *checkingAc;
@property (nonatomic, strong) NSMutableArray *notPassAC;
@property (nonatomic, strong) NSMutableArray *acList;
@property (nonatomic, strong) UIView  *heartBrokenView;
@property (nonatomic, strong) UIButton  *currentButton;

@end
@implementation RCMyReleaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigation];
    [self createButtons];
    [self getReleasedActivity];
    self.currentButton = self.releasedButton; //当前顶部按钮默认为已发布
    self.tableView.mj_header = [RCHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer= [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
}
- (void)loadNewData
{
    NSString *usr_id = [userDefaults objectForKey:@"userId"];
    NSDictionary *parameters;
    
    if ([self.currentButton.titleLabel.text isEqualToString:@"已发布"])
    {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:usr_id,@"usr_id",@"3",@"op_type",@"1",@"ac_catalog", nil];
    }else if ([self.currentButton.titleLabel.text isEqualToString:@"待审核"])
    {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:usr_id,@"usr_id",@"3",@"op_type",@"2",@"ac_catalog", nil];
    }else
    {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:usr_id,@"usr_id",@"3",@"op_type",@"3",@"ac_catalog", nil];
    }
    
    [self sendURLRequest:parameters refleshState:RCRefleshDown];
    
}
- (void)getMoreData
{
    NSString *usr_id = [userDefaults objectForKey:@"userId"];
    UserActivity *lastActivity = self.acList.lastObject;
    NSString *start_id = lastActivity.ac_id;
    if (start_id == nil)
    {
        start_id = @"";
    }
    NSDictionary *parameters;
    
    if ([self.currentButton.titleLabel.text isEqualToString:@"已发布"])
    {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:usr_id,@"usr_id",@"3",@"op_type",@"1",@"ac_catalog",start_id, @"start_id", nil];
    }else if ([self.currentButton.titleLabel.text isEqualToString:@"待审核"])
    {
        if (self.acList.count == 0 || self.acList == nil)
        {
            self.heartBrokenView.hidden = NO;
        }else
        {
            self.heartBrokenView.hidden = YES;
        }
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:usr_id,@"usr_id",@"3",@"op_type",@"2",@"ac_catalog",start_id, @"start_id", nil];
    }else
    {
        parameters = [NSDictionary dictionaryWithObjectsAndKeys:usr_id,@"usr_id",@"3",@"op_type",@"3",@"ac_catalog",start_id, @"start_id", nil];
    }

    [self sendURLRequest:parameters refleshState:RCRefleshUp];
}

//18812345678
//123456
- (void)getReleasedActivity
{
    NSString *usr_id = [userDefaults objectForKey:@"userId"];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:usr_id,@"usr_id",@"3",@"op_type",@"1",@"ac_catalog", nil];
    [self sendURLRequest:parameters refleshState:RCRefleshNone];
}
- (void)getCheckingActivity
{

    NSString *usr_id = [userDefaults objectForKey:@"userId"];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:usr_id,@"usr_id",@"3",@"op_type",@"2",@"ac_catalog", nil];
    [self sendURLRequest:parameters refleshState:RCRefleshNone];
}
- (void)getNotPassActivity
{
    NSString *usr_id = [userDefaults objectForKey:@"userId"];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:usr_id,@"usr_id",@"3",@"op_type",@"3",@"ac_catalog", nil];
    [self sendURLRequest:parameters refleshState:RCRefleshNone];
}

- (void)sendURLRequest:(NSDictionary *)parameters refleshState:(RefleshType)refleshType
{
    NSString *urlStr = @"http://appv2.myrichang.com/home/Person/getUserActivity";
    NetWorkingRequestType type = GET;
    if (refleshType == RCRefleshNone)
    {
        [RCNetworkingRequestOperationManager request:urlStr requestType:type parameters:parameters completeBlock:^(NSData *data) {
            id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            if ([[parameters valueForKey:@"ac_catalog"]isEqualToString:@"1"])
            {//获取的为已发布的活动
                self.releasedAc = [self initacListWithDict:dict];
                [self reloadTableViewFrom:self.releasedAc];
            }else if ([[parameters valueForKey:@"ac_catalog"]isEqualToString:@"2"])
            {//获取的为待审核的活动
                self.checkingAc = [self initacListWithDict:dict];
                [self reloadTableViewFrom:self.checkingAc];
            }else
            {//获取的为未通过审核的活动
                self.notPassAC = [self initacListWithDict:dict];
                [self reloadTableViewFrom:self.notPassAC];
            }
            
        } errorBlock:^(NSError *error) {
            NSLog(@"网络请求失败:%@",error);
        }];
    }else if(refleshType == RCRefleshUp)
    {//上拉刷新
        [RCNetworkingRequestOperationManager request:urlStr requestType:type parameters:parameters completeBlock:^(NSData *data) {
            id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSMutableArray *temp = [self initacListWithDict:dict];
            if ([self.currentButton.titleLabel.text isEqualToString:@"已发布"])
            {//刷新已发布
                if (temp == nil || temp.count == 0)
                {
                    
                    [self getReleasedActivity];
                }else
                {
                    for (UserActivity *ac in temp)
                    {
                        [self.releasedAc addObject:ac];
                    }
                    self.acList = [[NSMutableArray alloc]initWithArray:self.releasedAc ];
                    [self.tableView reloadData];
                    self.heartBrokenView.hidden = YES;
                }

            }else if ([self.currentButton.titleLabel.text isEqualToString:@"待审核"])
            {//刷新待审核
                if (temp == nil || temp.count == 0)
                {
                    [self getCheckingActivity];
                }else
                {
                    for (UserActivity *ac in temp)
                    {
                        [self.checkingAc addObject:ac];
                    }
                    self.acList = [[NSMutableArray alloc]initWithArray:self.checkingAc ];
                    [self.tableView reloadData];
                    self.heartBrokenView.hidden = YES;
                }
            }else
            {//刷新未通过
                if (temp == nil || temp.count == 0)
                {
                    [self getNotPassActivity];
                }else
                {
                    for (UserActivity *ac in temp)
                    {
                        [self.notPassAC addObject:ac];
                    }
                    self.acList = [[NSMutableArray alloc]initWithArray:self.notPassAC ];
                    [self.tableView reloadData];
                    self.heartBrokenView.hidden = YES;
                }
            }
            [self.tableView.mj_footer endRefreshing];
        } errorBlock:^(NSError *error) {
            NSLog(@"网络请求失败:%@",error);
            [self.tableView.mj_footer endRefreshing];
        }];

    }else
    {//下拉刷新
        [RCNetworkingRequestOperationManager request:urlStr requestType:type parameters:parameters completeBlock:^(NSData *data) {
            id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

            if ([self.currentButton.titleLabel.text isEqualToString:@"已发布"])
            {//刷新已发布

                self.releasedAc = [self initacListWithDict:dict];
                [self reloadTableViewFrom:self.releasedAc];

            }else if ([self.currentButton.titleLabel.text isEqualToString:@"待审核"])
            {//刷新待审核
                self.checkingAc = [self initacListWithDict:dict];
                [self reloadTableViewFrom:self.checkingAc];

            }else
            {//刷新未通过
                self.notPassAC = [self initacListWithDict:dict];
                [self reloadTableViewFrom:self.notPassAC];
            }
            [self.tableView.mj_header endRefreshing];
        } errorBlock:^(NSError *error) {
            NSLog(@"网络请求失败:%@",error);
            [self.tableView.mj_header endRefreshing];
        }];
    }
}
//刷新tableView
- (void)reloadTableViewFrom:(NSMutableArray *)sourceArray
{
    if (sourceArray.count == 0 || sourceArray == nil)
    {
        self.heartBrokenView.hidden = NO;
        
    }else
    {
        self.heartBrokenView.hidden = YES;
    }
    self.acList = [[NSMutableArray alloc]initWithArray:sourceArray];
    [self.tableView reloadData];
    
}
- (NSMutableArray *)initacListWithDict:(NSDictionary *)dict
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
    }else if ([code isEqualToNumber:[[NSNumber alloc]initWithInt:220]])
    {//返回失败:操作类型无效或用户ID为空
        NSLog(@"错误信息来自我的收藏:%@",[dict valueForKey:@"msg"]);
        return nil;
    }else
    {
        NSLog(@"发生未知错误");
        return nil;
    }
    
}
- (UserActivity *)userActivityfromDict:(NSDictionary *)dict
{
    UserActivity *usr_ac = [[UserActivity alloc]init];
    usr_ac.ac_id = [dict valueForKey:@"ac_id"];
    usr_ac.ac_title = [dict valueForKey:@"ac_title"];
    usr_ac.ac_poster = [dict valueForKey:@"ac_poster"];
    usr_ac.ac_poster_top = [dict valueForKey:@"ac_poster_top"];
    usr_ac.ac_desc = [dict valueForKey:@"ac_desc"];
    usr_ac.theme_name = [dict valueForKey:@"theme_name"];
    usr_ac.ac_time = [dict valueForKey:@"ac_time"];
    usr_ac.ac_sustain_time = [dict valueForKey:@"ac_sustain_time"];
    usr_ac.ac_place = [dict valueForKey:@"ac_place"];
    usr_ac.ac_size = [dict valueForKey:@"ac_size"];
    usr_ac.ac_pay = [dict valueForKey:@"ac_pay"];
    usr_ac.usr_id = [dict valueForKey:@"usr_id"];
    usr_ac.ac_type = [dict valueForKey:@"ac_type"];
    usr_ac.usr_pic = [dict valueForKey:@"usr_pic"];
    usr_ac.usr_name = [dict valueForKey:@"usr_name"];
    usr_ac.ac_tags = [dict valueForKey:@"ac_tags"];
    
    return usr_ac;
}
//- (void)setReleasedAc:(NSMutableArray *)releasedAc
//{
//    _releasedAc = releasedAc;
//    if (_releasedAc == nil || [_releasedAc count] == 0)
//    {
//        self.heartBrokenView.hidden = NO;
//        //self.tableView.hidden = YES;
//    }else
//    {
//        self.heartBrokenView.hidden = YES;
//        //self.tableView.hidden = NO;
//        self.acList = [[NSMutableArray alloc]initWithArray:_releasedAc];
//        [self.tableView reloadData];
//    }
//}
//- (void)setCheckingAc:(NSMutableArray *)checkingAc
//{
//    _checkingAc = checkingAc;
//    if (_checkingAc == nil || [_checkingAc count] == 0)
//    {
//        self.heartBrokenView.hidden = NO;
//        //self.tableView.hidden = YES;
//    }else
//    {
//        self.heartBrokenView.hidden = YES;
//        //self.tableView.hidden = NO;
//        self.acList = [[NSMutableArray alloc]initWithArray:_checkingAc];
//        [self.tableView reloadData];
//    }
//}
//- (void)setNotPassAC:(NSMutableArray *)notPassAC
//{
//    _notPassAC = notPassAC;
//    if (_notPassAC == nil || [_notPassAC count] == 0)
//    {
//        self.heartBrokenView.hidden = NO;
//        //self.tableView.hidden = YES;
//    }else
//    {
//        self.heartBrokenView.hidden = YES;
//        //self.tableView.hidden = NO;
//        self.acList = [[NSMutableArray alloc]initWithArray:_notPassAC];
//        [self.tableView reloadData];
//    }
//}
#pragma mark - tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.acList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

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
    return 130;
}
//给单元格进行赋值
- (void) setCellValue:(CZActivitycell *)cell AtIndexPath:(NSIndexPath *)indexPath
{

    UserActivity *user_ac = self.acList[indexPath.section];
    [cell.ac_poster sd_setImageWithURL:[NSURL URLWithString:user_ac.ac_poster] placeholderImage:[UIImage imageNamed:@"img_1"]];
    cell.ac_title.text = user_ac.ac_title;
    NSString *time = [user_ac.ac_time substringWithRange:NSMakeRange(0, [user_ac.ac_time length] - 3)];
    cell.ac_time.text = [NSString stringWithFormat:@"时间：%@",time];
    cell.ac_place.text = [NSString stringWithFormat:@"地点：%@",user_ac.ac_place];
    [cell.ac_type setImage:[UIImage imageNamed:@"biaoqian_icon"] forState:UIControlStateNormal];
    [cell.ac_type setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [cell.ac_type setTitle:@"免费活动" forState:UIControlStateNormal];
    [cell.ac_praise setImage:[UIImage imageNamed:@"eye_ icon"] forState:UIControlStateNormal];
    [cell.ac_praise setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    [cell.ac_praise setTitle:@"10000+" forState:UIControlStateNormal];
}

//设置导航栏
- (void)setNavigation
{
    self.navigationItem.title = @"我的发布";
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
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
    
    self.releasedButton = [[UIButton alloc]init];
    self.releasedButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.releasedButton setTitle:@"已发布" forState:UIControlStateNormal];
    [self.releasedButton setTitleColor:nonSelectedColor forState:UIControlStateNormal];
    [self.releasedButton setTitleColor:selecteColor forState:UIControlStateSelected];
    self.releasedButton.selected = YES;
    
    self.checkingButton = [[UIButton alloc]init];
    self.checkingButton.titleLabel.font = self.releasedButton.titleLabel.font;
    [self.checkingButton setTitle:@"待审核" forState:UIControlStateNormal];
    [self.checkingButton setTitleColor:nonSelectedColor forState:UIControlStateNormal];
    [self.checkingButton setTitleColor:selecteColor forState:UIControlStateSelected];
    
    self.notPassButton = [[UIButton alloc]init];
    self.notPassButton.titleLabel.font = self.releasedButton.titleLabel.font;
    [self.notPassButton setTitle:@"未通过" forState:UIControlStateNormal];
    [self.notPassButton setTitleColor:nonSelectedColor forState:UIControlStateNormal];
    [self.notPassButton setTitleColor:selecteColor forState:UIControlStateSelected];
    
    self.lineDownOfReleasedButton = [[UIView alloc]init];
    self.lineDownOfCheckingButton = [[UIView alloc]init];
    self.lineDownOfNotPassButton = [[UIView alloc]init];
    self.lineDownOfReleasedButton.backgroundColor = selecteColor;
    self.lineDownOfCheckingButton.backgroundColor = selecteColor;
    self.lineDownOfNotPassButton.backgroundColor = selecteColor;

    self.lineDownOfCheckingButton.hidden = YES;
    self.lineDownOfNotPassButton.hidden = YES;
    
    [self.releasedButton addTarget:self action:@selector(checkButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.checkingButton addTarget:self action:@selector(checkButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.notPassButton addTarget:self action:@selector(checkButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.superOfButtons];
    [self.superOfButtons addSubview:self.releasedButton];
    [self.superOfButtons addSubview:self.checkingButton];
    [self.superOfButtons addSubview:self.notPassButton];
    [self.superOfButtons addSubview:self.lineDownOfReleasedButton];
    [self.superOfButtons addSubview:self.lineDownOfCheckingButton];
    [self.superOfButtons addSubview:self.lineDownOfNotPassButton];
    
    [self.superOfButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).with.offset(64 + 2);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(35);
    }];
    
    CGFloat padding = kScreenWidth * 0.12;
    
    CGSize buttonSize = CGSizeMake(45, 30);
    [self.releasedButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.superOfButtons);
        make.size.mas_equalTo(buttonSize);
        make.left.equalTo(self.superOfButtons.mas_left).with.offset(padding);
    }];
    [self.lineDownOfReleasedButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.releasedButton.mas_left);
        make.bottom.equalTo(self.superOfButtons.mas_bottom);
        make.right.equalTo(self.releasedButton.mas_right);
        make.height.mas_equalTo(2);
    }];
    [self.checkingButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.superOfButtons);
        make.size.mas_equalTo(buttonSize);
    }];
    [self.lineDownOfCheckingButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkingButton.mas_left);
        make.bottom.equalTo(self.superOfButtons.mas_bottom);
        make.right.equalTo(self.checkingButton.mas_right);
        make.height.mas_equalTo(2);
    }];
    [self.notPassButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.superOfButtons);
        make.size.mas_equalTo(buttonSize);
        make.right.equalTo(self.superOfButtons.mas_right).with.offset(-padding);

    }];
    [self.lineDownOfNotPassButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.notPassButton.mas_left);
        make.bottom.equalTo(self.superOfButtons.mas_bottom);
        make.right.equalTo(self.notPassButton.mas_right);
        make.height.mas_equalTo(2);

    }];
    //创建tabelView
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.superOfButtons.mas_bottom);
    }];
}
#pragma mark - 待审核与已审核按钮点击事件
- (void)checkButton:(UIButton *)btn
{
    self.releasedButton.selected = NO;
    self.checkingButton.selected = NO;
    self.notPassButton.selected = NO;
    NSArray *buttons = @[self.releasedButton, self.checkingButton, self.notPassButton];
    if ([btn.titleLabel.text isEqualToString:@"已发布"])
    {

        self.lineDownOfReleasedButton.hidden = NO;
        self.lineDownOfCheckingButton.hidden = YES;
        self.lineDownOfNotPassButton.hidden = YES;
        
    }else if ([btn.titleLabel.text isEqualToString:@"待审核"])
    {
        self.lineDownOfReleasedButton.hidden = YES;
        self.lineDownOfCheckingButton.hidden = NO;
        self.lineDownOfNotPassButton.hidden = YES;
    }
    else
    {
        self.lineDownOfNotPassButton.hidden = NO;
        self.lineDownOfCheckingButton.hidden = YES;
        self.lineDownOfReleasedButton.hidden = YES;
        
    }
    btn.selected = YES;
    self.currentButton = btn;
    //to do here--------------------------------
    //清空acList刷新tableView
    [self.acList removeAllObjects];
    [self.tableView reloadData];
    for (UIButton *button in buttons)
    {
        if (button.selected == YES)
        {
            if ([button.titleLabel.text isEqualToString:@"已发布"])
            {
                [self getReleasedActivity];
                
            }else if ([button.titleLabel.text isEqualToString:@"待审核"])
            {
                [self getCheckingActivity];
            }
            else
            {
                [self getNotPassActivity];
            }
            
        }
    }
}

- (UIView *)heartBrokenView
{
    if (!_heartBrokenView)
    {
        _heartBrokenView = [[UIView alloc]init];
        [self.view addSubview:_heartBrokenView];
        UIImageView *imgeView = [[UIImageView alloc]init];
        imgeView.image = [UIImage imageNamed:@"heartbrokenIcon"];
        [_heartBrokenView addSubview:imgeView];
        
        [imgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_heartBrokenView.mas_centerX);
            make.top.equalTo(_heartBrokenView.mas_top);
            make.size.mas_equalTo(imgeView.image.size);
        }];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"您还没有发布活动哟。";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
        [_heartBrokenView addSubview:label];
        CGSize labelSize = [self sizeWithText:label.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:14];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgeView.mas_bottom).offset(10);
            make.centerX.equalTo(imgeView.mas_centerX).offset(10);
            make.width.mas_equalTo(labelSize.width+1);
            make.height.mas_equalTo(labelSize.height+1);
        }];
        [_heartBrokenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view);
            make.height.mas_equalTo(imgeView.image.size.height+labelSize.height+1+10);
            make.width.mas_equalTo(imgeView.image.size.width>labelSize.width?imgeView.image.size.width:labelSize.width+1);
        }];
        
    }
    return _heartBrokenView;
}
/**
 *  计算文本的大小
 *
 *  @param text 待计算大小的字符串
 *
 *  @param fontSize 指定绘制字符串所用的字体大小
 *
 *  @return 字符串的大小
 */
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
}
@end
