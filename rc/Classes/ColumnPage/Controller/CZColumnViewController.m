//
//  SecondViewController.m
//  日常
//
//  Created by AlanZhang on 15/12/17.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import "CZColumnViewController.h"
#import "Masonry.h"
#include <sys/sysctl.h>
#import "CZButtonView.h"
#import "IndustryModel.h"
#import "ActivityModel.h"
#import "DataManager.h"
#import "CZTableView.h"
#import "CZLeftTableViewDelegate.h"
#import "CZRightTableViewDelegate.h"
#import "RCColumnInfoView.h"
#import "UINavigationBar+Awesome.h"
#import "Activity.h"
@interface CZColumnViewController ()

@property (assign, nonatomic) CGFloat leftH;
@property (assign, nonatomic) CGFloat rightH;
@property (assign, nonatomic) CGFloat subHeight;
@property (nonatomic, strong) NSArray *tagArray;
@property (nonatomic, strong) NSMutableArray *leftArray;
@property (nonatomic, strong) NSMutableArray *rightArray;

@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, strong) UIScrollView *toolScrollView;
@property (nonatomic, strong) NSMutableArray *toolButtonArray;

@property (nonatomic,strong) IndustryList *indList;
@property (nonatomic,strong) ActivityList *activityList;
@property (nonatomic,copy) NSMutableArray *activityDic;

@property (nonatomic,copy) NSURLSessionDataTask *(^getIndListBlock)();
@property (nonatomic,copy) NSURLSessionDataTask *(^getActivityListWithIndBlock)(IndustryModel *model);
@property (nonatomic,strong) NSMutableArray *testArray;
@end

@implementation CZColumnViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    
//    Activity *activity = [Activity activity];
//    activity.ac_id = 11111;
//    activity.ac_poster = @"img_4";
//    activity.ac_title = @"2015年沸雪北京世界单板滑雪赛与现场音乐会";
//    activity.ac_time = @"时间：2015.1.1 14:00 AM";
//    activity.ac_place = @"地点：光谷体育馆";
//    activity.ac_tags = @"相亲 单身";
//    activity.ac_collect_num = 11111;
//    activity.ac_praise_num = 22222;
//    activity.ac_read_num = 33333;
//
//    for (int i = 0; i<10; i++) {
//        [self.testArray addObject:activity];
//    }

}

#pragma mark - ViewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *temp = [[UIView alloc]init];
    [self.view addSubview:temp];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewContentSize:) name:@"ContentSize" object:nil];
    [self configureBlocks];
    self.getIndListBlock();
}

- (void)onClickTooBtn:(UIButton *)btn
{
    
    [self isToolButtonSelected:btn];
    //此处添加按钮点击事件的处理代码---------------
    NSString *tagName = btn.titleLabel.text;
    
}
- (void)addSubviewToView
{


}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - get data

- (void)configureBlocks{
    @weakify(self);
    self.getIndListBlock = ^(){
        @strongify(self);
        return [[DataManager manager] getAllIndustriesWithSuccess:^(IndustryList *indList) {
            @strongify(self)
            self.indList = indList;
//            for (IndustryModel *model in self.indList.list) {
//                self.getActivityListWithIndBlock(model);
            
//            }
            IndustryModel *model = self.indList.list[1];
            self.getActivityListWithIndBlock(model);
        } failure:^(NSError *error) {
            NSLog(@"Error:%@",error);
        }];
    };
    
    self.getActivityListWithIndBlock = ^(IndustryModel *model){
        @strongify(self);
        return [[DataManager manager] checkIndustryWithCityId:@"1" industryId:model.indId startId:@"0" success:^(ActivityList *acList) {
            @strongify(self);
            self.activityList = acList;
        } failure:^(NSError *error) {
            NSLog(@"Error:%@",error);
        }];
    };
}


-(void)setIndList:(IndustryList *)indList{
    _indList = indList;
    //创建工具条按钮
    [self showToolButtons];
}

-(void)setActivityList:(ActivityList *)activityList{
    
    _activityList = activityList;
    
    [self addSubviewToView];
}

-(void)setActivityDic:(NSMutableArray *)activityDic{
    
    _activityDic =activityDic;
}
#pragma mark - 懒加载，创建主题色

- (UIColor *)selectedColor
{
    if (!_selectedColor) {
        _selectedColor = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:3.0/255.0 alpha:1.0];
    }
    return _selectedColor;
}
#pragma mark - 懒加载，创建toolScrollView
- (UIScrollView *)toolScrollView
{
    if (!_toolScrollView) {
         CGRect rect = [[UIScreen mainScreen]bounds];
        _toolScrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 68, rect.size.width, 35)];
        _toolScrollView.backgroundColor = [UIColor whiteColor];
        //设置分布滚动，去掉水平和垂直滚动条
        _toolScrollView.showsHorizontalScrollIndicator = NO;
        _toolScrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_toolScrollView ];
    }
    return _toolScrollView;
}

#pragma mark - 懒加载，创建toolbuttonarray
- (NSMutableArray *)toolButtonArray
{
    if (!_toolButtonArray)
    {
        _toolButtonArray = [[NSMutableArray alloc]init];
    }
    return _toolButtonArray;
}

//创建工具条按钮
- (void)showToolButtons
{
    //UIColor *selectedColor = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0] ;
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGFloat leftPadding = 10;
    CGFloat topPadding = (self.toolScrollView.frame.size.height - 30)/2;
    CGFloat padding = rect.size.width * 0.07;
    
    //设置工具条的水平滚动范围
    CGFloat horizontalContentSize = self.indList.list.count*30 + (self.indList.list.count - 1)*padding + leftPadding + 10;
    self.toolScrollView.contentSize = CGSizeMake(horizontalContentSize, 0);
    for (int i = 0; i<self.indList.list.count; i++)
    {
        IndustryModel *indModel = self.indList.list[i];
        CZButtonView *btnView = [[CZButtonView alloc]initWithTittle:indModel.indName];
        if (i == 0)
        {
            btnView.tagButton.selected = YES;
            btnView.line.hidden = NO;
        }else
        {
            btnView.line.hidden = YES;
        }
        [self.toolButtonArray addObject:btnView.tagButton];
        btnView.tagButton.tag = i;
        CGFloat ofButtonPadding = i * (padding + 30) + leftPadding;
        [btnView.tagButton addTarget:self action:@selector(onClickTooBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.toolScrollView addSubview:btnView];

        [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.toolScrollView.mas_left).with.offset(ofButtonPadding);
            make.top.equalTo(self.toolScrollView.mas_top).with.offset(topPadding);
        }];

    }
}

- (void)isToolButtonSelected:(UIButton *)btn
{
    for (int i = 0; i < self.toolButtonArray.count; ++i)
    {
        UIButton *button = self.toolButtonArray[i];
        UIView *view = button.superview;
        UIView *line = [view viewWithTag:12];
        line.hidden = YES;
        button.selected = NO;
    }
    btn.selected = YES;
    UIView *view = btn.superview;
    UIView *line = [view viewWithTag:12];
    line.hidden = NO;
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
- (void)tableViewContentSize:(NSNotification *)notification
{
    CZTableView *tableView = [notification object];
//    NSLog(@"%f",tableView.contentSize.height);
//    NSLog(@"%ld",tableView.tag);
    if (tableView.tag == 12)
    {
        if (tableView.contentSize.height != 0)
        {
            self.rightH =tableView.contentSize.height;
            
        }
    }else
    {
        if (tableView.contentSize.height != 0)
        {
            self.leftH =tableView.contentSize.height;
            
        }
    }
    if (self.rightH != 0 && self.leftH != 0 )
    {
        if (self.rightH - self.leftH > 0)
        {
            
            [self.leftArray addObject:@"2"];
            self.subHeight = self.rightH - self.leftH;

            //self.leftDelegate.subHeight = self.subHeight;
            //CZTableView *left = [tableView.superview viewWithTag:11];
            //[left reloadData];
        }else if (self.rightH - self.leftH < 0)
        {
            [self.rightArray addObject:@"2"];
            self.subHeight = ABS(self.rightH - self.leftH);

            //self.rightDelegate.subHeight = self.subHeight;
            //CZTableView *right = [tableView.superview viewWithTag:12];
            //[right reloadData];
        }else
        {
            ;
        }
    }
}

@end
