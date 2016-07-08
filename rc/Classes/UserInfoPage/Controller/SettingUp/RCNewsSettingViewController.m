//
//  RCNewsNoteViewController.m
//  rc
//
//  Created by AlanZhang on 16/3/24.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCNewsSettingViewController.h"
#import "LoginViewController.h"
#import "Masonry.h"
@interface RCNewsSettingViewController()
@property (nonatomic, strong) PlanList *planList;
@property (nonatomic, strong) NSMutableArray *planListRanged;
@property (nonatomic, copy) NSURLSessionDataTask *(^getPlanListBlock)();
@end
@implementation RCNewsSettingViewController
-(NSMutableArray *)planListRanged{
    if (!_planListRanged) {
        _planListRanged = [[NSMutableArray alloc]init];
    }
    return _planListRanged;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    if ([DataManager manager].user.isLogin)
//    {
//        self.getPlanListBlock();
//    } else {
//        [self showLoginOrNotView];
//    }
}
//-------
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [self setNavigation];
//    [self configureBlocks];
}
-(void)configureBlocks{
    @weakify(self);
    self.getPlanListBlock = ^(){
        @strongify(self);
        return [[DataManager manager] getPlanWithUserId:[userDefaults objectForKey:@"userId"] beginDate:@"2016-01-01" endDate:@"2016-12-31" success:^(PlanList *plList) {
            @strongify(self);
            self.planList = plList;
        } failure:^(NSError *error) {
            NSLog(@"Error:%@",error);
        }];
    };
}
-(void)setPlanList:(PlanList *)planList{
    _planList = planList;
    
    [self rangePlanList:self.planList];
}
-(void)rangePlanList:(PlanList *)planList{
    if (planList.list.count != 0) {
        PlanModel *rPlModel = planList.list[0];
        NSString *defaultStr = [rPlModel.planTime substringWithRange:NSMakeRange(5, 5)];
        int i = 0;
        self.planListRanged[0] = [[NSMutableArray alloc]init];
        for (PlanModel *planModel in planList.list) {
            if ([planModel.planTime substringWithRange:NSMakeRange(5, 5)] == defaultStr) {
                [self.planListRanged[i] addObject:planModel];
            }else{
                i = i+1;
                self.planListRanged[i] = [[NSMutableArray alloc]init];
                defaultStr = [planModel.planTime substringWithRange:NSMakeRange(5, 5)];
                [self.planListRanged[i] addObject:planModel];
            }
        }
    } else {
        self.planListRanged = nil;
    }
}

- (void)setNavigation
{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
}
- (void)backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    UILabel *label = [[UILabel alloc]init];
    label.alpha = 0.8;
    label.text = @"消息通知";
    label.font = [UIFont systemFontOfSize:14];
    [cell addSubview:label];
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.left.equalTo(cell.mas_left).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    UISwitch *s = [[UISwitch alloc]init];
    [s addTarget:self action:@selector(onSwitchValueChanged:) forControlEvents:UIControlEventValueChanged]; // 添加事件监听器的方法
    [cell addSubview:s];
    [s mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.mas_centerY);
        make.right.equalTo(cell.mas_right).offset(-10);
        make.width.mas_equalTo(51);
        make.height.mas_equalTo(31);
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
#pragma mark - 监听消息通知的开关
- (void)onSwitchValueChanged:(UISwitch *)s
{
    if (s.on)
    {
        NSLog(@"on");
        [self settingNotification];
    }else
    {
        NSLog(@"off");
    }
}
- (void)settingNotification
{
    
    if ([[UIApplication sharedApplication]currentUserNotificationSettings].types != UIUserNotificationTypeNone)
    {
        
        //[self addLocalNotification];
    }else
    {
        [[UIApplication sharedApplication]registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound  categories:nil]];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(void)showLoginOrNotView{
    
    UIAlertController *chooseView = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录，是否登录" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *configureController = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        LoginViewController *loginViewController = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }];
    
    [chooseView addAction:cancelAction];
    [chooseView addAction:configureController];
    
    [self presentViewController:chooseView animated:YES completion:nil];
}

@end
