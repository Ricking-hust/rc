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
- (PlanModel *)model
{
    if (!_model)
    {
        _model = [[PlanModel alloc]init];
    }
    return _model;
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
#pragma mark - 行程添加的确认按钮
- (void)addSchedule
{
    
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
        [self.navigationController popViewControllerAnimated:YES];
        
    }else
    {
        
        if ([self.downView.textView.text isEqualToString:@""]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入内容" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            [[DataManager manager] addPlanWithOpType:@"1" planId:@"" userId:[userDefaults objectForKey:@"userId"] themeId:@"" planTime:@"" plAlarmOne:@"" plAlarmTwo:@"" plAlarmThree:@"" planContent:self.downView.textView.text acPlace:@"" success:^(NSString *msg) {
                
            } failure:^(NSError *error) {
                NSLog(@"Error:%@",error);
            }];
        }
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

- (void)getscInfo
{
    self.model.planId = [NSString stringWithFormat:@"%d",10];
    self.model.planContent = self.downView.textView.text;
    self.model.planTime = self.downView.timeInfoLabel.text;
    self.model.plAlarmOne = @"1";
    self.model.plAlarmTwo = @"1";
    self.model.plAlarmThree = @"1";
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
