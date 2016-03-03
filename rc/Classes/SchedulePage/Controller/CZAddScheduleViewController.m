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
#define FONTSIZE    14  //字体大小

@interface CZAddScheduleViewController ()


@end

@implementation CZAddScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
//行程添加的确认按钮
- (void)addSchedule
{

    if (![self.downView.textView.text isEqualToString:@"请输入行程地点+内容(40字以内)"])
    {
        CZScheduleViewController *schedule = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        
        [schedule.datas addObject:[self getSchedule]];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (CZData *)getSchedule
{
    CZData *data = [CZData data];
    
    data.timeStr = [self getTime];
    
    data.tagStr = [self getTag];
    
    data.contentStr = self.downView.textView.text;
    
    data.dayStr = [self getDay];
    
    data.weekStr = [self getWeek];
    
    data.taglabel = self.upView.themeNameLabel.text;
    
    return data;
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
