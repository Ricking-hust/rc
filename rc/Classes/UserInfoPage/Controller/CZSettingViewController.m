//
//  CZSettingViewController.m
//  rc
//
//  Created by AlanZhang on 16/2/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZSettingViewController.h"
#import "Masonry.h"

@implementation CZSettingViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    self.tableView.scrollEnabled = NO;
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
    self.tableView.separatorInset = UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }else
    {
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"新消息通知";
        }else
        {
            cell.textLabel.text = @"清除缓存";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else
    {
        cell.textLabel.text = @"退出登陆";
        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell);
        }];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.alpha = 0.8;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [[DataManager manager] UserLogout];
    }
    NSLog(@"你点击了第 %ld Cell", indexPath.row);
}
@end
