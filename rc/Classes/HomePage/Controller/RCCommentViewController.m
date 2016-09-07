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

@property (nonatomic, copy) NSURLSessionDataTask* (^getCommentBlock)();

@end

@implementation RCCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigation];
    [self configureBlocks];
    self.getCommentBlock();
    [self initTableView];
    
    self.commentTableView.mj_header = [RCHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.commentTableView.mj_footer= [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
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
    self.commentTableView = [[UITableView alloc]init];
    [self.view addSubview:self.commentTableView];
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    [self.commentTableView registerClass:[RCCommentcell class] forCellReuseIdentifier:kCellIdentifier_CommentCell];
    self.commentTableView.backgroundColor = [UIColor clearColor];
    self.commentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.commentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
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

#pragma mark - Data
- (void)configureBlocks{
    @weakify(self);
    self.getCommentBlock = ^(){
        @strongify(self);
        NSString *userId = [[NSString alloc]init];
        if ([userDefaults objectForKey:@"userId"]) {
            userId = [userDefaults objectForKey:@"userId"];
        } else {
            userId = @"-1";
        }
        return [[DataManager manager] getAllCommentsWithacID:self.acModel.acID userId:[userDefaults objectForKey:@"userId"] startID:@"0" success:^(CommentList *comList) {
            self.commentList = comList;
        } failure:^(NSError *error) {
            NSLog(@"Error:%@",error);
        }];
    };
}

-(void)setCommentList:(CommentList *)commentList{
    _commentList = commentList;
    [self.commentTableView reloadData];
}

-(void)refreshComment{
    self.getCommentBlock();
}

-(void)getMoreComment{
    self.getCommentBlock();
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
    MakeCmtViewController *makeCmtViewController = [[MakeCmtViewController alloc]init];
    makeCmtViewController.acModel = self.acModel;
    [self.navigationController pushViewController:makeCmtViewController animated:YES];
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
    [self.commentTableView.mj_header endRefreshing];
}

-(void)getMoreData{
    [self getMoreComment];
    [self.commentTableView.mj_footer endRefreshing];
}

- (void)backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)turnToCommentPage{
    MakeCmtViewController *makeCmtViewController = [[MakeCmtViewController alloc]init];
    makeCmtViewController.acModel = self.acModel;
    [self.navigationController pushViewController:makeCmtViewController animated:YES];
}

@end
