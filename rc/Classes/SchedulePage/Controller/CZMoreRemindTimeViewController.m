//
//  CZMoreRemindTimeViewController.m
//  rc
//
//  Created by AlanZhang on 16/2/13.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZMoreRemindTimeViewController.h"
#import "CZRemindTimeCell.h"
#import "CZMoreTimeCell.h"
#import "Masonry.h"
#import "CZUpdateScheduleViewController.h"
#import "CZMoreTimeCell.h"
#import "CZRemindTimeCell.h"
#import "CZDownView.h"
#define FONTSIZE    14

@interface CZMoreRemindTimeViewController ()
@property (strong, nonatomic) NSArray *times;
@property (strong, nonatomic) NSArray *cells;

@end

@implementation CZMoreRemindTimeViewController

#pragma mark - 懒加载
- (NSArray *)times
{
    if (!_times)
    {
        _times = [[NSArray alloc]initWithObjects:@"不提醒", @"前一天", @"前三天",@"前五天",@"前七天", nil];
    }
    return _times;
}
- (NSArray *)cells
{
    if (!_cells)
    {
        NSArray *cells = self.tableView.visibleCells;
        _cells = [[NSArray alloc]initWithArray:cells];
    }
    return  _cells;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    self.tableView.tableHeaderView = [self setTableViewHeaderView];
    self.tableView.scrollEnabled = NO;
    
    [self setNavigationItem];
}
- (void)setNavigationItem
{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backForwardController)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
}
- (void)backForwardController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIView *)setTableViewHeaderView
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, 5)];
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];

    return view;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0)
    {
        return self.times.count;
    }else
    {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        CZMoreTimeCell *cell = [CZMoreTimeCell moreTimeCell];
        cell.timeLable.text = self.times[indexPath.row];
        cell.imgView.image = [UIImage imageNamed:@"selectedIcon"];
        [self addCellConstraints:cell WithIndexPath:indexPath];
        return cell;
    }else
    {
        CZRemindTimeCell *cell = [CZRemindTimeCell remindTimeCell];
        [self addCellConstraints:cell WithIndexPath:indexPath];
        return cell;
    }
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 1)];
    view.backgroundColor = self.view.backgroundColor;
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 5)];
    view.backgroundColor = self.view.backgroundColor;
    
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self isSelectedCell:indexPath];
    //to do here ----------------------
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CZUpdateScheduleViewController *updateViewController = self.navigationController.viewControllers[2];
    if ([cell isKindOfClass:[CZMoreTimeCell class]])
    {
        
        updateViewController.downView.timeInfoLabel.text = ((CZMoreTimeCell *)cell).timeLable.text;
    }else
    {
        updateViewController.downView.remindTimeLabel.text = ((CZRemindTimeCell *)cell).time.text;
    }
    
}
- (void)isSelectedCell:(NSIndexPath *)indexPath
{
    CZMoreTimeCell *cell = self.cells[indexPath.row];
    cell.imgView.hidden = NO;
    for (int i = 0; i <5; ++i)
    {
        if (i != indexPath.row)
        {
            CZMoreTimeCell *cell = self.cells[i];
            cell.imgView.hidden = YES;
        }
    }
    CZRemindTimeCell *remindCell = self.cells[5];
    [self setRemindTime:remindCell];
}
- (void)setRemindTime:(CZRemindTimeCell *)cell
{
    cell.label.alpha = 1.0;
    cell.time.alpha = cell.label.alpha;
    cell.timeButton.enabled = YES;
}
- (void)addCellConstraints:(UITableViewCell *)cell WithIndexPath:(NSIndexPath *)indexPath
{
    CGFloat padding = 10;
    if ([cell isKindOfClass:[CZMoreTimeCell class]])
    {
        CZMoreTimeCell *moreTimeCell = (CZMoreTimeCell *)cell;
        CGSize timeLabelSize = [self setLabelStyle:moreTimeCell.timeLable WithContent:self.times[indexPath.row]];
        [moreTimeCell.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(moreTimeCell.contentView);
            make.left.equalTo(moreTimeCell.mas_left).with.offset(padding);
            make.size.mas_equalTo(CGSizeMake(timeLabelSize.width +1, timeLabelSize.height+1));
            
        }];
        [moreTimeCell.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(moreTimeCell.contentView);
            make.right.equalTo(moreTimeCell.contentView.mas_right).offset(-padding);
            make.size.mas_equalTo(moreTimeCell.imgView.image.size);
        }];
    }else
    {
        CZRemindTimeCell *remindTimeCell = (CZRemindTimeCell *)cell;
        CGSize labelSize = [self setLabelStyle:remindTimeCell.label WithContent:remindTimeCell.label.text];
        [remindTimeCell.label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(remindTimeCell.contentView);
            make.left.equalTo(remindTimeCell.contentView.mas_left).with.offset(padding);
            make.size.mas_equalTo(CGSizeMake(labelSize.width+1, labelSize.height+1));
        }];
        CGSize timeButtonSize = remindTimeCell.timeButton.imageView.image.size;
        [remindTimeCell.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(remindTimeCell.contentView);
            make.right.equalTo(remindTimeCell.contentView.mas_right).with.offset(-padding);
            make.size.mas_equalTo(CGSizeMake(timeButtonSize.width+5, timeButtonSize.height));
        }];
        CGSize timeSize = [self setLabelStyle:remindTimeCell.time WithContent:remindTimeCell.time.text];
        [remindTimeCell.time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(remindTimeCell.contentView);
            make.right.equalTo(remindTimeCell.timeButton.mas_left).with.offset(-5);
            make.size.mas_equalTo(CGSizeMake(timeSize.width+1, timeSize.height+1));
        }];
        remindTimeCell.label.alpha = 0.7;
        remindTimeCell.time.alpha = remindTimeCell.label.alpha;
    }
}
//设置标签的样式
- (CGSize)setLabelStyle:(UILabel *)label WithContent:(NSString *)content
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    label.font = [UIFont systemFontOfSize:FONTSIZE];
    label.numberOfLines = 0;
    label.text = content;
    label.alpha = 1.0;
    CGSize size = [self sizeWithText:content maxSize:CGSizeMake(rect.size.width * 0.55, MAXFLOAT) fontSize:FONTSIZE];
    
    return size;
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
