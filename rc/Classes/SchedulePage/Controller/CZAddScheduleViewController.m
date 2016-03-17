//
//  CZAddScheduleViewController.m
//  rc
//
//  Created by AlanZhang on 16/2/14.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZAddScheduleViewController.h"
#import "CZScheduleViewController.h"
#import "CZData.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationSlide.h"
#import "Masonry.h"
#import "CZUpView.h"
#import "CZDownView.h"
#import "PlanModel.h"
#import "CZScheduleTableViewDelegate.h"
#define FONTSIZE    14  //字体大小

@interface CZAddScheduleViewController ()
@property (nonatomic, strong)PlanModel *model;
@property (nonatomic, assign)BOOL isNewDay;

@end

@implementation CZAddScheduleViewController
- (NSArray *)scArray
{
    if (!_scArray)
    {
        _scArray = [[NSArray alloc]init];
    }
    return _scArray;
}
- (BOOL)isNewDay
{
    if (!_isNewDay)
    {
        _isNewDay = YES;
    }
    return _isNewDay;
}
- (NSMutableArray *)planListRanged
{
    if (!_planListRanged)
    {
        _planListRanged = [[NSMutableArray alloc]init];
    }
    return _planListRanged;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setNavigation];


}
- (void)viewWillAppear:(BOOL)animated
{
    
}
- (void)setNavigation
{
    UIImage *image = [UIImage imageNamed:@"backIcon"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    UIBarButtonItem *rigthButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(addSchedule)];
    [self.navigationItem setRightBarButtonItem:rigthButton];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 行程添加的确认按钮
- (void)addSchedule
{

    if (![self.downView.textView.text isEqualToString:@"请输入行程地点+内容(40字以内)"])
    {
        PlanModel *model = [[PlanModel alloc]init];
        model.planId = [NSString stringWithFormat:@"%ld",self.scArray.count];
        model.planContent = self.downView.textView.text;
        model.planTime = self.downView.timeInfoLabel.text;
        model.plAlarmOne = @"1";
        model.plAlarmTwo = @"1";
        model.plAlarmThree = @"1";
        model.userId = @"1";
        model.acId = @"1";
        model.themeName = self.upView.themeNameLabel.text;
        model.acPlace = @"";
        NSLog(@"%ld",self.planListRangedUpdate.count);
        if (self.planListRanged.count != 0)
        {
            long int count = self.navigationController.viewControllers.count;
            CZScheduleViewController *sc = self.navigationController.viewControllers[count -2];
            sc.scIndex = self.timeNodeIndex;
            [self insertSC:model];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scArray" object:self.planListRanged[self.timeNodeIndex]];
        }else
        {
            NSArray *newsc = [[NSArray alloc]initWithObjects:model, nil];
            [self.planListRanged addObject:newsc];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scArray" object:self.planListRanged.firstObject];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addNode" object:self.planListRanged];
        }

        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入内容" preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];

        [alert addAction:okAction];
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
    for (i = 0; i < self.planListRanged.count; i++)
    {
        NSMutableArray *array = self.planListRanged[i];
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
                [self.planListRanged insertObject:newscArray atIndex:i];
                break;
            }else
            {
                NSMutableArray *newscArray = [[NSMutableArray alloc]init];
                newModel.planTime = strCurrentDate;
                [newscArray addObject:newModel];
                [self.planListRanged insertObject:newscArray atIndex:i];
                break;
            }
        }else if (currentDate > dataCmp)
        {//比当前时间晚
            //continue;
        }else
        {
            NSMutableArray *newscArray = [[NSMutableArray alloc]initWithArray:self.planListRanged[i]];
            newModel.planTime = strCurrentDate;
            [newscArray addObject:newModel];
            [self.planListRanged removeObjectAtIndex:i];
            [self.planListRanged insertObject:newscArray atIndex:i];
            self.scArray = self.planListRanged[i];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scArray" object:self.scArray];
            break;
        }
    }
    if (i == self.planListRanged.count)
    {
        NSMutableArray *newscArray = [[NSMutableArray alloc]init];
        newModel.planTime = strCurrentDate;
        [newscArray addObject:newModel];
        [self.planListRanged addObject:newscArray];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"timeNode" object:self.planListRanged];
    
}

- (NSString *)getTag
{
    NSString *tag;

    if ([self.upView.themeNameLabel.text isEqualToString:@"运动"])
    {
        tag = @"sportIcon";
    }else if ([self.upView.themeNameLabel.text isEqualToString:@"约会"])
    {
        tag = @"appointmentIcon";
    }else if ([self.upView.themeNameLabel.text isEqualToString:@"出差"])
    {
        tag = @"businessIcon";
    }else if ([self.upView.themeNameLabel.text isEqualToString:@"会议"])
    {
        tag = @"meetingIcon";
    }else if ([self.upView.themeNameLabel.text isEqualToString:@"购物"])
    {
        tag = @"shoppingIcon";
    }else if ([self.upView.themeNameLabel.text isEqualToString:@"娱乐"])
    {
        tag = @"entertainmentIcon";
    }else if ([self.upView.themeNameLabel.text isEqualToString:@"聚会"])
    {
        tag = @"partIcon";
    }else
    {
        tag = @"otherIcon";
    }
    
    return tag;
}
- (NSString *)getDay
{
    //NSString *day = [[NSString alloc]init];
    NSString *month = [[NSString alloc]init];
    NSRange rangeOfMonth = NSMakeRange(5, 2);
    month = [self.downView.timeInfoLabel.text substringWithRange:rangeOfMonth];
    
    NSRange rangeOfDay = NSMakeRange(8, 2);
    NSString *day = [self.downView.timeInfoLabel.text substringWithRange:rangeOfDay];
    return [NSString stringWithFormat:@"%@.%@",month, day];
}
- (NSString *)getTime
{
    NSString *time = [[NSString alloc]init];
    long int length = [self.downView.timeInfoLabel.text length];
    time = [self.downView.timeInfoLabel.text substringFromIndex:length - 6];
    
    return time;
}
- (NSString *)getWeek
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    
    NSRange rangeOfFulltime = NSMakeRange(0, 11);
    NSString *fullTime = [self.downView.timeInfoLabel.text substringWithRange:rangeOfFulltime];
    
    return [self weekdayStringFromDate:[formatter dateFromString:fullTime]];;
}


- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
