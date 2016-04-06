//
//  CZMyActivityViewContoller.m
//  rc
//
//  Created by AlanZhang on 16/2/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZMyActivityViewContoller.h"
#import "RCMyActivityCell.h"
#import "CZActivityInfoViewController.h"
#import "Masonry.h"
#import "UINavigationBar+Awesome.h"
@interface CZMyActivityViewContoller()

@property (nonatomic, strong) ActivityList *acList;
@property (nonatomic, strong) UIImageView *imgBackground;
@property (nonatomic, strong) NSMutableDictionary *acCount;
@property (nonatomic, copy) NSURLSessionDataTask *(^getUserActivityBlock)();

@end

@implementation CZMyActivityViewContoller
- (UIImageView *)imgBackground
{
    if (!_imgBackground)
    {
        _imgBackground = [[UIImageView alloc]init];
        _imgBackground.image = [UIImage imageNamed:@"heart_broken_icon"];
        [self.view addSubview:_imgBackground];
        [_imgBackground mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(_imgBackground.image.size);
            make.center.equalTo(self.view);
        }];

    }
    return _imgBackground;
}
- (NSMutableDictionary *)acCount
{
    if (!_acCount)
    {
        _acCount = [[NSMutableDictionary alloc]init];
        [_acCount setObject:@"NO" forKey:@"count"];
    }
    return _acCount;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [self.acCount addObserver:self forKeyPath:@"count" options:NSKeyValueObservingOptionNew context:nil];
    [self configureBlocks];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setNavigation];
    [self startget];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    
}
- (void)dealloc
{
    [self.acCount removeObserver:self forKeyPath:@"count"];
}
- (void)setNavigation
{
    self.navigationItem.title = @"我的活动";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
}
- (void)backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.acList.list.count;
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
    
}
#pragma mark - cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZActivityInfoViewController *ac = [[CZActivityInfoViewController alloc]init];
    
    ac.activityModelPre = self.acList.list[indexPath.row];
    [self.navigationController pushViewController:ac animated:YES];
}
- (void)setValueOfCell:(RCMyActivityCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    ActivityModel *acmodel = self.acList.list[indexPath.row];
    [cell.acImageView sd_setImageWithURL:[NSURL URLWithString:acmodel.acPoster] placeholderImage:[UIImage imageNamed:@"20160102.png"]];
    cell.acName.text = acmodel.acTitle;
    cell.acTime.text = acmodel.acTime;
    cell.acPlace.text = acmodel.acPlace;
    cell.acTag.text = acmodel.userInfo.userName;
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
        self.tableView.hidden = NO;
        self.imgBackground.hidden = YES;
        [self.tableView reloadData];
    }else
    {
//        self.imgBackground.hidden = NO;
//        self.tableView.hidden = YES;
    }

}

@end
