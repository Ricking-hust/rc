//
//  CZScheduleViewController.m
//  日常
//
//  Created by AlanZhang on 15/12/22.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import "CZScheduleViewController.h"
#import "Masonry.h"
#import "CZTimeCourseCell.h"
#import "CZData.h"
#import "CZScheduleInfoViewController.h"
#import "CZAddScheduleViewController.h"

@interface CZScheduleViewController ()<UITableViewDelegate, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *moreImg;

@property (nonatomic, strong) CZData *data;

@end


@implementation CZScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    [self.moreImg setImage:[UIImage imageNamed:@"more"]];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"MM月dd日"];
    
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    
    self.title = locationString;
}
//添加行程
- (IBAction)addSchedule:(id)sender {
    
    CZAddScheduleViewController *addScheduleViewController = [[CZAddScheduleViewController alloc]init];
    
    addScheduleViewController.title = @"添加行程";
    
    [self.navigationController pushViewController:addScheduleViewController animated:YES];
    
}

#pragma mark - 懒加载创建tableView, moreImg
- (CZData *)data
{
    if (!_data) {
        _data = [CZData data];
    }
    return _data;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = [UIColor clearColor];
        CGRect rect = [[UIScreen mainScreen]bounds];
        [self.view addSubview:_tableView];
        CGSize size = CGSizeMake(rect.size.width, rect.size.height - 64 - self.moreImg.image.size.height);
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.top.equalTo(self.moreImg.mas_bottom);
            make.size.mas_equalTo(size);
        }];
        
    }
    return _tableView;
}
- (UIImageView *)moreImg
{
    if (!_moreImg) {
        _moreImg = [[UIImageView alloc]init];
        _moreImg.image = [UIImage imageNamed:@"more"];
        [self.view addSubview:_moreImg];
        CGRect rect = [[UIScreen mainScreen]bounds];
        CGFloat leftPadding = rect.size.width * 0.21 - _moreImg.image.size.width / 2;
        [_moreImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(leftPadding);
            make.top.equalTo(self.view.mas_top).with.offset(64);
            make.size.mas_equalTo(_moreImg.image.size);
        }];
    }
    return _moreImg;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {//当日的cell
        CZTimeCourseCell *cell = [CZTimeCourseCell cellWithTableView:tableView];
        cell.isLastCell = YES;
        cell.data = self.data;

        return cell;
    }else
    {
        CZTimeCourseCell *cell = [CZTimeCourseCell cellWithTableView:tableView];
        cell.data = self.data;
        return cell;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZTimeCourseCell *cell = (CZTimeCourseCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellSize.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZScheduleInfoViewController *scheduleInfoViewController = [[CZScheduleInfoViewController alloc]init];
    [self.navigationController pushViewController:scheduleInfoViewController animated:YES];
}

@end
