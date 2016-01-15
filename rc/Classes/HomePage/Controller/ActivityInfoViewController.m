//
//  ActivityInfoViewController.m
//  日常
//
//  Created by AlanZhang on 16/1/12.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "ActivityInfoViewController.h"
#import "ActivityInfoHeaderView.h"
#import "Activity.h"

@interface ActivityInfoViewController ()
@property (nonatomic, strong)Activity* activity;
@end

@implementation ActivityInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景色
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    
    //测试数据
    self.activity = [[Activity alloc]init];
    [self.activity setSubViewsContent];
    
    //设置tableHeaderView
    ActivityInfoHeaderView *headerView = [ActivityInfoHeaderView headerView];
    [headerView setView:self.activity];
    self.tableView.tableHeaderView = headerView;
    
    //设置活动详情的标题
    self.navigationItem.title = @"活动详情";
    //设置活动详情的左侧按钮
    UIButton *btn = [[UIButton alloc] init];
    btn.bounds = CGRectMake(0, 0, 20, 20);
    [btn setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:0 green:110.0/255 blue:253.0/255 alpha:1.0];
    
}

//左侧按钮的点击事件
- (void) back
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"activity"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"activity"];
    }
    
    cell.textLabel.text = @"哈哈";
    
    return cell;
}

@end
