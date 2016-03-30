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
#import "CZColumnCell.h"
#import "CZActivityInfoViewController.h"
#import "MyTableView.h"
//MJReflesh--------------------------------
#import "MJRefresh.h"
#import "RCHomeRefreshHeader.h"
#define NAME_FONTSIZE 14
#define TIME_FONTSIZE 12
#define PLACE_FONTSIZE 12
#define TAG_FONTSIZE  11
@interface CZColumnViewController ()

@property (nonatomic, strong) RCColumnTableView *rcTV;
@property (nonatomic, strong) UIScrollView *superTableView;
@property (nonatomic, strong) MyTableView *leftTableView;
@property (nonatomic, strong) MyTableView *rightTableView;
@property (nonatomic, strong) NSMutableArray *leftArray;
@property (nonatomic, strong) NSMutableArray *rightArray;
@property (nonatomic, assign) CGFloat contentSizeHeight;

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
- (CGFloat)contentSizeHeight
{
    if (!_contentSizeHeight)
    {
        _contentSizeHeight = 0;
    }
    return _contentSizeHeight;
}
- (NSMutableArray *)leftArray
{
    if (!_leftArray)
    {
        _leftArray = [[NSMutableArray alloc]init];
    }
    return _leftArray;
}
- (NSMutableArray *)rightArray
{
    if (!_rightArray)
    {
        _rightArray = [[NSMutableArray alloc]init];
    }
    return _rightArray;
}
- (UIScrollView *)superTableView
{
    if (!_superTableView)
    {
        _superTableView = [[UIScrollView alloc]init];
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        [_superTableView addSubview:view];
        [self.view addSubview:_superTableView];
    }
    return _superTableView;
}
- (UITableView *)leftTableView
{
    if (!_leftTableView)
    {
        _leftTableView = [[MyTableView alloc]init];
        [self.superTableView addSubview:_leftTableView];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.showsVerticalScrollIndicator = NO;
    }
    return _leftTableView;
}
- (UITableView *)rightTableView
{
    if (!_rightTableView)
    {
        _rightTableView = [[MyTableView alloc]init];
        [self.superTableView addSubview:_rightTableView];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.showsVerticalScrollIndicator = NO;
    }
    return _rightTableView;
}
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

}

#pragma mark - ViewDidLoad
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *temp = [[UIView alloc]init];
    [self.view addSubview:temp];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadDefaultInfo) name:@"load" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addjustContentSize:) name:@"contentSize" object:nil];
//    [self createSubView];
    [self createTableView];
    [self configureBlocks];
    self.getIndListBlock();
    [self addSwipeGesture];

    self.superTableView.mj_header = [RCHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    self.superTableView.mj_header = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
}
- (void)loadNewData
{
    
}
- (void)getMoreData
{
    
}
- (void)addjustContentSize:(NSNotification *)notification
{
//    MyTableView *tv = (MyTableView *)notification.object;
//    if (tv.contentSize.height > self.contentSizeHeight)
//    {
//        self.contentSizeHeight = tv.contentSizeHeight;
//        self.superTableView.contentSize = CGSizeMake(0, self.contentSizeHeight);
//        
//        [self.rightTableView setContentSize:CGSizeMake(0, self.contentSizeHeight)];
//        [self.leftTableView setContentSize:CGSizeMake(0, self.contentSizeHeight)];
//    }else
//    {
//        self.superTableView.contentSize = CGSizeMake(0, tv.contentSize.height);
//        
//        [self.rightTableView setContentSize:CGSizeMake(0, tv.contentSize.height)];
//        [self.leftTableView setContentSize:CGSizeMake(0, tv.contentSize.height)];
//    }
}
#pragma mark - 创建tableView
- (void)createTableView
{
    self.superTableView.backgroundColor = [UIColor clearColor];
    self.leftTableView.backgroundColor = [UIColor clearColor];
    self.rightTableView.backgroundColor = [UIColor clearColor];
    self.leftTableView.tag = 10;
    self.rightTableView.tag = 20;
    [self.superTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolScrollView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.width.mas_equalTo(kScreenWidth);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
    }];

    [self.leftTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.superTableView.mas_top);
        make.width.mas_equalTo(kScreenWidth/2);
        make.left.equalTo(self.superTableView.mas_left);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
    }];
    
    [self.rightTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftTableView.mas_top);
        make.width.mas_equalTo(kScreenWidth/2);
        make.left.equalTo(self.leftTableView.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
    }];
    
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
#pragma mark - 修改
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

- (void)updateDateSourceByInd:(NSString *)ind
{

    ActivityList *defaultInd = [self.acByind valueForKey:ind];

    NSMutableArray *leftArray = [[NSMutableArray alloc]init];
    NSMutableArray *rightArray = [[NSMutableArray alloc]init];
    for (int i =0; i < defaultInd.list.count; i++) {
        if (i<(defaultInd.list.count/2))
        {
            [leftArray addObject:defaultInd.list[i]];
        } else
        {
            [rightArray addObject:defaultInd.list[i]];
        }
    }
#pragma mark - 修改
//    self.rightDelegate.array = rightArray;
//    self.leftDelegate.array = leftArray;
    self.rightArray = rightArray;
    self.leftArray = leftArray;
#pragma mark - 修改
//    [self.rcTV.rightTableView reloadData];
//    [self.rcTV.leftTableView reloadData];
    [self.rightTableView reloadData];
    [self.leftTableView reloadData];
#pragma mark - 修改
//    if (self.rcTV.leftTableView.contentSize.height > self.rcTV.rightTableView.contentSize.height)
//    {
//        [self.rcTV.rightTableView setContentSize:CGSizeMake(0, self.rcTV.leftTableView.contentSize.height)];
//    }else if(self.rcTV.leftTableView.contentSize.height < self.rcTV.rightTableView.contentSize.height)
//    {
//        [self.rcTV.leftTableView setContentSize:CGSizeMake(0, self.rcTV.rightTableView.contentSize.height)];
//    }else
//    {
//        
//    }
    
    
    
    if (self.leftTableView.contentSize.height > self.rightTableView.contentSize.height)
    {
        [self.rightTableView setContentSize:CGSizeMake(0, self.leftTableView.contentSize.height)];
    }else if(self.leftTableView.contentSize.height < self.rightTableView.contentSize.height)
    {
        [self.leftTableView setContentSize:CGSizeMake(0, self.rightTableView.contentSize.height)];
    }else
    {
        ;
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
#pragma mark - 多个TableView Version
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
#pragma mark - 初次进入时加载默认数据
- (void)loadDefaultInfo
{
    ActivityList *defaultInd = [self.acByind valueForKey:@"互联网"];
#pragma mark - 修改
//    NSMutableArray *leftArray = [[NSMutableArray alloc]init];
//    NSMutableArray *rightArray = [[NSMutableArray alloc]init];
    for (int i =0; i < defaultInd.list.count; i++)
    {
        if (i<(defaultInd.list.count/2))
        {
#pragma mark - 修改
            [self.leftArray addObject:defaultInd.list[i]];
            //[leftArray addObject:defaultInd.list[i]];
        } else
        {
#pragma mark - 修改
            [self.rightArray addObject:defaultInd.list[i]];
            //[rightArray addObject:defaultInd.list[i]];
        }
    }
#pragma mark - 修改
    //self.rightDelegate.array = rightArray;
    //self.leftDelegate.array = leftArray;
    self.rightDelegate.array = self.rightArray;
    self.leftDelegate.array = self.leftArray;
#pragma mark - 修改
//    [self.rcTV.leftTableView reloadData];
//    [self.rcTV.rightTableView reloadData];
    [self.rightTableView reloadData];
    [self.leftTableView reloadData];
    
#pragma mark - 修改
//    if (self.rcTV.leftTableView.contentSize.height > self.rcTV.rightTableView.contentSize.height)
//    {
//        [self.rcTV.rightTableView setContentSize:CGSizeMake(0, self.rcTV.leftTableView.contentSize.height)];
//    }else if(self.rcTV.leftTableView.contentSize.height < self.rcTV.rightTableView.contentSize.height)
//    {
//        [self.rcTV.leftTableView setContentSize:CGSizeMake(0, self.rcTV.rightTableView.contentSize.height)];
//    }else
//    {
//        ;
//    }
    
    
    if (self.leftTableView.contentSize.height > self.rightTableView.contentSize.height)
    {
        [self.rightTableView setContentSize:CGSizeMake(0, self.leftTableView.contentSize.height)];
    }else if(self.leftTableView.contentSize.height < self.rightTableView.contentSize.height)
    {
        [self.leftTableView setContentSize:CGSizeMake(0, self.rightTableView.contentSize.height)];
    }else
    {
        ;
    }

}
-(void)setIndList:(IndustryList *)indList
{
    _indList = indList;
    //创建工具条按钮
    if (_indList)
    {
        [self showToolButtons];
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
#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 10)
    {
        return self.leftArray.count;
    }else
    {
        return self.rightArray.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 10)
    {
        //1 创建可重用的自定义cell
        CZColumnCell *cell = [CZColumnCell cellWithTableView:tableView];
        cell.isLeft = YES;
        //对cell内的控件进行赋值
        [self setCellValue:cell AtIndexPath:indexPath InTableView:tableView];
        //对cell内的控件进行布局
        [cell setSubviewConstraint];
        return cell;
    }else
    {
        //1 创建可重用的自定义cell
        CZColumnCell *cell = [CZColumnCell cellWithTableView:tableView];
        cell.isLeft = NO;
        //对cell内的控件进行赋值
        [self setCellValue:cell AtIndexPath:indexPath InTableView:tableView];
        //对cell内的控件进行布局
        [cell setSubviewConstraint];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZActivityInfoViewController *info = [[CZActivityInfoViewController alloc]init];
    info.title = @"活动介绍";
    if (tableView.tag == 10)
    {
        info.activityModelPre = self.leftArray[indexPath.row];
    }else
    {
        info.activityModelPre = self.rightArray[indexPath.row];
    }
    
    [self.navigationController pushViewController:info animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag == 10)
    {
        
        CGFloat height = [self contacterTableCell:self.leftArray[indexPath.row]];
        return height;
    }else
    {
        CGFloat height = [self contacterTableCell:self.rightArray[indexPath.row]];
        return height;
    }
}
- (CGFloat)contacterTableCell:(ActivityModel *)model
{
    CGFloat acImageW; //图片的最大宽度,活动名的最大宽度
    CGFloat acImageH; //图片的最大高度
    CGFloat leftPaddintToContentView;
    CGFloat rightPaddingToContentView;
    if ([self currentDeviceSize] == IPhone5)
    {
        acImageW = 142;
        acImageH = 110;
        leftPaddintToContentView = 12;
        rightPaddingToContentView = leftPaddintToContentView;
        
    }else if ([self currentDeviceSize]  == IPhone6)
    {
        acImageW = 165;
        acImageH = 125;
        leftPaddintToContentView = 15;
        rightPaddingToContentView = leftPaddintToContentView;
    }else
    {
        acImageW = 177;
        acImageH = 135;
        leftPaddintToContentView = 20;
        rightPaddingToContentView = leftPaddintToContentView;
    }
    CGSize maxSize = CGSizeMake(acImageW - 20, MAXFLOAT);
    CGSize acNameSize = [self sizeWithText:model.acTitle maxSize:maxSize fontSize:NAME_FONTSIZE];
    CGSize acTimeSize = [self sizeWithText:model.acTime maxSize:maxSize fontSize:TIME_FONTSIZE];
    CGSize acPlaceSize = [self sizeWithText:model.acPlace maxSize:maxSize fontSize:PLACE_FONTSIZE];
    CGSize acTagSize = [self sizeWithText:model.userInfo.userName maxSize:maxSize fontSize:TAG_FONTSIZE];
    return acImageH + 10 + acNameSize.height + 10 + acTimeSize.height + acPlaceSize.height + 10 + acTagSize.height+15;
}
//给单元格进行赋值
- (void) setCellValue:(CZColumnCell *)cell AtIndexPath:(NSIndexPath *)indexPath InTableView:(UITableView *)tableView
{
    
    if (tableView.tag == 10)
    {
        cell.bgView.tag = indexPath.row;
        ActivityModel *model = self.leftArray[indexPath.row];
        [cell.acImageView sd_setImageWithURL:[NSURL URLWithString:model.acPoster] placeholderImage:[UIImage imageNamed:@"20160102.png"]];
        cell.acNameLabel.text = model.acTitle;
        int len = (int)[model.acTime length];
        NSString *timeStr = [model.acTime substringWithRange:NSMakeRange(0, len - 3)];
        cell.acTimeLabel.text = timeStr;
        cell.acPlaceLabel.text = model.acPlace;
        
        cell.acTagLabel.text = model.userInfo.userName;
        
//        //添加手势
//        UITapGestureRecognizer *clickGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayInfo:)];
//        [cell.bgView addGestureRecognizer:clickGesture];

    }else
    {
        cell.bgView.tag = indexPath.row;
        ActivityModel *model = self.rightArray[indexPath.row];
        [cell.acImageView sd_setImageWithURL:[NSURL URLWithString:model.acPoster] placeholderImage:[UIImage imageNamed:@"20160102.png"]];
        cell.acNameLabel.text = model.acTitle;
        int len = (int)[model.acTime length];
        NSString *timeStr = [model.acTime substringWithRange:NSMakeRange(0, len - 3)];
        cell.acTimeLabel.text = timeStr;
        cell.acPlaceLabel.text = model.acPlace;
        
        cell.acTagLabel.text = model.userInfo.userName;
        
//        //添加手势
//        UITapGestureRecognizer *clickGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayInfo:)];
//        [cell.bgView addGestureRecognizer:clickGesture];

    }
}

- (void)displayInfo:(UITapGestureRecognizer *)gesture
{
//    UIView *view = gesture.view;
//    NSLog(@"tag %ld",view.tag);
//    CZColumnCell *cell = (CZColumnCell *)view.superview;
////    NSLog(@"%@",cell.acNameLabel.text);
//    CZActivityInfoViewController *info = [[CZActivityInfoViewController alloc]init];
//    info.title = @"活动介绍";
//    if (cell.tag == 20)
//    {
//        info.activityModelPre = self.leftArray[view.tag];
//    }else
//    {
//        info.activityModelPre = self.rightArray[view.tag];
//    }
//
//    [self.navigationController pushViewController:info animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.rightTableView setContentOffset:scrollView.contentOffset];
    [self.leftTableView setContentOffset:scrollView.contentOffset];
}
//获取当前设备
- (CurrentDevice)currentDeviceSize
{
    if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 4"] ||
        [[self getCurrentDeviceModel] isEqualToString:@"iPhone 5"])
    {
        return IPhone5;
        
    }else if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 6"] )
    {
        return IPhone6;
    }else
    {
        return Iphone6Plus;
    }
}

/**
 *  计算字体的长和宽
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
