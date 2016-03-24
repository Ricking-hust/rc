//
//  RCNewsNoteViewController.m
//  rc
//
//  Created by AlanZhang on 16/3/24.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCNewsNoteViewController.h"
#import "Masonry.h"
@interface RCNewsNoteViewController()
@property (nonatomic, strong) PlanList *planList;
@property (nonatomic, strong) NSMutableArray *planListRanged;
@property (nonatomic, copy) NSURLSessionDataTask *(^getPlanListBlock)();
@end
@implementation RCNewsNoteViewController
-(NSMutableArray *)planListRanged{
    if (!_planListRanged) {
        _planListRanged = [[NSMutableArray alloc]init];
    }
    return _planListRanged;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [self setNavigation];
    [self configureBlocks];
}
-(void)configureBlocks{
    @weakify(self);
    self.getPlanListBlock = ^(){
        @strongify(self);
        return [[DataManager manager] getPlanWithUserId:[userDefaults objectForKey:@"userId"] beginDate:@"2016-01-01" endDate:@"2016-12-31" success:^(PlanList *plList) {
            @strongify(self);
            self.planList = plList;
        } failure:^(NSError *error) {
            NSLog(@"Error:%@",error);
        }];
    };
}
-(void)setPlanList:(PlanList *)planList{
    _planList = planList;
    
    [self rangePlanList:self.planList];
}
-(void)rangePlanList:(PlanList *)planList{
    PlanModel *rPlModel = planList.list[0];
    NSString *defaultStr = [rPlModel.planTime substringWithRange:NSMakeRange(5, 5)];
    int i = 0;
    self.planListRanged[0] = [[NSMutableArray alloc]init];
    for (PlanModel *planModel in planList.list) {
        if ([planModel.planTime substringWithRange:NSMakeRange(5, 5)] == defaultStr) {
            [self.planListRanged[i] addObject:planModel];
        }else{
            i = i+1;
            self.planListRanged[i] = [[NSMutableArray alloc]init];
            defaultStr = [planModel.planTime substringWithRange:NSMakeRange(5, 5)];
            [self.planListRanged[i] addObject:planModel];
        }
    }
}

- (void)setNavigation
{
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
}
- (void)backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    UILabel *label = [[UILabel alloc]init];
    label.alpha = 0.8;
    label.text = @"消息通知";
    label.font = [UIFont systemFontOfSize:14];
    [cell addSubview:label];
    [label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell);
        make.left.equalTo(cell.mas_left).offset(10);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    UISwitch *s = [[UISwitch alloc]init];
    [s addTarget:self action:@selector(onSwitchValueChanged:) forControlEvents:UIControlEventValueChanged]; // 添加事件监听器的方法
    [cell addSubview:s];
    [s mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.mas_centerY);
        make.right.equalTo(cell.mas_right).offset(-10);
        make.width.mas_equalTo(51);
        make.height.mas_equalTo(31);
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (void)onSwitchValueChanged:(UISwitch *)s
{
    if (s.on)
    {
        NSLog(@"on");
    }else
    {
        NSLog(@"off");
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
