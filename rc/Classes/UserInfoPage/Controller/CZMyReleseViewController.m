//
//  CZMyReleseViewController.m
//  rc
//
//  Created by AlanZhang on 16/2/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZMyReleseViewController.h"
#import "RCMyActivityCell.h"
#import "Masonry.h"

@interface CZMyReleseViewController()

@property(nonatomic, strong) ActivityList *acList;
@property (nonatomic, copy) NSURLSessionDataTask *(^getUserActivityBlock)();

@end

@implementation CZMyReleseViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureBlocks];
    //设置导航栏
    [self setNavigation];
    [self createButtons];
    [self startget];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
//设置导航栏
- (void)setNavigation
{
    self.navigationItem.title = @"我的发布";
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
}

- (void)backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createButtons
{
    UIColor *selecteColor = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];
    UIColor *nonSelectedColor = [UIColor colorWithRed:38/255.0 green:40.0/255.0 blue:50.0/255.0 alpha:1.0];
    
    self.superOfButtons = [[UIView alloc]init];
    self.superOfButtons.backgroundColor = [UIColor whiteColor];
    
    self.willCheckButton = [[UIButton alloc]init];
    self.willCheckButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.willCheckButton setTitle:@"待审核" forState:UIControlStateNormal];
    [self.willCheckButton setTitleColor:nonSelectedColor forState:UIControlStateNormal];
    [self.willCheckButton setTitleColor:selecteColor forState:UIControlStateSelected];
    self.willCheckButton.selected = YES;
    
    self.checkedButton = [[UIButton alloc]init];
    self.checkedButton.titleLabel.font = self.willCheckButton.titleLabel.font;
    [self.checkedButton setTitle:@"已审核" forState:UIControlStateNormal];
    [self.checkedButton setTitleColor:nonSelectedColor forState:UIControlStateNormal];
    [self.checkedButton setTitleColor:selecteColor forState:UIControlStateSelected];
    
    self.lineDownOfCheckButton = [[UIView alloc]init];
    self.lineDownOfWillCheckButton = [[UIView alloc]init];
    self.lineDownOfWillCheckButton.backgroundColor = selecteColor;
    self.lineDownOfCheckButton.backgroundColor = selecteColor;
    self.lineDownOfCheckButton.hidden = YES;
    
    [self.willCheckButton addTarget:self action:@selector(checkButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.checkedButton addTarget:self action:@selector(checkButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.superOfButtons];
    [self.superOfButtons addSubview:self.checkedButton];
    [self.superOfButtons addSubview:self.willCheckButton];
    [self.superOfButtons addSubview:self.lineDownOfCheckButton];
    [self.superOfButtons addSubview:self.lineDownOfWillCheckButton];
    
    [self.superOfButtons mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).with.offset(64 + 2);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(35);
    }];
    
    CGFloat padding = [[UIScreen mainScreen]bounds].size.width * 0.2;

    CGSize buttonSize = CGSizeMake(45, 30);
    [self.willCheckButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.superOfButtons);
        make.size.mas_equalTo(buttonSize);
        make.left.equalTo(self.superOfButtons.mas_left).with.offset(padding);
    }];
    [self.lineDownOfWillCheckButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.willCheckButton.mas_left);
        make.bottom.equalTo(self.superOfButtons.mas_bottom);
        make.right.equalTo(self.willCheckButton.mas_right);
        make.height.mas_equalTo(2);
    }];
    [self.checkedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.superOfButtons);
        make.size.mas_equalTo(buttonSize);
        make.right.equalTo(self.superOfButtons.mas_right).with.offset(-padding);
    }];
    [self.lineDownOfCheckButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.checkedButton.mas_left);
        make.bottom.equalTo(self.superOfButtons.mas_bottom);
        make.right.equalTo(self.checkedButton.mas_right);
        make.height.mas_equalTo(2);
    }];
    //创建tabelView
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.superOfButtons.mas_bottom);
    }];
}
#pragma mark - 待审核与已审核按钮点击事件
- (void)checkButton:(UIButton *)btn
{
    self.willCheckButton.selected = NO;
    self.checkedButton.selected = NO;

    if ([btn.titleLabel.text isEqualToString:@"待审核"])
    {

        self.lineDownOfWillCheckButton.hidden = NO;
        self.lineDownOfCheckButton.hidden = YES;
    }else
    {
        self.lineDownOfCheckButton.hidden = NO;
        self.lineDownOfWillCheckButton.hidden = YES;
    }
    btn.selected = YES;
    
    //to do here--------------
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.acList.list.count;
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
    
    static NSString *reuseId = @"myActivity";
    RCMyActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell)
    {
        cell = [[RCMyActivityCell alloc]init];
    }
    //对cell赋值
    [self setValueOfCell:cell AtIndexPath:indexPath];
    //对cell布局
    [cell setSubViewConstraint];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 130;
//    CZActivitycell *cell = (CZActivitycell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return cell.cellHeight;
}

//给单元格进行赋值
- (void)setValueOfCell:(RCMyActivityCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    ActivityModel *acmodel = self.acList.list[indexPath.section];
    [cell.acImageView sd_setImageWithURL:[NSURL URLWithString:acmodel.acPoster] placeholderImage:[UIImage imageNamed:@"20160102.png"]];
    cell.acName.text = acmodel.acTitle;
    cell.acTime.text = acmodel.acTime;
    cell.acPlace.text = acmodel.acPlace;
    NSMutableArray *Artags = [[NSMutableArray alloc]init];
    
    for (TagModel *model in acmodel.tagsList.list) {
        [Artags addObject:model.tagName];
    }
    NSString *tags = [Artags componentsJoinedByString:@","];
    cell.acTag.text = tags;
    
}

#pragma mark - get data

-(void)configureBlocks{
    @weakify(self)
    self.getUserActivityBlock = ^(){
        @strongify(self)
        return [[DataManager manager] getUserActivityWithUserId:[userDefaults objectForKey:@"userId"] opType:@"3" success:^(ActivityList *acList) {
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
    
    [self.tableView reloadData];
}
@end
