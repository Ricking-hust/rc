//
//  RCCommentViewViewController.m
//  rc
//
//  Created by 余笃 on 16/7/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCCommentViewController.h"
#import "Masonry.h"
#import "RCCommentcell.h"
#import "MakeCmtViewController.h"
#import "UINavigationBar+Awesome.h"
#import "RCUtils.h"
//MJReflesh--------------------------------
#import "MJRefresh.h"
#import "RCHomeRefreshHeader.h"

#define COMFONT 14
#define NAMEFONT 9
#define PADDING  10
static const CGFloat userSize = 40;
static const CGFloat praiseSzie = 15;

@interface RCCommentViewController ()

@end

@implementation RCCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
    [self testGet];
    [self initTableView];
    
    self.commetnTableView.mj_header = [RCHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.commetnTableView.mj_footer= [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableView
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    UIView *temp = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:temp];//用于消除导航栏对tableView布局的影响
    self.commetnTableView = [[UITableView alloc]init];
    [self.view addSubview:self.commetnTableView];
    self.commetnTableView.delegate = self;
    self.commetnTableView.dataSource = self;
    [self.commetnTableView registerClass:[RCCommentcell class] forCellReuseIdentifier:kCellIdentifier_CommentCell];
    self.commetnTableView.backgroundColor = [UIColor clearColor];
    self.commetnTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.commetnTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.right.left.bottom.equalTo(self.view);
    }];
}

//设置导航栏
- (void)setNavigation
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    //设置导航标题栏
    UILabel *titleLabel     = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font         = [UIFont systemFontOfSize:18];
    titleLabel.textColor    = themeColor;
    titleLabel.textAlignment= NSTextAlignmentCenter;
    titleLabel.text = @"评论详情";
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    left.tintColor = themeColor;
    [self.navigationItem setLeftBarButtonItem:left];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"添加评论" style:UIBarButtonItemStylePlain target:self action:@selector(turnToCommentPage)];
    right.tintColor = themeColor;
    [self.navigationItem setRightBarButtonItem:right];
    
}

#pragma mark - get date
-(void)testGet{
    NSDictionary *dic1 = @{
                           @"comment_id":@"1",
                           @"usr_id":@"6",
                           @"usr_name":@"逃跑计划",
                           @"usr_pic":@"http://img.myrichang.com/img/src/logo.png",
                           @"father_comment_id":@"0",
                           @"comment_time":@"2015年7月20日 15：32",
                           @"comment_content":@"再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见",
                           @"comment_praise_num":@"7",
                           @"father_comment_usr_id":@"0",
                           @"father_comment_usr_name":@"0",
                           @"father_comment_content":@"0"
                              };
    
    NSDictionary *dic2 = @{
                           @"comment_id":@"2",
                           @"usr_id":@"5",
                           @"usr_name":@"水木年华",
                           @"usr_pic":@"http://img.myrichang.com/upload/14637245657abe0d0a55a8cefc5270d29c90a6157a.png",
                           @"father_comment_id":@"1",
                           @"comment_time":@"2015年7月20日 22：13",
                           @"comment_content":@"启程",
                           @"comment_praise_num":@"89",
                           @"father_comment_usr_id":@"6",
                           @"father_comment_usr_name":@"逃跑计划",
                           @"father_comment_content":@"再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见"
                              };
    
    NSArray *commentAry = [NSArray arrayWithObjects:dic1,dic2, nil];
    
    self.commentList = [[CommentList alloc]initWithArray:commentAry];;
}

-(void)refreshComment{
}

-(void)getMoreComment{
}

#pragma mark - Lazy Load
-(CommentList *)commentList{
    if (!_commentList) {
        _commentList = [[CommentList alloc]init];
    }
    return _commentList;
}

#pragma mark - TableView 数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _commentList.list.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RCCommentcell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CommentCell forIndexPath:indexPath];
    cell.isPreComment = NO;
    cell.commentModel = _commentList.list[indexPath.section];
    [cell layoutSubviews];
    [cell setSubViewValue];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self heightForCellWithIndex:indexPath];;
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 6)];
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];;
    return view;
}

////section底部间距
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 5;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 5)];
//    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];;
//    return view;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)heightForCellWithIndex:(NSIndexPath *)indexPath{
    CGSize maxSize = CGSizeMake(kScreenWidth - PADDING * 5 - userSize - praiseSzie*2, MAXFLOAT);
    CommentModel *model = self.commentList.list[indexPath.section];
    CGSize commentLabSize = [RCUtils sizeWithText:model.comment_content maxSize:maxSize fontSize:COMFONT];
    return (int)commentLabSize.height + 68;
}

#pragma mark - 更新数据
- (void)loadNewData
{
    [self refreshComment];
    [self.commetnTableView.mj_header endRefreshing];
    [self.commetnTableView.mj_footer endRefreshing];
}

-(void)getMoreData{
    [self getMoreComment];
}

- (void)backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)turnToCommentPage{
    MakeCmtViewController *makeCmtViewController = [[MakeCmtViewController alloc]init];
    [self.navigationController pushViewController:makeCmtViewController animated:YES];
}

@end
