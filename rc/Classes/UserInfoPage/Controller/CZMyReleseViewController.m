//
//  CZMyReleseViewController.m
//  rc
//
//  Created by AlanZhang on 16/2/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZMyReleseViewController.h"
#import "RCMyActivityCell.h"
#import "CZActivityInfoViewController.h"
#import "Masonry.h"

@interface CZMyReleseViewController()

@property(nonatomic, strong) ActivityList *acList;
@property (nonatomic,strong) NSMutableArray *waitReviewAc;
@property (nonatomic,strong) NSMutableArray *didReviewAc;
@property (nonatomic,strong) NSMutableArray *reviewAc;
@property (nonatomic, copy) NSURLSessionDataTask *(^getUserActivityBlock)();
@property (nonatomic, strong) UIView  *heartBrokenView;
@end

@implementation CZMyReleseViewController
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
            make.left.equalTo(_heartBrokenView.mas_left);
            make.top.equalTo(_heartBrokenView.mas_top);
            make.size.mas_equalTo(imgeView.image.size);
        }];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"您还没有发布活动哟。";
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
            make.centerX.equalTo(self.view).offset(10);
            make.centerY.equalTo(self.view);
            make.height.mas_equalTo(imgeView.image.size.height+labelSize.height+1+10);
            make.width.mas_equalTo(imgeView.image.size.width>labelSize.width?imgeView.image.size.width:labelSize.width+1);
        }];
        
    }
    return _heartBrokenView;
}
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
    self.reviewAc = self.waitReviewAc;
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
        self.reviewAc = self.waitReviewAc;
        self.lineDownOfWillCheckButton.hidden = NO;
        self.lineDownOfCheckButton.hidden = YES;
        [self.tableView reloadData];

    }else
    {
        self.reviewAc = self.didReviewAc;
        self.lineDownOfCheckButton.hidden = NO;
        self.lineDownOfWillCheckButton.hidden = YES;
        [self.tableView reloadData];
    }
    btn.selected = YES;
    //to do here--------------
    if (self.reviewAc.count == 0)
    {
        self.heartBrokenView.hidden = NO;
    }else
    {
        self.heartBrokenView.hidden = YES;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.reviewAc.count;;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
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
    ActivityModel *acmodel = self.reviewAc[indexPath.row];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CZActivityInfoViewController *ac = [[CZActivityInfoViewController alloc]init];
    
    ac.activityModelPre = self.reviewAc[indexPath.row];
    [self.navigationController pushViewController:ac animated:YES];
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

-(NSMutableArray *)waitReviewAc{
    if (!_waitReviewAc) {
        _waitReviewAc = [[NSMutableArray alloc]init];
    }
    return _waitReviewAc;
}

-(NSMutableArray *)didReviewAc{
    if (!_didReviewAc) {
        _didReviewAc = [[NSMutableArray alloc]init];
    }
    return _didReviewAc;
}

-(NSMutableArray *)reviewAc{
    if (!_reviewAc) {
        _reviewAc = [[NSMutableArray alloc]init];
    }
    return _reviewAc;
}

- (void) setAcList:(ActivityList *)acList{
    _acList = acList;
    if (_acList.list.count != 0)
    {
        self.heartBrokenView.hidden = YES;
    }else
    {
        self.heartBrokenView.hidden = NO;
    }
    for (ActivityModel *model in acList.list) {
        if ([model.acReview isEqualToString:@"0"]) {
            [self.waitReviewAc addObject:model];
            
        } else {
            [self.didReviewAc addObject:model];
        }
    }
    [self.tableView reloadData];
}
/**
 *  计算文本的大小
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
