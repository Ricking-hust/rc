//
//  RCAddScheduleViewController.m
//  rc
//
//  Created by AlanZhang on 16/3/19.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCAddScheduleViewController.h"
#import "CZUpView.h"
#import "CZDownView.h"
#import "RCScheduleInfoViewController.h"
#import "RCScrollView.h"
#import "LoginViewController.h"
#import "CZMoreRemindTimeViewController.h"
#import "RemindManager.h"
@interface RCAddScheduleViewController ()
@property (nonatomic, strong) PlanModel *model;
@property (nonatomic, strong) RCScrollView *timeNodeSVAdd;

@end
@implementation RCAddScheduleViewController
#pragma mark - 添加行程代理
- (void)passPlanListRanged:(NSMutableArray *)planListRanged
{
    self.planListRangedAdd = planListRanged;
}
- (void)passTimeNodeScrollView:(id)timeNodeSV
{
    self.timeNodeSVAdd = timeNodeSV;
}

#pragma mark - 懒加载

- (RCScrollView *)timeNodeSVAdd
{
    if (!_timeNodeSVAdd)
    {
        _timeNodeSVAdd = [[RCScrollView alloc]init];
    }
    return _timeNodeSVAdd;
}

- (NSMutableArray *)planListRangedAdd
{
    if (!_planListRangedAdd)
    {
        _planListRangedAdd = [[NSMutableArray alloc]init];
    }
    return _planListRangedAdd;
}
- (void)viewWillAppear:(BOOL)animated
{
    self.title = @"添加行程";
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initModel];
    
    [self setNavigation];
    
}
- (void)setNavigation
{
    UIImage *image = [UIImage imageNamed:@"backIcon"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    UIBarButtonItem *rigthButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(addSchedule)];
    [self.navigationItem setRightBarButtonItem:rigthButton];
}

-(void)initModel{
    self.model = [[PlanModel alloc]init];
    self.model.plAlarmOne = @"0";
    self.model.plAlarmTwo = @"0";
    self.model.plAlarmThree = @"0";
}

#pragma mark - remindView点击事件
- (void)onClickRemindView
{
    //收起键盘
    [self.downView.textView resignFirstResponder];
    
    CZMoreRemindTimeViewController *moreRemindTimeViewController = [[CZMoreRemindTimeViewController alloc]init];
    moreRemindTimeViewController.title = @"提醒时间";
    self.settingRemindDelegate = moreRemindTimeViewController;
    [self.settingRemindDelegate passModifySchedule:self.model];
    [self.navigationController pushViewController:moreRemindTimeViewController animated:YES];
    
}
#pragma mark - 行程添加的确认按钮
- (void)addSchedule
{
    [self.downView.textView resignFirstResponder];
    if (![self.downView.textView.text isEqualToString:@"请输入行程地点+内容(40字以内)"])
    {
        [self getscInfo];
        if (self.planListRangedAdd.count != 0)
        {
            [self insertSC:self.model];
        }else
        {
            NSArray *newsc = [[NSArray alloc]initWithObjects:self.model, nil];
            [self.planListRangedAdd addObject:newsc];
        }
        for (UIView *view in self.timeNodeSVAdd.subviews)
        {
            [view removeFromSuperview];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"timeNode" object:self.planListRangedAdd];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendTimeNodeScrollView" object:[[NSNumber alloc]initWithInt:0]];
        NSString *themeId = [self getThemeId:self.model.themeName];
        [[DataManager manager] addPlanWithOpType:@"1" planId:@"" userId:[userDefaults objectForKey:@"userId"] themeId:themeId planTime:self.model.planTime plAlarmOne:self.model.plAlarmOne plAlarmTwo:self.model.plAlarmTwo plAlarmThree:self.model.plAlarmThree planContent:self.model.planContent acPlace:self.model.acPlace success:^(NSString *replanId) {
            RemindManager *remindma = [[RemindManager alloc]init];
            //添加本地推送
            NSDate *date = [remindma dateFromString:self.model.planTime];
            if ([self.model.plAlarmOne isEqualToString:@"1"]) {
                NSDate *dateP1 = [NSDate dateWithTimeInterval:-3600 sinceDate:date];
                [remindma scheduleLocalNotificationWithDate:dateP1 Title:self.model.planContent notiID:replanId];
            }
            if ([self.self.model.plAlarmTwo isEqualToString:@"1"]) {
                NSDate *dateP2 = [NSDate dateWithTimeInterval:-86400 sinceDate:date];
                [remindma scheduleLocalNotificationWithDate:dateP2 Title:self.model.planContent notiID:replanId];
            }
            if ([self.self.model.plAlarmThree isEqualToString:@"1"]) {
                NSDate *dateP3 = [NSDate dateWithTimeInterval:-259200 sinceDate:date];
                [remindma scheduleLocalNotificationWithDate:dateP3 Title:self.model.planContent notiID:replanId];
            }
        } failure:^(NSError *error) {
            NSLog(@"Error:%@",error);
        }];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入内容" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确实" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }

}
- (void)insertSC:(PlanModel *)newModel
{
    int i;
    NSString *year = [self.downView.timeInfoLabel.text substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [self.downView.timeInfoLabel.text substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [self.downView.timeInfoLabel.text substringWithRange:NSMakeRange(8, 2)];
    NSString *time = [self.downView.timeInfoLabel.text substringWithRange:NSMakeRange(12, 5)];
    int currentDate = [[NSString stringWithFormat:@"%@%@%@",year, month, day] intValue];
    NSString *strCurrentDate = [NSString stringWithFormat:@"%@-%@-%@ %@",year,month,day,time];
    for (i = 0; i < self.planListRangedAdd.count; i++)
    {
        NSMutableArray *array = self.planListRangedAdd[i];
        PlanModel *model = [[PlanModel alloc]init];
        model = array.firstObject;
        
        NSString *year = [model.planTime substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [model.planTime substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [model.planTime substringWithRange:NSMakeRange(8, 2)];
        int dataCmp = [[NSString stringWithFormat:@"%@%@%@",year, month, day] intValue];
        if (currentDate < dataCmp)
        {//比当前时间早
            if (i == 0)
            {
                NSMutableArray *newscArray = [[NSMutableArray alloc]init];
                newModel.planTime = strCurrentDate;
                [newscArray addObject:newModel];
                [self.planListRangedAdd insertObject:newscArray atIndex:i];
                break;
            }else
            {
                NSMutableArray *newscArray = [[NSMutableArray alloc]init];
                newModel.planTime = strCurrentDate;
                [newscArray addObject:newModel];
                [self.planListRangedAdd insertObject:newscArray atIndex:i];
                break;
            }
        }else if (currentDate > dataCmp)
        {//比当前时间晚
            //continue;
        }else
        {
            NSMutableArray *newscArray = [[NSMutableArray alloc]initWithArray:self.planListRangedAdd[i]];
            newModel.planTime = strCurrentDate;
            [newscArray addObject:newModel];
            [self.planListRangedAdd removeObjectAtIndex:i];
            [self.planListRangedAdd insertObject:newscArray atIndex:i];
            break;
        }
    }
    if (i == self.planListRangedAdd.count)
    {
        NSMutableArray *newscArray = [[NSMutableArray alloc]init];
        newModel.planTime = strCurrentDate;
        [newscArray addObject:newModel];
        [self.planListRangedAdd addObject:newscArray];
    }
    
}

-(NSString *)getThemeId:(NSString *)theme{
    NSString *themeId = [[NSString alloc]init];
    if ([theme isEqualToString:@"会议"]) {
        themeId = @"1";
    } else if ([theme isEqualToString:@"约会"]){
        themeId = @"2";
    } else if ([theme isEqualToString:@"出差"]){
        themeId = @"3";
    } else if ([theme isEqualToString:@"运动"]){
        themeId = @"4";
    } else if ([theme isEqualToString:@"购物"]){
        themeId = @"5";
    } else if ([theme isEqualToString:@"娱乐"]){
        themeId = @"6";
    } else if ([theme isEqualToString:@"聚会"]){
        themeId = @"7";
    } else if ([theme isEqualToString:@"其他"]){
        themeId = @"8";
    }
    return themeId;
}

- (void)getscInfo
{
    self.model.planId = [NSString stringWithFormat:@"%d",10];
    self.model.planContent = self.downView.textView.text;
    NSString *year = [self.downView.timeInfoLabel.text substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [self.downView.timeInfoLabel.text substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [self.downView.timeInfoLabel.text substringWithRange:NSMakeRange(8, 2)];
    NSString *time = [self.downView.timeInfoLabel.text substringWithRange:NSMakeRange(12, 5)];
    self.model.planTime = [NSString stringWithFormat:@"%@-%@-%@ %@",year, month, day, time];
    self.model.userId = @"1";
    self.model.acId = @"1";
    self.model.themeName = self.upView.themeNameLabel.text;
    self.model.acPlace = @"";
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
