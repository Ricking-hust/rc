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
#import "CZLeftTableViewDelegate.h"
#import "CZRightTableViewDelegate.h"
#import "UINavigationBar+Awesome.h"
#import "RCColumnTableView.h"
//MJReflesh--------------------------------
#import "MJRefresh.h"
#import "RCColumnTableViewReflesh.h"
@interface CZColumnViewController ()

@property (nonatomic, strong) RCColumnTableView *rcTV;
@property (nonatomic, strong) CZLeftTableViewDelegate *leftDelegate;
@property (nonatomic, strong) CZRightTableViewDelegate *rightDelegate;

@property (nonatomic, strong) UIScrollView *toolScrollView;
@property (nonatomic, strong) NSMutableArray *toolButtonArray;

@property (nonatomic, strong) IndustryList *indList;
@property (nonatomic, strong) ActivityList *activityList;

@property (nonatomic, copy) NSURLSessionDataTask *(^getIndListBlock)();
@property (nonatomic, copy) NSURLSessionDataTask *(^getActivityListWithIndBlock)(IndustryModel *model);
@property (nonatomic, copy) NSMutableDictionary *acByind;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) NSMutableDictionary *columnTableView;
@end

@implementation CZColumnViewController
- (NSMutableDictionary *)columnTableView
{
    if (!_columnTableView)
    {
        _columnTableView = [[NSMutableDictionary alloc]init];
    }
    return _columnTableView;
}
- (int)currentPage
{
    if (!_currentPage)
    {
        _currentPage = 0;
    }
    return _currentPage;
}
- (NSMutableDictionary *)acByind
{
    if (!_acByind)
    {
        _acByind = [[NSMutableDictionary alloc]init];
    }
    return _acByind;

}
- (CZLeftTableViewDelegate *)leftDelegate
{
    if (!_leftDelegate)
    {
        _leftDelegate = [[CZLeftTableViewDelegate alloc]init];
    }
    return _leftDelegate;
}
- (CZRightTableViewDelegate *)rightDelegate
{
    if (!_rightDelegate)
    {
        _rightDelegate = [[CZRightTableViewDelegate alloc]init];
    }
    return _rightDelegate;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    
    NSLog(@"left %f",self.rcTV.leftTableView.contentSize.height);
    NSLog(@"right %f",self.rcTV.rightTableView.contentSize.height);
}

#pragma mark - ViewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *temp = [[UIView alloc]init];
    [self.view addSubview:temp];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadDefaultInfo) name:@"load" object:nil];
    [self createSubView];
    [self configureBlocks];
    self.getIndListBlock();
    [self addSwipeGesture];
    self.rcTV.leftTableView.mj_header = [RCColumnTableViewReflesh headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
}
- (void)loadNewData
{
    // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 结束刷新
        [self.rcTV.leftTableView.mj_header endRefreshing];
    });

}
- (void)addSwipeGesture
{
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];


    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizer];

    
}

#pragma mark - 左右滑动手势
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft )
    {
        if(self.currentPage > self.toolButtonArray.count - 1)
        {
            
            self.currentPage = (int)self.toolButtonArray.count - 1;
        }
        
        else if(self.currentPage != self.toolButtonArray.count - 1)
        {
            self.currentPage++;

            [UIView beginAnimations:nil context:nil];
            //持续时间
            [UIView setAnimationDuration:1.0];
            
            //在出动画的时候减缓速度
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            
            //添加动画开始及结束的代理
            [UIView setAnimationDelegate:self];
            [UIView setAnimationWillStartSelector:@selector(begin)];
            [UIView setAnimationDidStopSelector:@selector(stopAnimating)];
            
            //动画效果
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
            //切换行业
            [self onClickTooBtn:self.toolButtonArray[self.currentPage]];
            
            [UIView commitAnimations];
        }
    }

    else if(sender.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if(self.currentPage < 0)
        {
            
            self.currentPage=0;
        }
        else if(self.currentPage!=0)
        {
            
            self.currentPage--;

            [UIView beginAnimations:nil context:nil];
            //持续时间
            [UIView setAnimationDuration:1.0];
            
            //在出动画的时候减缓速度
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            
            //添加动画开始及结束的代理
            [UIView setAnimationDelegate:self];
            [UIView setAnimationWillStartSelector:@selector(begin)];
            [UIView setAnimationDidStopSelector:@selector(stopAnimating)];
            
            //动画效果
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
            
            //切换行业
            [self onClickTooBtn:self.toolButtonArray[self.currentPage]];
            
            [UIView commitAnimations];
        }
    }

}
- (void)getData
{
    dispatch_queue_t getAcSerialQueue = dispatch_queue_create("com.rc.column", NULL);
    dispatch_async(getAcSerialQueue, ^{

        [self configureBlocks];
        self.getIndListBlock();
    });

    dispatch_async(getAcSerialQueue, ^{

       dispatch_async(dispatch_get_main_queue(), ^{
           //更新UI
           if (self.activityList.list.count != 0 )
           {
               ActivityList *defaultInd = [self.acByind valueForKey:@"互联网"];
               NSMutableArray *leftArray = [[NSMutableArray alloc]init];
               NSMutableArray *rightArray = [[NSMutableArray alloc]init];
               for (int i =0; i < defaultInd.list.count; i++)
               {
                   if (i<(defaultInd.list.count/2))
                   {
                       [leftArray addObject:defaultInd.list[i]];
                   } else
                   {
                       [rightArray addObject:defaultInd.list[i]];
                   }
               }
               self.rightDelegate.array = rightArray;
               self.leftDelegate.array = leftArray;
           }else
           {
               //无数据或者网络异常处理
               NSLog(@"no data");
           }

       });
    });
}
- (void)createSubView
{
    self.rcTV = [[RCColumnTableView alloc]init];
    [self.view addSubview:self.rcTV];
    [self.rcTV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolScrollView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
    }];
    self.rcTV.view = self.view;
    self.leftDelegate.leftTableView = self.rcTV.leftTableView;
    self.leftDelegate.rightTableView = self.rcTV.rightTableView;
    self.rightDelegate.leftTableView = self.rcTV.leftTableView;
    self.rightDelegate.rightTableView = self.rcTV.rightTableView;
    
    self.rcTV.leftTableView.delegate = self.leftDelegate;
    self.rcTV.leftTableView.dataSource = self.leftDelegate;
    self.rcTV.rightTableView.delegate  = self.rightDelegate;
    self.rcTV.rightTableView.dataSource = self.rightDelegate;
    
    //将self.view添加到tableView代理的响应链中
    self.leftDelegate.view = self.view;
    self.rightDelegate.view = self.view;
    
    UITableView *tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 100, 600)];
    [self.rcTV addSubview:tv];
    
    self.rcTV.mj_header = [RCColumnTableViewReflesh headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}
#pragma mark - 按钮点击事件的处理代码
- (void)onClickTooBtn:(UIButton *)btn
{
    
    [self isToolButtonSelected:btn];
    //此处按钮点击事件的处理代码添加---------------
    NSString *tagName = btn.titleLabel.text;
    if ([tagName isEqualToString:@"互联网"])
    {

        [self updateDateSourceByInd:tagName];
    }else if ([tagName isEqualToString:@"大学"])
    {

        [self updateDateSourceByInd:tagName];
        //[self change:tagName];
    }else if ([tagName isEqualToString:@"传媒"])
    {

        [self updateDateSourceByInd:tagName];
    }else if ([tagName isEqualToString:@"创业"])
    {

        [self updateDateSourceByInd:tagName];
    }else if ([tagName isEqualToString:@"金融"])
    {

        [self updateDateSourceByInd:tagName];
    }else if ([tagName isEqualToString:@"人文"])
    {

        [self updateDateSourceByInd:tagName];
    }else
    {

        [self updateDateSourceByInd:tagName];
    }
}
- (void)change:(NSString *)ind
{
    RCColumnTableView *rc = [self.columnTableView valueForKey:ind];
    [rc mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
    }];
}
- (void)updateDateSourceByInd:(NSString *)ind
{

    ActivityList *defaultInd = [self.acByind valueForKey:ind];
    NSMutableArray *leftArray = [[NSMutableArray alloc]init];
    NSMutableArray *rightArray = [[NSMutableArray alloc]init];
    for (int i =0; i < defaultInd.list.count; i++) {
        if (i<(defaultInd.list.count/2)) {
            [leftArray addObject:defaultInd.list[i]];
        } else {
            [rightArray addObject:defaultInd.list[i]];
        }
    }
    self.rightDelegate.array = rightArray;
    self.leftDelegate.array = leftArray;
    [self.rcTV.rightTableView reloadData];
    [self.rcTV.leftTableView reloadData];
    if (self.rcTV.leftTableView.contentSize.height > self.rcTV.rightTableView.contentSize.height)
    {
        [self.rcTV.rightTableView setContentSize:CGSizeMake(0, self.rcTV.leftTableView.contentSize.height)];
    }else if(self.rcTV.leftTableView.contentSize.height < self.rcTV.rightTableView.contentSize.height)
    {
        [self.rcTV.leftTableView setContentSize:CGSizeMake(0, self.rcTV.rightTableView.contentSize.height)];
    }else
    {
        
    }
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
            for (IndustryModel *model in self.indList.list) {
                self.getActivityListWithIndBlock(model);
                
            }
            
        } failure:^(NSError *error) {
            NSLog(@"Error:%@",error);
        }];
    };
    
    self.getActivityListWithIndBlock = ^(IndustryModel *model){
        @strongify(self);
        NSString *cityId = [[NSString alloc]init];
        if ([userDefaults objectForKey:@"cityId"]) {
            cityId = [userDefaults objectForKey:@"cityId"];
        } else {
            cityId = @"1";
        }
        return [[DataManager manager] checkIndustryWithCityId:cityId industryId:model.indId startId:@"0" success:^(ActivityList *acList) {
            @strongify(self);
            self.activityList = acList;
            [self.acByind setValue:self.activityList forKey:model.indName];
            //按行业加载数据
            //[self loadData:acList ByIndustry:model.indName];
            if ([model.indName isEqualToString:@"互联网"])
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"load" object:self.activityList];
            }
        } failure:^(NSError *error) {
            NSLog(@"Error:%@",error);
        }];
    };
}
- (void)loadData:(ActivityList *)activityList ByIndustry:(NSString *)industry
{
    RCColumnTableView *rc = [self.columnTableView valueForKey:industry];
    CZLeftTableViewDelegate *leftDelegate = [rc viewWithTag:20];
    CZRightTableViewDelegate *rightDelegate = [rc viewWithTag:30];
    NSMutableArray *leftArray = [[NSMutableArray alloc]init];
    NSMutableArray *rightArray = [[NSMutableArray alloc]init];
    for (int i =0; i < activityList.list.count; i++)
    {
        if (i<(activityList.list.count/2))
        {
            [leftArray addObject:activityList.list[i]];
        } else
        {
            [rightArray addObject:activityList.list[i]];
        }
    }
    rightDelegate.array = rightArray;
    leftDelegate.array = leftArray;
    if (rc.leftTableView.contentSize.height > rc.rightTableView.contentSize.height)
    {
        [rc.rightTableView setContentSize:CGSizeMake(0, rc.leftTableView.contentSize.height)];
    }else
    {
        [rc.leftTableView setContentSize:CGSizeMake(0, rc.rightTableView.contentSize.height)];
    }
    [rc.leftTableView reloadData];
    [rc.rightTableView reloadData];

}
#pragma mark - 初次进入时加载默认数据
- (void)loadDefaultInfo
{
    ActivityList *defaultInd = [self.acByind valueForKey:@"互联网"];
    NSMutableArray *leftArray = [[NSMutableArray alloc]init];
    NSMutableArray *rightArray = [[NSMutableArray alloc]init];
    for (int i =0; i < defaultInd.list.count; i++)
    {
        if (i<(defaultInd.list.count/2))
        {
            [leftArray addObject:defaultInd.list[i]];
        } else
        {
            [rightArray addObject:defaultInd.list[i]];
        }
    }
    self.rightDelegate.array = rightArray;
    self.leftDelegate.array = leftArray;
    [self.rcTV.leftTableView reloadData];
    [self.rcTV.rightTableView reloadData];
    
    NSLog(@"lh %f",self.rcTV.leftTableView.contentSize.height);
    NSLog(@"rh %f",self.self.rcTV.rightTableView.contentSize.height);
    if (self.rcTV.leftTableView.contentSize.height > self.rcTV.rightTableView.contentSize.height)
    {
        [self.rcTV.rightTableView setContentSize:CGSizeMake(0, self.rcTV.leftTableView.contentSize.height)];
    }else if(self.rcTV.leftTableView.contentSize.height < self.rcTV.rightTableView.contentSize.height)
    {
        [self.rcTV.leftTableView setContentSize:CGSizeMake(0, self.rcTV.rightTableView.contentSize.height)];
    }else
    {
        ;
    }
    NSLog(@"after");
    NSLog(@"lh %f",self.rcTV.leftTableView.contentSize.height);
    NSLog(@"rh %f",self.self.rcTV.rightTableView.contentSize.height);
}
- (RCColumnTableView *)createTableView:(int)index ToContainer:(UIView *)container
{
    RCColumnTableView *rcTV = [[RCColumnTableView alloc]init];
    [container addSubview:rcTV];
    [rcTV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolScrollView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(index*kScreenWidth);
        make.width.mas_equalTo(kScreenWidth);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
    }];
    rcTV.view = self.view;
    CZLeftTableViewDelegate *leftDelegate = [[CZLeftTableViewDelegate alloc]initWithFrame:CGRectZero];
    CZRightTableViewDelegate *rightDelegate = [[CZRightTableViewDelegate alloc]initWithFrame:CGRectZero];
    leftDelegate.tag = 20;
    rightDelegate.tag = 30;
    [rcTV addSubview:leftDelegate];
    [rcTV addSubview:rightDelegate];
    
    leftDelegate.leftTableView = rcTV.leftTableView;
    leftDelegate.rightTableView = rcTV.rightTableView;
    rightDelegate.leftTableView = rcTV.leftTableView;
    rightDelegate.rightTableView = rcTV.rightTableView;
    
    rcTV.leftTableView.delegate = leftDelegate;
    rcTV.leftTableView.dataSource = leftDelegate;
    rcTV.rightTableView.delegate  = rightDelegate;
    rcTV.rightTableView.dataSource = rightDelegate;
    
    //将self.view添加到tableView代理的响应链中
    leftDelegate.view = self.view;
    rightDelegate.view = self.view;

    return rcTV;
}
#pragma mark - 拖动事件处理
- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + point.x, recognizer.view.center.y);

    if (recognizer.state == UIGestureRecognizerStateChanged)
    {
        if (ABS(point.x) > kScreenWidth/2)
        {
            [recognizer.view mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.mas_left).offset(-kScreenWidth);
            }];
        }else
        {
            recognizer.view.center = CGPointMake(recognizer.view.center.x - point.x, recognizer.view.center.y);
        }

    }
}
- (void)createRCColumnTableView:(IndustryList *)indList
{
    UIView *container = [[UIView alloc]init];
    container.backgroundColor = [UIColor clearColor];
    [self.view addSubview:container];
    [container mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolScrollView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.width.mas_equalTo(kScreenWidth *self.indList.list.count);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
    }];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
    [container addGestureRecognizer:pan];
    for (int i = 0; i < indList.list.count; i++)
    {
        RCColumnTableView *rc = [self createTableView:i ToContainer:container];
        IndustryModel *model = indList.list[i];
        [self.columnTableView setObject:rc forKey:model.indName];
    }
    
}
-(void)setIndList:(IndustryList *)indList
{
    _indList = indList;
    //创建工具条按钮
    if (_indList)
    {
        [self showToolButtons];
        //[self createRCColumnTableView:_indList];
    }
}

-(void)setActivityList:(ActivityList *)activityList
{
    _activityList = activityList;
    
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
    CGFloat leftPadding = 10;
    CGFloat topPadding = (self.toolScrollView.frame.size.height - 30)/2;
    CGFloat padding = kScreenWidth * 0.07;
    
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

@end
