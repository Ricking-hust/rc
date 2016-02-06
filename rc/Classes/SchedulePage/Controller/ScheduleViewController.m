//
//  ScheduleViewController.m
//  日常
//
//  Created by AlanZhang on 15/12/22.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import "ScheduleViewController.h"
#import "Masonry.h"
#import "CZTimeCourseCell.h"
#import "CZData.h"
#import "CZScheduleInfoViewController.h"

@interface ScheduleViewController ()<UITableViewDelegate, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *moreImg;

@property (nonatomic, strong) CZData *data;
@property (weak, nonatomic) IBOutlet UIView *testView;


@end

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    [self.moreImg setImage:[UIImage imageNamed:@"more"]];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    UIImage *image = [UIImage imageNamed:@"bg_background2"];
    self.testView.layer.contents = (id) image.CGImage;    // 如果需要背景透明加上下面这句
    self.testView.layer.backgroundColor = [UIColor clearColor].CGColor;
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
