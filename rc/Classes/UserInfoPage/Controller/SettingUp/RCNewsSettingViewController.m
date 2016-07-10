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
#import <RongIMKit/RongIMKit.h>
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
    
    return 2;
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
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *view = [[UIView alloc]init];
        UILabel *label = [[UILabel alloc]init];
        label.text = @"请在iPhone的“设置”-“通知”中进行修改";
        label.font = [UIFont systemFontOfSize:12];
        [view addSubview:label];
        [label setTextColor:[UIColor colorWithRed:38.0/255.0 green:40.0/255.0 blue:50.0/255.0 alpha:0.5]];
        CGSize size = [self sizeWithText:label.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:12];
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(view).offset(10);
            make.width.mas_equalTo((int)size.width+1);
            make.height.mas_equalTo((int)size.height+1);
        }];
        return view;
    }else
    {
        UIView *view = [[UIView alloc]init];
        UILabel *label = [[UILabel alloc]init];
        label.text = @"当日常在运行时，接收新消息时你可以设置是否需要声音";
        label.font = [UIFont systemFontOfSize:12];
        [view addSubview:label];
        [label setTextColor:[UIColor colorWithRed:38.0/255.0 green:40.0/255.0 blue:50.0/255.0 alpha:0.5]];
        CGSize size = [self sizeWithText:label.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:12];
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(view).offset(10);
            make.width.mas_equalTo((int)size.width+1);
            make.height.mas_equalTo((int)size.height+1);
        }];
        return view;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        CGSize size = [self sizeWithText:@"请在iPhone的“设置”-“通知”中进行修改" maxSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT) fontSize:12];
        return size.height + 20;
    }else
    {
        CGSize size = [self sizeWithText:@"当日常在运行时，接收新消息时你可以设置是否需要声音" maxSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT) fontSize:12];
        return size.height + 20;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        UILabel *label = [[UILabel alloc]init];
        label.alpha = 0.8;
        label.text = @"新消息通知";
        label.font = [UIFont systemFontOfSize:14];
        [cell addSubview:label];
        [label mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.left.equalTo(cell.mas_left).offset(10);
            make.width.mas_equalTo(100);
            make.height.mas_equalTo(20);
        }];

        UILabel *hint = [[UILabel alloc]init];
        hint.font = [UIFont systemFontOfSize:14];
        [hint setTextColor:[UIColor colorWithRed:38.0/255.0 green:40.0/255.0 blue:50.0/255.0 alpha:0.5]];
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIUserNotificationTypeNone)
        {
            hint.text = @"未开启";
        }else
        {
            hint.text = @"已开启";
        }
        [cell addSubview:hint];
        CGSize size = [self sizeWithText:hint.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:14];
        [hint mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell);
            make.right.equalTo(cell).offset(-10);
            make.height.mas_equalTo((int)size.height);
            make.width.mas_equalTo((int)size.width);
        }];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else
    {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        UILabel *label = [[UILabel alloc]init];
        label.alpha = 0.8;
        label.text = @"新消息通知";
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
        if ([RCIM sharedRCIM].disableMessageAlertSound == YES)
        {
            s.on = NO;
        }else
        {
            s.on = YES;
        }
        [s mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.mas_centerY);
            make.right.equalTo(cell.mas_right).offset(-10);
            make.width.mas_equalTo(51);
            make.height.mas_equalTo(31);
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
#pragma mark - 监听消息通知的开关
- (void)onSwitchValueChanged:(UISwitch *)s
{
    if (s.on)
    {
        [[RCIM sharedRCIM] setDisableMessageAlertSound:NO];
    }else
    {
        [[RCIM sharedRCIM] setDisableMessageAlertSound:YES];
    }
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

/**
 *  计算字体的长和宽
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
