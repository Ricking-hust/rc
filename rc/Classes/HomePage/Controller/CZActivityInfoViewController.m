//
//  CZActivityInfoViewController.m
//  rc
//
//  Created by AlanZhang on 16/1/15.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZActivityInfoViewController.h"
#import "ActivityInfoHeaderView.h"
#import "Activity.h"
#import "Masonry.h"

@interface CZActivityInfoViewController ()

@property(nonatomic, strong) UIView *bottomView;

@property(nonatomic,strong) UIButton *collectionBtn;
@property(nonatomic,strong) UIButton *addToSchedule;

@property (nonatomic, strong)Activity* activity;
@end

@implementation CZActivityInfoViewController

//创建子控件
- (void)createSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.collectionBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    self.addToSchedule = [UIButton buttonWithType:UIButtonTypeCustom];
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tableView];
    [self.bottomView addSubview:self.collectionBtn];
    [self.bottomView addSubview:self.addToSchedule];
    
    [self.collectionBtn addTarget:self action:@selector(onClickCollection) forControlEvents:UIControlEventTouchUpInside];
    [self.addToSchedule addTarget:self action:@selector(onClickAdd) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.addToSchedule setTitle:@"加入日程" forState:UIControlStateNormal];
    [self.addToSchedule setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:130.0/255.0  blue:5.0/255.0  alpha:1.0]];
    
    [self.collectionBtn setImage:[UIImage imageNamed:@"shopping"] forState:UIControlStateNormal];
    [self.collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    CGSize size = [[UIScreen mainScreen]bounds].size;
    //add tableView constraints
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(@64);
        make.size.mas_equalTo(CGSizeMake(size.width, size.height - 114));
    }];

    //add bottomView constraints
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.tableView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(size.width, 50));
    }];
    
    //add collectionBtn constraints
    [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left);
        make.top.equalTo(self.bottomView.mas_top);
        make.size.mas_equalTo(CGSizeMake(size.width * 0.33, 50));
    }];
    
    //add addToSchedule constriants
    [self.addToSchedule mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.collectionBtn.mas_right);
        make.top.equalTo(self.bottomView.mas_top);
        make.size.mas_equalTo(CGSizeMake(size.width * 0.69, 50));
    }];
    
}

- (void)onClickCollection
{
//    NSLog(@"collection");
}

- (void)onClickAdd
{
//     NSLog(@"addToSchedule");
}

//界面加载完毕
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createSubViews];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
#pragma mark -  测试数据

    Activity *activity = [[Activity alloc]init];
    [activity setSubViewsContent];
    
    //设置tableVie头
    ActivityInfoHeaderView *header = [ActivityInfoHeaderView headerView];
    [header setView:activity];
    self.tableView.tableHeaderView = header;

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
