//
//  CZTagViewController.m
//  rc
//
//  Created by AlanZhang on 16/1/27.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZTagViewController.h"
#import "CZTagCell.h"
#import "CZMyTagCell.h"

@interface CZTagViewController ()

@end

@implementation CZTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        CZMyTagCell *cell = [CZMyTagCell initWithTableView:tableView];
        return cell;
    }else
    {
        CZTagCell *cell = [CZTagCell initWithTableView:tableView];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZTagCell *cell = (CZTagCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    //return cell.rowHeight;
    return 100;
}
//设置节头
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70/2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 10)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 15)];
        label.textColor = [UIColor colorWithRed:38/255 green:40/255 blue:50/255 alpha:0.4];
        label.text = @"我的标签";
        label.font = [UIFont systemFontOfSize:14];
        [view addSubview:label];
        //UIButton *edit = [UI];
        //添加四个边阴影
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){200/255 ,199/255,204/255,0.8});
        view.layer.shadowColor = color;//阴影颜色
        view.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
        view.layer.shadowOpacity = 0.5;//不透明度
        view.layer.shadowRadius = 1.0;//半径
        return view;
        
    }else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 10)];
        view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 15)];
        label.textColor = [UIColor colorWithRed:38/255 green:40/255 blue:50/255 alpha:0.4];
        label.text = @"点击添加标签";
        label.font = [UIFont systemFontOfSize:14];
        [view addSubview:label];

        return view;
    }
}
//设置节尾
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 1)];
    return view;
}

@end
