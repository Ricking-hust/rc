//
//  RCScheduleViewController.m
//  rc
//
//  Created by AlanZhang on 16/3/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCScheduleViewController.h"
#import "Masonry.h"
#import "PlanModel.h"
#import "RCScheduleView.h"
#import "RCScrollView.h"
#import "RCAddScheduleViewController.h"
#import "LoginViewController.h"
#include <sys/sysctl.h>
@interface RCScheduleViewController ()
@property (nonatomic, strong) RCScheduleView *sc;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) PlanList *planList;
@property (nonatomic, strong) NSMutableArray *planListRanged;
@property (nonatomic, copy) NSURLSessionDataTask *(^getPlanListBlock)();

@end

@implementation RCScheduleViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isLogin = [DataManager manager].user.isLogin;
    if (self.isLogin)
    {
        self.sc.hidden = NO;

        self.getPlanListBlock();
    }else
    {
        [self showLoginOrNotView];
    }
}
- (void)createSC
{
    self.sc = [[RCScheduleView alloc]init];
    [self.view addSubview:self.sc];
    [self.sc mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
    }];
    self.sc.hidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigation];
    [self createSC];
    [self configureBlocks];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getView" object:self.view];

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
    if (self.planListRanged.count != 0)
    {

        self.sc.planListRanged = self.planListRanged;
        self.sc.planList = self.planList;
    }
}
#pragma mark - 添加行程
- (IBAction)addSC:(id)sender
{
    RCAddScheduleViewController *addsc = [[RCAddScheduleViewController alloc]init];
    self.addscDelegate = addsc;
    [self.addscDelegate passPlanListRanged:self.planListRanged];
    [self.addscDelegate passTimeNodeScrollView:self.sc.timeNodeSV];
    [self.navigationController pushViewController:addsc animated:YES];
}

-(void)showLoginOrNotView{
    
    UIAlertController *chooseView = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录，是否登录" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *configureController = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        LoginViewController *loginViewController = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginViewController animated:YES];
    }];
    
    [chooseView addAction:cancelAction];
    [chooseView addAction:configureController];
    
    [self presentViewController:chooseView animated:YES completion:nil];
}

-(NSMutableArray *)planListRanged{
    if (!_planListRanged) {
        _planListRanged = [[NSMutableArray alloc]init];
    }
    return _planListRanged;
}
- (void)setNavigation
{
    NSDate *senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"MM月dd日"];
    
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    self.navigationItem.title = locationString;
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
}
-(void)rangePlanList:(PlanList *)planList{
    if (planList.list.count != 0) {
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
    } else {
        self.planListRanged = nil;
        NSLog(@"Fuck");
    }
    //若使用此方法，需将planListRanged改为copy类型
    //    PlanModel *rPlModel = planList.list[0];
    //    NSString *defaultStr = [rPlModel.planTime substringWithRange:NSMakeRange(5, 5)];
    //    NSMutableArray *templist = [[NSMutableArray alloc]init];
    //    for (PlanModel *planModel in planList.list) {
    //        if ([planModel.planTime substringWithRange:NSMakeRange(5, 5)] == defaultStr) {
    //            [templist addObject:planModel];
    //        }else{
    //            defaultStr = [planModel.planTime substringWithRange:NSMakeRange(5, 5)];
    //            [self.planListRanged addObject:templist];
    //            [templist removeAllObjects];
    //            [templist addObject:planModel];
    //        }
    //    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
