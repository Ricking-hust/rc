//
//  CZTagSelectViewController.m
//  rc
//
//  Created by AlanZhang on 16/1/22.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZTagSelectViewController.h"
#import "Masonry.h"
#import "CZTagCell.h"
#import "CZMyTagCell.h"

@interface CZTagSelectViewController ()

@end

@implementation CZTagSelectViewController

//导航栏左侧取消按钮
- (IBAction)onClickCancel:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
//导航栏右侧确定按钮
- (IBAction)onClickConfirm:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉Cell之间的分割线
    
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left).offset(100);
//        make.top.equalTo(self.view.mas_top).offset(100);
//    }];
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
    
    if (0 == indexPath.section)
    {//我的标签
        CZMyTagCell *cell = [CZMyTagCell initWithTableView:tableView];
        return cell;
    }
    else
    {//点击添加标签
        CZTagCell *cell = [CZTagCell initWithTableView:tableView];
        return cell;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZTagCell *cell = (CZTagCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.rowHeight;
}
//设置section header 高度
 - (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0/2;
}
//设置section header
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 1)];
    view.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255  blue:245.0/255  alpha:1.0];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 40)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor colorWithRed:140.0/255.0 green:140.0/255.0  blue:140.0/255.0  alpha:1.0];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).with.offset(10);
        make.left.equalTo(view.mas_left).with.offset(10);
    }];
    
    if (0 == section)
    {
        label.text = @"我的标签";
    }
    else
    {
        label.text = @"点击添加标签";
    }

    return view;
}

//设置section footer高度
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
//设置section footer
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 1)];
    return view;
}


@end
