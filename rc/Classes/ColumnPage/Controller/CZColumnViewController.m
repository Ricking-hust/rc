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

@interface CZColumnViewController ()
@property (nonatomic, strong) CZLeftTableViewDelegate *leftDelegate;
@property (nonatomic, strong) CZRightTableViewDelegate *rightDelegate;
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
@property (nonatomic,strong) NSMutableDictionary *activityDic;

@property (nonatomic,copy) NSURLSessionDataTask *(^getIndListBlock)();
@property (nonatomic,copy) NSURLSessionDataTask *(^getActivityListWithIndBlock)(IndustryModel *model);
@end

@implementation CZColumnViewController


- (void)createSubview
{
    self.other = [[RCColumnInfoView alloc]init];
    self.internet = [[RCColumnInfoView alloc]init];
    self.media = [[RCColumnInfoView alloc]init];
    self.university = [[RCColumnInfoView alloc]init];
    self.businessStartups = [[RCColumnInfoView alloc]init];
    self.finance = [[RCColumnInfoView alloc]init];
    self.leftDelegate = [[CZLeftTableViewDelegate alloc]init];
    self.rightDelegate = [[CZRightTableViewDelegate alloc]init];
    self.tagArray = [[NSArray alloc]initWithObjects:self.other,self.internet,self.media,self.university,self.businessStartups, self.finance, nil];
}
#pragma mark - ViewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *temp = [[UIView alloc]init];
    [self.view addSubview:temp];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    [self createSubview];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewContentSize:) name:@"ContentSize" object:nil];
    [self configureBlocks];
    self.getIndListBlock();
    //self.other.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)onClickTooBtn:(UIButton *)btn
{
    
    [self isToolButtonSelected:btn];
    //此处添加按钮点击事件的处理代码---------------
    NSString *tagName = btn.titleLabel.text;
    if ([tagName isEqualToString:@"互联网"])
    {
        for (int i = 0; i <self.tagArray.count; i++)
        {
            RCColumnInfoView *infoView = self.tagArray[i];
            infoView.hidden = YES;
        }
        self.internet.hidden = NO;
    }else if ([tagName isEqualToString:@"大学"])
    {
        for (int i = 0; i <self.tagArray.count; i++)
        {
            RCColumnInfoView *infoView = self.tagArray[i];
            infoView.hidden = YES;
        }
        self.university.hidden = NO;
    }else if ([tagName isEqualToString:@"传媒"])
    {
        for (int i = 0; i <self.tagArray.count; i++)
        {
            RCColumnInfoView *infoView = self.tagArray[i];
            infoView.hidden = YES;
        }
        self.media.hidden = NO;
    }else if ([tagName isEqualToString:@"创业"])
    {
        for (int i = 0; i <self.tagArray.count; i++)
        {
            RCColumnInfoView *infoView = self.tagArray[i];
            infoView.hidden = YES;
        }
        self.businessStartups.hidden = NO;
    }else if ([tagName isEqualToString:@"金融"])
    {
        for (int i = 0; i <self.tagArray.count; i++)
        {
            RCColumnInfoView *infoView = self.tagArray[i];
            infoView.hidden = YES;
        }
        self.finance.hidden = NO;
    }else
    {
        for (int i = 0; i <self.tagArray.count; i++)
        {
            RCColumnInfoView *infoView = self.tagArray[i];
            infoView.hidden = YES;
        }
        self.other.hidden = NO;
    }
    
}
- (void)addSubviewToView
{
    self.other.leftTableView.delegate = self.leftDelegate;
    self.other.leftTableView.dataSource = self.leftDelegate;
    self.other.rightTableView.delegate = self.rightDelegate;
    self.other.rightTableView.dataSource = self.rightDelegate;
    
    self.leftDelegate.leftTableView = self.other.leftTableView;
    self.leftDelegate.rightTableView = self.other.rightTableView;
    self.rightDelegate.rightTableView = self.other.rightTableView;
    self.rightDelegate.leftTableView = self.other.leftTableView;
    
//    self.internet.leftTableView.delegate = self.leftDelegate;
//    self.internet.leftTableView.dataSource = self.leftDelegate;
//    self.internet.rightTableView.delegate = self.rightDelegate;
//    self.internet.rightTableView.dataSource = self.rightDelegate;
//    
//    self.media.leftTableView.delegate = self.leftDelegate;
//    self.media.leftTableView.dataSource = self.leftDelegate;
//    self.media.rightTableView.delegate = self.rightDelegate;
//    self.media.rightTableView.dataSource = self.rightDelegate;
//    
//    self.university.leftTableView.delegate = self.leftDelegate;
//    self.university.leftTableView.dataSource = self.leftDelegate;
//    self.university.rightTableView.dataSource = self.rightDelegate;
//    self.university.rightTableView.delegate = self.rightDelegate;
//    
//    self.finance.leftTableView.dataSource = self.leftDelegate;
//    self.finance.leftTableView.delegate = self.leftDelegate;
//    self.finance.rightTableView.delegate = self.rightDelegate;
//    self.finance.rightTableView.dataSource = self.rightDelegate;
    
    self.leftDelegate.array = self.activityList.list;
    self.rightDelegate.array = self.activityList.list;
    
    [self.view addSubview:self.other];
    [self.view addSubview:self.internet];
    [self.view addSubview:self.media];
    [self.view addSubview:self.university];
    [self.view addSubview:self.finance];
    [self.other mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolScrollView.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
    }];
//    [self.internet mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.other.mas_top);
//        make.right.equalTo(self.view.mas_right);
//        make.left.equalTo(self.view.mas_left);
//        make.bottom.equalTo(self.other.mas_bottom);
//    }];
//    [self.media mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.other.mas_top);
//        make.right.equalTo(self.view.mas_right);
//        make.left.equalTo(self.view.mas_left);
//        make.bottom.equalTo(self.other.mas_bottom);
//    }];
//    [self.university mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.other.mas_top);
//        make.right.equalTo(self.view.mas_right);
//        make.left.equalTo(self.view.mas_left);
//        make.bottom.equalTo(self.other.mas_bottom);
//    }];
//    [self.finance mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.other.mas_top);
//        make.right.equalTo(self.view.mas_right);
//        make.left.equalTo(self.view.mas_left);
//        make.bottom.equalTo(self.other.mas_bottom);
//    }];
}

-(void)didReceiveMemoryWarning{
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
            IndustryModel *model = self.indList.list[0];
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

-(void)setActivityDic:(NSMutableDictionary *)activityDic{
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
        //添加tagButton的观察者
        //[self addObserver:btnView.tagButton forKeyPath:@"tagButton" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
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

            self.leftDelegate.subHeight = self.subHeight;
            CZTableView *left = [tableView.superview viewWithTag:11];
            //[left reloadData];
        }else if (self.rightH - self.leftH < 0)
        {
            [self.rightArray addObject:@"2"];
            self.subHeight = ABS(self.rightH - self.leftH);

            self.rightDelegate.subHeight = self.subHeight;
            CZTableView *right = [tableView.superview viewWithTag:12];
            //[right reloadData];
        }else
        {
            ;
        }
    }
    
}

////设置界面顶部的工具栏
//- (void)createToolView
//{
////    //添加四个边阴影
////    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
////    CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){200/255 ,199/255,204/255,0.8});
////    self.toolView.layer.shadowColor = color;//阴影颜色
////    self.toolView.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
////    self.toolView.layer.shadowOpacity = 0.7;//不透明度
////    self.toolView.layer.shadowRadius = 5.0;//半径
//    
//    self.all = [CZToolView toolView:@"全部"];
//    [self.all.btn setTag:0];
//    [self.all.btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.all.btn.selected = YES;
//    self.all.btn.tintColor = self.selectedColor;
//    self.all.segmentView.hidden = NO;
//    [self.toolView addSubview:self.all];
//    
//    self.finance = [CZToolView toolView:@"金融"];
//    [self.finance.btn setTag:1];
//    [self.finance.btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.toolView addSubview:self.finance];
//    
//    self.media = [CZToolView toolView:@"传媒"];
//    [self.media .btn setTag:2];
//    [self.media .btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.toolView addSubview:self.media ];
//    
//    
//    self.bStarup = [CZToolView toolView:@"创业"];
//    [self.bStarup.btn setTag:3];
//    [self.bStarup.btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.toolView addSubview:self.bStarup];
//    
//    self.net = [CZToolView toolView:@"互联网"];
//    [self.net.btn setTag:4];
//    [self.net.btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.toolView addSubview:self.net];
//    
//    self.design = [CZToolView toolView:@"设计"];
//    [self.design.btn setTag:5];
//    [self.design.btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.toolView addSubview:self.design];
//    
//    self.more = [CZToolView toolView:@""];
//    [self.more.btn setTag:6];
//    [self.more.btn setImage:[UIImage imageNamed:@"moreTag"] forState:UIControlStateNormal];
//    [self.more .btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self.toolView addSubview:self.more ];
//}
//- (void)addConstraints
//{
//    CGFloat padding;
//    if ([[self getCurrentDeviceModel]isEqualToString:@"iPhone 4"] ||
//        [[self getCurrentDeviceModel]isEqualToString:@"iPhone 5"] )
//    {
//        padding = 45;
//    }else if ([[self getCurrentDeviceModel]isEqualToString:@"iPhone 6"] ||
//              [[self getCurrentDeviceModel]isEqualToString:@"iPhone Simulator"])
//    {
//        padding = 52;
//    }else
//    {
//        padding = 60;
//    }
//
//    [self.all mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.toolView.mas_top);
//        make.left.equalTo(self.toolView.mas_left).with.offset(10);
//    }];
//    
//    [self.finance mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.all.mas_top);
//        make.left.equalTo(self.all.mas_right).with.offset(padding);
//    }];
//    [self.media mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.all.mas_top);
//        make.left.equalTo(self.finance.mas_right).with.offset(padding);
//    }];
//    [self.bStarup mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.all.mas_top);
//        make.left.equalTo(self.media.mas_right).with.offset(padding);
//    }];
//    [self.design mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.all.mas_top);
//        make.left.equalTo(self.bStarup.mas_right).with.offset(padding);
//    }];
//    [self.net mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.all.mas_top);
//        make.left.equalTo(self.design.mas_right).with.offset(padding - 10);
//        //make.size.mas_equalTo(CGSizeMake(45, 30));
//    }];
//    [self.more mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.all.mas_top);
//        make.left.equalTo(self.net.mas_right).with.offset(padding - 10);
//    }];
//
//}
//- (void)onClick:(UIButton *)btn
//{
//    if (btn.selected == YES) {
//        NSLog(@"selected");
//    }
//}

@end
