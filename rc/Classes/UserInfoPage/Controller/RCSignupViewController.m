//
//  RCSignupViewController.m
//  rc
//
//  Created by AlanZhang on 16/5/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCSignupViewController.h"
#import "UINavigationBar+Awesome.h"
#import "RCHomeRefreshHeader.h"
#import "Masonry.h"
@interface RCSignupViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) ActivityList *acList;
@property (nonatomic, copy) NSURLSessionDataTask *(^getUserActivityBlock)();
@property (nonatomic, strong) UIView  *heartBrokenView;

@end
@implementation RCSignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:[[UIView alloc]initWithFrame:CGRectZero]];//用于消除导航栏对tableView的布局影响
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    ActivityList *temp = [[ActivityList alloc]init];
    temp.list = [[NSArray alloc]init];
    self.acList = temp;
    //[self configureBlocks];
    [self setNavigation];
    //[self startget];
    self.tableView.mj_header = [RCHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}
- (void)setNavigation
{
    self.navigationItem.title = @"我的活动";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
}
#pragma mark - 下拉刷新
- (void)loadNewData
{
    [self.tableView.mj_header endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = @"hello how are you";
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
    
}
#pragma mark - get data
-(void)configureBlocks{
    @weakify(self)
    self.getUserActivityBlock = ^(){
        @strongify(self)
        return [[DataManager manager] getUserActivityWithUserId:[userDefaults objectForKey:@"userId"] opType:@"1" success:^(ActivityList *acList) {
            @strongify(self)
            self.acList = acList;
        } failure:^(NSError *error) {
            NSLog(@"error:%@",error);
        }];
    };
}

-(void)startget{
    if (self.getUserActivityBlock) {
        self.getUserActivityBlock();
    }
}

- (void) setAcList:(ActivityList *)acList{
    _acList = acList;
    if (_acList.list.count != 0)
    {
        self.heartBrokenView.hidden = YES;
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }else
    {
        self.heartBrokenView.hidden = NO;
        self.tableView.hidden = YES;
    }
    
}
//左侧按钮的点击事件
- (void) backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]init];
        [self.view addSubview:_tableView];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(64);
            make.left.equalTo(self.view.mas_left);
            make.width.mas_equalTo(kScreenWidth);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)heartBrokenView
{
    if (!_heartBrokenView)
    {
        _heartBrokenView = [[UIView alloc]init];
        [self.view addSubview:_heartBrokenView];
        
        UIImageView *imgeView = [[UIImageView alloc]init];
        imgeView.image = [UIImage imageNamed:@"heartbrokenIcon"];
        [_heartBrokenView addSubview:imgeView];
        
        [imgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_heartBrokenView.mas_centerX);
            make.top.equalTo(_heartBrokenView.mas_top);
            make.size.mas_equalTo(imgeView.image.size);
        }];
        UILabel *label = [[UILabel alloc]init];
        label.text = @"您还没有报名的活动哟。";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
        [_heartBrokenView addSubview:label];
        CGSize labelSize = [self sizeWithText:label.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:14];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgeView.mas_bottom).offset(10);
            make.centerX.equalTo(imgeView.mas_centerX).offset(10);
            make.width.mas_equalTo(labelSize.width+1);
            make.height.mas_equalTo(labelSize.height+1);
        }];
        [_heartBrokenView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view);
            make.height.mas_equalTo(imgeView.image.size.height+labelSize.height+1+10);
            make.width.mas_equalTo(imgeView.image.size.width>labelSize.width?imgeView.image.size.width:labelSize.width+1);
        }];
        
    }
    return _heartBrokenView;
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
@end
