//
//  CZScheduleViewController.m
//  rc
//
//  Created by AlanZhang on 16/3/6.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//
#import "CZScheduleViewController.h"
#import "Masonry.h"
#import "CZTimeTableViewDelegate.h"
#import "CZScheduleTableViewDelegate.h"
#import "CZUpdateScheduleViewController.h"
#import "CZTestData.h"
#import "PlanModel.h"
#include <sys/sysctl.h>

@interface CZScheduleViewController ()

@property (nonatomic, assign) CurrentDevice device;
@property (nonatomic,strong) PlanList *planList;
@property (nonatomic, copy) NSMutableArray *planListRanged;
@property (nonatomic,copy) NSURLSessionDataTask *(^getPlanListBlock)();

@end

@implementation CZScheduleViewController

#pragma mark - data

-(void)configureBlocks{
    @weakify(self);
    self.getPlanListBlock = ^(){
        @strongify(self);
        return [[DataManager manager] getPlanWithUserId:@"1" beginDate:@"2016-01-01" endDate:@"2016-12-31" success:^(PlanList *plList) {
            @strongify(self);
            self.planList = plList;
        } failure:^(NSError *error) {
            NSLog(@"Error:%@",error);
        }];
    };
}

-(void)setPlanList:(PlanList *)planList{
    _planList = planList;
    
    [self displayTimeNode];
}

-(NSMutableArray *)planListRanged{
    if (!_planListRanged) {
        _planListRanged = [[NSMutableArray alloc]init];
    }
    return _planListRanged;
}

- (CurrentDevice)device
{
    if (!_device)
    {
        _device = [self currentDeviceSize];
    }
    return _device;
}

#pragma mark - View

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNavigation];
    [self addSubViews];
    [self configureBlocks];
    self.getPlanListBlock();
    
}
- (void)setNavigation
{
    NSDate *senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"MM月dd日"];
    
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    self.navigationItem.title = locationString;
}
- (void)displayTimeNode
{
    [self rangePlanList:self.planList];
    self.timeDelegate.array = self.planListRanged;
    self.timeDelegate.device = self.device;
    self.timeDelegate.indexAtCell = 0;
    self.scDelegate.array = self.planListRanged[0];
    self.scDelegate.device = self.device;
    self.timeDelegate.timeNodeTableView = self.timeNodeTableView;
    
    [self.timeNodeTableView reloadData];
    [self.scTableView reloadData];
}
- (void)addSubViews
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    self.timeNodeTableView.backgroundColor = [UIColor clearColor];
    self.scTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.timeNodeTableView];
    [self.view addSubview:self.scTableView];


    self.timeNodeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.scTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.timeNodeTableView.showsVerticalScrollIndicator = NO;
    self.scTableView.showsVerticalScrollIndicator = NO;

    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left).offset(28);
        make.size.mas_equalTo(self.imgView.image.size);
    }];
    [self.timeNodeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(kScreenHeight - 64 - self.imgView.image.size.height - 49);
    }];
    [self.scTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.timeNodeTableView.mas_right);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(kScreenHeight - 64 - self.imgView.image.size.height - 49 + 35);
    }];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.timeNodeTableView = [[UITableView alloc]init];
        self.scTableView = [[UITableView alloc]init];
        self.imgView = [[UIImageView alloc]init];
        self.imgView.image = [UIImage imageNamed:@"more"];
        self.timeDelegate = [[CZTimeTableViewDelegate alloc]init];
        self.timeNodeTableView.delegate = self.timeDelegate;
        self.timeNodeTableView.dataSource = self.timeDelegate;
        self.scDelegate = [[CZScheduleTableViewDelegate alloc]init];
        self.scTableView.delegate = self.scDelegate;
        self.scTableView.dataSource = self.scDelegate;
        self.timeDelegate.scTableView = self.scTableView;
    }
    return self;
}
- (IBAction)addSchedule:(id)sender
{
    CZUpdateScheduleViewController *updateSc = [[CZUpdateScheduleViewController alloc]init];
    [self.navigationController pushViewController:updateSc animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods

//sequence the plan by date
//-(void)rangePlanList:(PlanList *)planList{
//    PlanModel *rPlModel = planList.list[0];
//    NSString *defaultStr = [rPlModel.planTime substringWithRange:NSMakeRange(5, 5)];
//    int i = 0;
//    self.planListRanged[0] = [[NSMutableArray alloc]init];
//    for (PlanModel *planModel in planList.list) {
//        if ([planModel.planTime substringWithRange:NSMakeRange(5, 5)] == defaultStr) {
//            [self.planListRanged[i] addObject:planModel];
//        }else{
//            i = i+1;
//            self.planListRanged[i] = [[NSMutableArray alloc]init];
//            defaultStr = [planModel.planTime substringWithRange:NSMakeRange(5, 5)];
//            [self.planListRanged[i] addObject:planModel];
//        }
//    }
//}

-(void)rangePlanList:(PlanList *)planList{
    PlanModel *rPlModel = planList.list[0];
    NSString *defaultStr = [rPlModel.planTime substringWithRange:NSMakeRange(5, 5)];
    NSMutableArray *templist = [[NSMutableArray alloc]init];
    for (PlanModel *planModel in planList.list) {
        if ([planModel.planTime substringWithRange:NSMakeRange(5, 5)] == defaultStr) {
            [templist addObject:planModel];
        }else{
            defaultStr = [planModel.planTime substringWithRange:NSMakeRange(5, 5)];
            [self.planListRanged addObject:templist];
            [templist removeAllObjects];
            [templist addObject:planModel];
        }
    }
}

//获取当前设备
- (CurrentDevice)currentDeviceSize
{
    if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 4"] ||
        [[self getCurrentDeviceModel] isEqualToString:@"iPhone 5"])
    {
        return IPhone5;
        
    }else if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 6"])
    {
        return IPhone6;
    }else
    {
        return Iphone6Plus;
    }
}
//获得设备型号
- (NSString *)getCurrentDeviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

@end
