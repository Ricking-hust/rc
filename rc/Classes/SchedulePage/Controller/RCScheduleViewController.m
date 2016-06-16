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
@property (nonatomic, strong) NSString  *updateState;//行程更新的状态,null未更新，update已更新须请求后台,默认update
@property (nonatomic, strong) UIView  *timeLine;
@property (nonatomic, strong) UIView  *heartBrokenView;
@property (nonatomic, strong) UIView  *notLoginView;
@end

@implementation RCScheduleViewController
- (UIView *)notLoginView
{
    if (!_notLoginView)
    {
        _notLoginView = [[UIView alloc]init];
        [self.view addSubview:_notLoginView];
        
        UIImageView *imgeView = [[UIImageView alloc]init];
        imgeView.image = [UIImage imageNamed:@"heartbrokenIcon"];
        [_notLoginView addSubview:imgeView];
        
        [imgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_notLoginView.mas_left);
            make.top.equalTo(_notLoginView.mas_top);
            make.size.mas_equalTo(imgeView.image.size);
        }];
        UILabel *label = [[UILabel alloc]init];
        label.text = @"您还没有登录哟。";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
        [_notLoginView addSubview:label];
        CGSize labelSize = [self sizeWithText:label.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:14];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgeView.mas_bottom).offset(10);
            make.centerX.equalTo(imgeView.mas_centerX).offset(10);
            make.width.mas_equalTo(labelSize.width+1);
            make.height.mas_equalTo(labelSize.height+1);
        }];
        [_notLoginView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view).offset(10);
            make.centerY.equalTo(self.view);
            make.height.mas_equalTo(imgeView.image.size.height+labelSize.height+1+10);
            make.width.mas_equalTo(imgeView.image.size.width>labelSize.width?imgeView.image.size.width:labelSize.width+1);
        }];
        
    }
    return _notLoginView;
}

- (UIView *)timeLine
{
    if (!_timeLine)
    {
        _timeLine = [[UIView alloc]initWithFrame:CGRectMake(67, 64+35, 2, kScreenHeight - 64-25-49)];
        [self.view addSubview:_timeLine];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = _timeLine.bounds;
        [_timeLine.layer addSublayer:gradientLayer];
        
        //set gradient colors
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:226.0/255.0 green:226.0/255.0 blue:224.0/255.0 alpha:1.0].CGColor];
        
        //set gradient start and end points
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 1);
        
    }
    return _timeLine;
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
            make.left.equalTo(_heartBrokenView.mas_left);
            make.top.equalTo(_heartBrokenView.mas_top);
            make.size.mas_equalTo(imgeView.image.size);
        }];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"您还没有添加行程哟。";
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
            make.centerX.equalTo(self.view).offset(20);
            make.centerY.equalTo(self.view).offset(-20);
            make.height.mas_equalTo(imgeView.image.size.height+labelSize.height+1+10);
            make.width.mas_equalTo(imgeView.image.size.width>labelSize.width?imgeView.image.size.width:labelSize.width+1);
        }];

    }
    return _heartBrokenView;
}
#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.isLogin = [DataManager manager].user.isLogin;
    if (self.isLogin)
    {
#pragma mark - 不注释行程的点击事件有时会失效
//        for (UIView *view in self.view.subviews)
//        {
//            view.hidden = NO;
//        }
        self.notLoginView.hidden = YES;
        
        if ([self.updateState isEqualToString:@"update"])
        {
            self.getPlanListBlock();
            self.sc.hidden = NO;
            if (self.planListRanged.count == 0) {
                self.sc.currentPoint.hidden  = YES;
            }else{
                self.sc.currentPoint.hidden = NO;
            }
            self.updateState = @"null";//重置更新状态
        }else
        {//行程信息未更新，不用再次请求网络
            if (self.planListRanged.count != 0)
            {
                self.timeLine.hidden = YES;
            }else
            {
                self.timeLine.hidden = NO;
            }
        }

    }else
    {
        for (UIView *view in self.view.subviews)
        {
            view.hidden = YES;
        }
        self.notLoginView.hidden = NO;
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
    self.sc.timeNodeSV.decelerationRate = 0.6;//此属性用于修改scrollView滑动的速率
    self.sc.hidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigation];
    [self createSC];
    [self configureBlocks];
    self.updateState = @"update";
    [[NSNotificationCenter defaultCenter]postNotificationName:@"getView" object:self.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getScheduleState:) name:@"scState" object:nil];

}
- (void)getScheduleState:(NSNotification *)notification
{
    self.updateState = notification.object;
}
-(void)configureBlocks{
    @weakify(self);
    self.getPlanListBlock = ^(){
        @strongify(self);
        return [[DataManager manager] getPlanWithUserId:[userDefaults objectForKey:@"userId"] beginDate:@"2000-01-01" endDate:@"2100-01-01" success:^(PlanList *plList) {
            @strongify(self);
            self.planList = plList;
        } failure:^(NSError *error) {
            NSLog(@"Error:%@",error);
        }];
    };
}
-(void)setPlanList:(PlanList *)planList{
    _planList = planList;
    if (_planList.list.count !=0)
    {
        [self rangePlanList:self.planList];
        if (self.planListRanged.count != 0)
        {
#pragma mark - 修改数组倒序
            //将数组倒序
            NSMutableArray *arr  = self.planListRanged;
            NSEnumerator *enumer = [arr reverseObjectEnumerator];
            self.planListRanged = [[NSMutableArray alloc]initWithArray:[enumer allObjects]];
            self.sc.planListRanged = self.planListRanged;
            self.sc.currentPoint.hidden = NO;
        }
        self.timeLine.hidden = YES;
        for (UIView *view in self.heartBrokenView.subviews)
        {
            view.hidden = YES;
        }
        self.heartBrokenView.hidden = YES;
    }else
    {
        self.timeLine.hidden = NO;
        self.heartBrokenView.hidden = NO;
        for (UIView *view in self.heartBrokenView.subviews)
        {
            view.hidden = NO;
        }

    }

}
#pragma mark - 添加行程
- (IBAction)addSC:(id)sender
{
    if (self.isLogin)
    {
        RCAddScheduleViewController *addsc = [[RCAddScheduleViewController alloc]init];
        self.addscDelegate = addsc;
        [self.addscDelegate passPlanListRanged:self.planListRanged];
        [self.addscDelegate passTimeNodeScrollView:self.sc.timeNodeSV];
        [self.navigationController pushViewController:addsc animated:YES];
    }else
    {
        [self showLoginOrNotView];
    }

}

-(void)showLoginOrNotView{
    
    UIAlertController *chooseView = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未登录，是否登录？" preferredStyle:UIAlertControllerStyleAlert];
    
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
        self.sc.hidden = NO;
        PlanModel *rPlModel = planList.list[0];
        NSString *defaultStr = [rPlModel.planTime substringWithRange:NSMakeRange(5, 5)];
        int i = 0;
        self.planListRanged[0] = [[NSMutableArray alloc]init];
        for (PlanModel *planModel in planList.list) {
            if ([[planModel.planTime substringWithRange:NSMakeRange(5, 5)] isEqualToString:defaultStr]) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
