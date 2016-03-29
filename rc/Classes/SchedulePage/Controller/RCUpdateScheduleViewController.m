//
//  RCUpdateScheduleViewController.m
//  rc
//
//  Created by AlanZhang on 16/3/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCUpdateScheduleViewController.h"
#import "Masonry.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationSlide.h"
#import "CZTimeSelectView.h"
#import "CZMoreRemindTimeViewController.h"
#import "CZTagSelectView.h"
#import "CZTagWithLabelView.h"
#import "CZUpView.h"
#import "CZDownView.h"
#import "PlanModel.h"
#import "RCScheduleInfoViewController.h"
#import "RCScrollView.h"
#define FONTSIZE    14  //字体大小
#define MAXLENGTH   90  //contentTextView的最大字数
#define VIEWH self.view.frame.size.width * 0.12
@interface RCUpdateScheduleViewController ()
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, assign, readonly) CGFloat paddingAtDownViewH; //downView内的子控件之间的纵向间距
@property (nonatomic, assign, readonly) CGFloat textViewH;          //textView的高度
@property (nonatomic, strong) NSString *localTime;
@property (nonatomic, strong) PlanModel *model;
@end
@implementation RCUpdateScheduleViewController
#pragma mark - 修改行程代理
- (void)passSchedule:(id)schedule
{
    self.model = schedule;
}
- (void)passPlanListRanged:(NSMutableArray *)planListRanged
{
    self.planListRangedUpdate = planListRanged;
}
- (void)passNodeIndex:(id)nodeIndex
{
    self.updateNodeIndex = nodeIndex;
}
- (void)passScIndex:(int)index
{
    self.scIndexUpdate = index;
}
- (void)passTimeNodeScrollView:(id)timeNodeSV
{
    //self.timeNodeSVUpdate = timeNodeSV;
}
#pragma mark - 懒加载
//- (RCScrollView *)timeNodeSVUpdate
//{
//    if (!_timeNodeSVUpdate)
//    {
//        _timeNodeSVUpdate = [[RCScrollView alloc]initWithFrame:CGRectZero];
//    }
//    return _timeNodeSVUpdate;
//}
- (int)scIndexUpdate
{
    if (!_scIndexUpdate)
    {
        _scIndexUpdate = 0;
    }
    return _scIndexUpdate;
}
- (NSNumber *)nodeIndex
{
    if (!_updateNodeIndex)
    {
        _updateNodeIndex = [[NSNumber alloc]initWithInt:0];
    }
    return _updateNodeIndex;
}
- (PlanModel *)model
{
    if (!_model)
    {
        _model = [[PlanModel alloc]init];
    }
    return _model;
}
- (NSString *)localTime
{
    if (!_localTime)
    {
        _localTime = [[NSString alloc]init];
    }
    return _localTime;
}
- (NSMutableArray *)years
{
    if (!_years)
    {
        _years = [[NSMutableArray alloc]init];
        [_years addObject:@"2016"];
        [_years addObject:@"2017"];
    }
    return _years;
}
- (NSMutableArray *)months
{
    if (!_months)
    {
        _months = [[NSMutableArray alloc]init];
        NSString *temp;
        for (int i = 0; i < 12; ++i)
        {
            if (i < 9)
            {
                temp = [NSString stringWithFormat:@"0%d", i+1];
                [_months addObject:temp];
            }else
            {
                temp = [NSString stringWithFormat:@"%d",i+1];
                [_months addObject:temp];
            }
        }
        
    }
    return _months;
}
- (NSMutableArray *)days
{
    if (!_days)
    {
        _days = [[NSMutableArray alloc]init];
        NSString *temp;
        for (int i = 0; i < 31; ++i)
        {
            if (i < 9)
            {
                temp = [NSString stringWithFormat:@"0%d", i+1];
                [_days addObject:temp];
            }else
            {
                temp = [NSString stringWithFormat:@"%d",i+1];
                [_days addObject:temp];
            }
            
        }
    }
    return _days;
}
- (NSMutableArray *)times
{
    if (!_times)
    {
        _times = [[NSMutableArray alloc]init];
        [_times addObject:@"00:00"];
        [_times addObject:@"00:30"];
        [_times addObject:@"01:00"];
        [_times addObject:@"01:30"];
        [_times addObject:@"02:00"];
        [_times addObject:@"02:30"];
        [_times addObject:@"03:00"];
        [_times addObject:@"03:40"];
        [_times addObject:@"04:00"];
        [_times addObject:@"04:30"];
        
        [_times addObject:@"05:00"];
        [_times addObject:@"05:30"];
        [_times addObject:@"06:00"];
        [_times addObject:@"06:30"];
        [_times addObject:@"07:00"];
        [_times addObject:@"07:30"];
        [_times addObject:@"08:00"];
        [_times addObject:@"08:30"];
        [_times addObject:@"09:00"];
        [_times addObject:@"09:30"];
        [_times addObject:@"10:00"];
        [_times addObject:@"10:30"];
        [_times addObject:@"11:00"];
        [_times addObject:@"11:30"];
        [_times addObject:@"12:00"];
        [_times addObject:@"12:30"];
        
        [_times addObject:@"13:00"];
        [_times addObject:@"13:30"];
        [_times addObject:@"14:00"];
        [_times addObject:@"14:30"];
        [_times addObject:@"15:00"];
        [_times addObject:@"15:30"];
        [_times addObject:@"16:00"];
        [_times addObject:@"16:30"];
        [_times addObject:@"17:00"];
        [_times addObject:@"17:30"];
        [_times addObject:@"18:00"];
        [_times addObject:@"18:30"];
        [_times addObject:@"19:00"];
        [_times addObject:@"19:30"];
        [_times addObject:@"20:00"];
        [_times addObject:@"20:30"];
        
        [_times addObject:@"21:00"];
        [_times addObject:@"21:30"];
        [_times addObject:@"22:00"];
        [_times addObject:@"22:30"];
        [_times addObject:@"23:00"];
        [_times addObject:@"23:30"];
    }
    return _times;
}
#pragma mark - 显示行程信息
- (void)viewWillAppear:(BOOL)animated
{
    self.upView.themeNameLabel.text = self.model.themeName;
    self.upView.tagImgView.image = [self getThemeImage:self.model.themeName];
    self.downView.textView.text = self.model.planContent;
    self.downView.textView.alpha = 1.0;
    NSString *year = [self.model.planTime substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [self.model.planTime substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [self.model.planTime substringWithRange:NSMakeRange(8, 2)];
    NSString *time = [self.model.planTime substringWithRange:NSMakeRange(11, 5)];
    self.downView.timeInfoLabel.text = [NSString stringWithFormat:@"%@年%@月%@日 %@",year,month,day,time];
    CGSize timeSize = [self sizeWithText:self.downView.timeInfoLabel.text maxSize:CGSizeMake(MAXFLOAT, 20) fontSize:14];
    [self.downView.timeInfoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(timeSize.width+1, timeSize.height+1));
    }];
}
#pragma mark - 提交修改
- (void)commintModify
{
    if (![self.downView.textView.text isEqualToString:@"请输入行程地点+内容(40字以内)"])
    {
        self.model.themeName = self.upView.themeNameLabel.text;
        self.model.planContent = self.downView.textView.text;
        self.model.planTime = self.downView.timeInfoLabel.text;
        NSString *year = [self.downView.timeInfoLabel.text substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [self.downView.timeInfoLabel.text substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [self.downView.timeInfoLabel.text substringWithRange:NSMakeRange(8, 2)];
        NSString *time = [self.downView.timeInfoLabel.text substringWithRange:NSMakeRange(11, 6)];
        self.model.planTime = [NSString stringWithFormat:@"%@-%@-%@ %@",year,month,day,time];
        [self sortByDay:self.model];
        long int count = self.navigationController.viewControllers.count;
        RCScheduleInfoViewController *sc = self.navigationController.viewControllers[count -2];
        sc.isContentUpdate = YES;
//        NSString *themeId = [self getThemeId:self.model.themeName];
//        [[DataManager manager] addPlanWithOpType:@"1" planId:@"" userId:[userDefaults objectForKey:@"userId"] themeId:themeId planTime:self.model.planTime plAlarmOne:self.model.plAlarmOne plAlarmTwo:self.model.plAlarmTwo plAlarmThree:self.model.plAlarmThree planContent:self.model.planContent acPlace:self.model.acPlace success:^(NSString *msg) {
//            NSLog(@"Msg:%@",msg);
//        } failure:^(NSError *error) {
//            NSLog(@"Error:%@",error);
//        }];
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入内容" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
-(NSString *)getThemeId:(NSString *)theme{
    NSString *themeId = [[NSString alloc]init];
    if ([theme isEqualToString:@"会议"]) {
        themeId = @"1";
    } else if ([theme isEqualToString:@"约会"]){
        themeId = @"2";
    } else if ([theme isEqualToString:@"出差"]){
        themeId = @"3";
    } else if ([theme isEqualToString:@"运动"]){
        themeId = @"4";
    } else if ([theme isEqualToString:@"购物"]){
        themeId = @"5";
    } else if ([theme isEqualToString:@"娱乐"]){
        themeId = @"6";
    } else if ([theme isEqualToString:@"聚会"]){
        themeId = @"7";
    } else if ([theme isEqualToString:@"其他"]){
        themeId = @"8";
    }
    return themeId;
}
#pragma mark - 对行程重新排序
//如果修改了行程的时间，则要对行程重新排序
- (void)sortByDay:(PlanModel *)model
{
    if ([self.planListRangedUpdate[([self.updateNodeIndex intValue])] count] == 1)
    {
        [self.planListRangedUpdate removeObjectAtIndex:([self.updateNodeIndex intValue])];
        [self insertSC:model];
    }else
    {
        NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:self.planListRangedUpdate[([self.updateNodeIndex intValue])]];
        [temp removeObjectAtIndex:self.scIndexUpdate];
        [self.planListRangedUpdate removeObjectAtIndex:([self.updateNodeIndex intValue])];
        [self.planListRangedUpdate insertObject:temp atIndex:([self.updateNodeIndex intValue])];
        [self insertSC:model];
    }
}
- (void)insertSC:(PlanModel *)newModel
{
    int i;
    NSString *year = [newModel.planTime substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [newModel.planTime substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [newModel.planTime substringWithRange:NSMakeRange(8, 2)];
    NSString *time = [newModel.planTime substringWithRange:NSMakeRange(12, 5)];
    int currentDate = [[NSString stringWithFormat:@"%@%@%@",year, month, day] intValue];
    NSString *strCurrentDate = [NSString stringWithFormat:@"%@-%@-%@ %@",year,month,day,time];
    for (i = 0; i < self.planListRangedUpdate.count; i++)
    {
        NSMutableArray *array = self.planListRangedUpdate[i];
        PlanModel *model = [[PlanModel alloc]init];
        model = array.firstObject;
        
        NSString *year = [model.planTime substringWithRange:NSMakeRange(0, 4)];
        NSString *month = [model.planTime substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [model.planTime substringWithRange:NSMakeRange(8, 2)];
        int dataCmp = [[NSString stringWithFormat:@"%@%@%@",year, month, day] intValue];
        if (currentDate < dataCmp)
        {//比当前时间早
            if (i == 0)
            {
                NSMutableArray *newscArray = [[NSMutableArray alloc]init];
                newModel.planTime = strCurrentDate;
                [newscArray addObject:newModel];
                [self.planListRangedUpdate insertObject:newscArray atIndex:i];
                break;
            }else
            {
                NSMutableArray *newscArray = [[NSMutableArray alloc]init];
                newModel.planTime = strCurrentDate;
                [newscArray addObject:newModel];
                [self.planListRangedUpdate insertObject:newscArray atIndex:i];
                break;
            }
        }else if (currentDate > dataCmp)
        {//比当前时间晚
            //continue;
        }else
        {
            NSMutableArray *newscArray = [[NSMutableArray alloc]initWithArray:self.planListRangedUpdate[i]];
            newModel.planTime = strCurrentDate;
            [newscArray addObject:newModel];
            [self.planListRangedUpdate removeObjectAtIndex:i];
            [self.planListRangedUpdate insertObject:newscArray atIndex:i];
            break;
        }
    }
    if (i == self.self.planListRangedUpdate.count)
    {
        NSMutableArray *newscArray = [[NSMutableArray alloc]init];
        newModel.planTime = strCurrentDate;
        [newscArray addObject:newModel];
        [self.planListRangedUpdate addObject:newscArray];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //注册通知,确定contentTextView的text的字数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:self.downView.textView];
    self.isShow = NO;
    _paddingAtDownViewH = 10;
    _textViewH = self.view.frame.size.width * 0.23;
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];//设置格式
    [dateformat setTimeZone:[[NSTimeZone alloc]initWithName:@"Asia/Beijing"]];//指定时区
    NSString *localDate = [dateformat stringFromDate:date];
    NSRange range = NSMakeRange(0, 14);
    NSString *str = [NSString stringWithFormat:@"%@:00",[localDate substringWithRange:range]];
    
    self.localTime = str;
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    //设置导航栏的左右按钮
    [self setNavigationBarItem];
    [self createSubView];
    
    [self setSubViewsOfUpView];
    [self setSubViewsOfDownView];
    
    [self initMoreTagView];
}
#pragma mark - 初始化
- (void)createSubView
{
    self.upView = [[CZUpView alloc]init];
    self.downView = [[CZDownView alloc]init];
    
    self.meetingTag = [[CZTagWithLabelView alloc]initWithImage:[UIImage imageNamed:@"meetingIcon"] andTittle:@"会议"];
    
    self.appointmentTag = [[CZTagWithLabelView alloc]initWithImage:[UIImage imageNamed:@"appointmentIcon"] andTittle:@"约会"];
    
    self.businessTag = [[CZTagWithLabelView alloc]initWithImage:[UIImage imageNamed:@"businessIcon"] andTittle:@"出差"];
    
    self.sportTag = [[CZTagWithLabelView alloc]initWithImage:[UIImage imageNamed:@"sportIcon"] andTittle:@"运动"];
    self.shoppingTag = [[CZTagWithLabelView alloc]initWithImage:[UIImage imageNamed:@"shoppingIcon"] andTittle:@"购物"];
    
    self.entertainmentTag = [[CZTagWithLabelView alloc]initWithImage:[UIImage imageNamed:@"entertainmentIcon"] andTittle:@"娱乐"];
    
    self.partTag = [[CZTagWithLabelView alloc]initWithImage:[UIImage imageNamed:@"partIcon"] andTittle:@"聚会"];
    
    self.otherTag = [[CZTagWithLabelView alloc]initWithImage:[UIImage imageNamed:@"otherIcon"] andTittle:@"其他"];
    [self.view addSubview:self.upView];
    [self.view addSubview:self.downView];
    [self.upView addSubview:self.meetingTag];
    [self.upView addSubview:self.appointmentTag];
    [self.upView addSubview:self.businessTag];
    [self.upView addSubview:self.sportTag];
    [self.upView addSubview:self.shoppingTag];
    [self.upView addSubview:self.entertainmentTag];
    [self.upView addSubview:self.partTag];
    [self.upView addSubview:self.otherTag];
}

#pragma mark - 对upView的子控件进行赋值
- (void)setSubViewsOfUpView
{
    self.upView.tagImgView.image = [UIImage imageNamed:@"businessSmallIcon"];
    self.upView.themeNameLabel.text = @"出差";
    self.upView.img.image = [UIImage imageNamed:@"moreTagbuttonIcon"];
    //对upView的子控件themeView添加点击事件
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickMoreTag)];
    [self.upView.themeView addGestureRecognizer:gesture];
    [self addSubViewsConstraintOfUpView];   //添加约束
}
- (void)addSubViewsConstraintOfUpView
{
    //1.添加upView约束
    [self.upView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).offset(64 + 10);
        make.width.mas_equalTo(self.view.frame.size.width);
        make.height.mas_equalTo(VIEWH);
    }];
    //2.添加upView的子控件themeView约束
    [self.upView.themeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.upView.mas_left);
        make.top.equalTo(self.upView.mas_top);
        make.width.equalTo(self.upView.mas_width);
        make.height.mas_equalTo(VIEWH);
    }];
    //3.添加themeView的子控件themeLabel约束
    [self.upView.themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.upView.themeView.mas_centerY);
        make.left.equalTo(self.upView.themeView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    //4.添加themeView的子控件img约束
    [self.upView.img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.upView.themeView.mas_centerY);
        make.right.equalTo(self.upView.themeView.mas_right).offset(-10);
        make.size.mas_equalTo(self.upView.img.image.size);
    }];
    
    //5.添加themeView的子控件themeNameLabel约束
    CGSize themeNameSize = [self sizeWithText:self.upView.themeNameLabel.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:FONTSIZE];
    [self.upView.themeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.upView.themeView.mas_centerY);
        make.right.equalTo(self.upView.img.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(themeNameSize.width + 1, themeNameSize.height + 1));
    }];
    //6.添加themeView的子控件themeNameLabel约束
    [self.upView.tagImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.upView.themeView.mas_centerY);
        make.right.equalTo(self.upView.themeNameLabel.mas_left).offset(-10);
        make.size.mas_equalTo(self.upView.tagImgView.image.size);
    }];
    //分割线
    [self.upView.segLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.upView.themeView.mas_left).offset(10);
        make.top.equalTo(self.upView.themeView.mas_bottom).offset(-1);
        make.height.mas_equalTo(0.5);
        make.width.mas_equalTo(0);
    }];
}
#pragma mark - 对downView的子控件进行赋值
- (void)setSubViewsOfDownView
{
    //对整个downView布局
    CGFloat paddingToUpView = 20; //upView与downView之间的纵向间距
    CGFloat heightOfLimintedLabel = [self sizeWithText:self.downView.limitedLabel.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:FONTSIZE].height;
    CGFloat height = self.paddingAtDownViewH * 2 + self.textViewH + VIEWH * 2 + heightOfLimintedLabel + 20;
    [self.downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.upView.mas_bottom).offset(paddingToUpView);
        make.width.mas_equalTo(self.view.frame.size.width);
        make.height.mas_equalTo(height);
    }];
    //1.设置文本框
    [self addContextViewConstraint];
    //2.设置行程时间框
    [self setSubViewOfTimeView];
    //3.设置提醒时间框
    [self setSubViewOfRemindView];
}
#pragma mark - 对downView的子控件contextView布局
- (void)addContextViewConstraint
{
    
    CGSize sizeOfLimintedLabel = [self sizeWithText:self.downView.limitedLabel.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:FONTSIZE];
    [self.downView.contextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.downView.mas_top);
        make.left.equalTo(self.downView.mas_left);
        make.width.equalTo(self.downView.mas_width);
        make.height.mas_equalTo(self.textViewH + 10 + sizeOfLimintedLabel.height +10);
    }];
    
    [self setTextViewProperty:self.downView.textView];
    CGFloat padding = 10;
    [self.downView.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.downView.contextView.mas_top).offset(padding);
        make.left.equalTo(self.downView.contextView.mas_left).offset(padding);
        make.right.equalTo(self.downView.contextView.mas_right).offset(-padding);
        make.height.mas_equalTo(self.view.frame.size.width * 0.23);
    }];
    [self.downView.limitedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.downView.textView.mas_bottom).with.offset(5);
        make.right.equalTo(self.downView.contextView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(sizeOfLimintedLabel.width+1, sizeOfLimintedLabel.height+1));
    }];
}
//设置textView的属性
- (void)setTextViewProperty:(UITextView *)textView
{
    textView.backgroundColor = [UIColor whiteColor];
    textView.userInteractionEnabled = YES;
    textView.scrollEnabled = YES;    //当文字超过视图的边框时是否允许滑动，默认为“YES”
    textView.editable = YES;        //是否允许编辑内容，默认为“YES”
    textView.delegate = self;       //设置代理方法的实现类
    textView.font=[UIFont fontWithName:@"Arial" size:14.0]; //设置字体名字和字体大小;
    textView.returnKeyType = UIReturnKeyDone;//return键的类型
    textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    textView.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
    textView.textColor = [UIColor blackColor];
    textView.text = @"请输入行程地点+内容(40字以内)";//设置显示的文本内容
    textView.alpha = 0.5;
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)setSubViewOfTimeView
{
    self.downView.moreTimeImg.image = [UIImage imageNamed:@"moreTagbuttonIcon"];
    self.downView.timeInfoLabel.text = self.localTime;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickTimeView)];
    [self.downView.timeView addGestureRecognizer:gesture];
    //对行程时间框的子控件进行赋值
    [self addTimeViewConstraint];
    
}
- (void)addTimeViewConstraint
{
    [self.downView.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.downView.contextView.mas_bottom).offset(self.paddingAtDownViewH);
        make.left.equalTo(self.downView.mas_left);
        make.width.mas_equalTo(self.view.frame.size.width);
        make.height.mas_equalTo(VIEWH);
    }];
    //设置timeView内的子控件约束
    [self.downView.timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.downView.timeView.mas_left).offset(10);
        make.centerY.equalTo(self.downView.timeView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    [self.downView.moreTimeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.downView.timeView.mas_centerY);
        make.right.equalTo(self.downView.timeView.mas_right).offset(-10);
        make.size.mas_equalTo(self.downView.moreTimeImg.image.size);
    }];
    CGSize timeSize = [self sizeWithText:self.downView.timeInfoLabel.text maxSize:CGSizeMake(MAXFLOAT, 20) fontSize:14];
    //self.downView.timeInfoLabel.frame = CGRectMake(kScreenWidth - 180, VIEWH/2 - 7, 150, 17);
    //    [self.downView.timeInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(self.downView.timeView.mas_centerY);
    //        make.right.equalTo(self.downView.moreTimeImg.mas_left).offset(-10);
    //        //make.size.mas_equalTo(CGSizeMake(150, timeSize.height + 1));
    //        make.width.mas_equalTo(150);
    //        make.height.mas_equalTo(17);
    //    }];
    [self.downView.timeInfoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.downView.timeView.mas_centerY);
        make.right.equalTo(self.downView.moreTimeImg.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(timeSize.width+1, timeSize.height + 1));
        //        make.width.mas_equalTo(150);
        //        make.height.mas_equalTo(17);
    }];
}
- (void)setSubViewOfRemindView
{
    self.downView.remindTimeLabel.text = @"不提醒";
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickRemindView)];
    [self.downView.remindView addGestureRecognizer:gesture];
    [self addRemindViewConstraint];
}
- (void)addRemindViewConstraint
{
    [self.downView.remindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.downView.mas_left);
        make.top.equalTo(self.downView.timeView.mas_bottom).offset(10);
        make.width.mas_equalTo(self.view.frame.size.width);
        make.height.mas_equalTo(VIEWH);
    }];
    [self.downView.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.downView.remindView.mas_centerY);
        make.left.equalTo(self.downView.remindView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    [self.downView.moreRemindImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.downView.remindView.mas_centerY);
        make.right.equalTo(self.downView.remindView.mas_right).offset(-10);
        make.size.mas_equalTo(self.downView.moreRemindImg.image.size);
    }];
    CGSize remindTimeLableSize = [self sizeWithText:self.downView.remindTimeLabel.text maxSize:CGSizeMake(MAXFLOAT, 20) fontSize:14];
    [self.downView.remindTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.downView.remindView.mas_centerY);
        make.right.equalTo(self.downView.moreRemindImg.mas_left).offset(-10);
        make.size.mas_equalTo(CGSizeMake(remindTimeLableSize.width+1, remindTimeLableSize.height+1));
    }];
}
#pragma mark - timeView的点击事件
- (void)onClickTimeView
{
    //收起键盘
    [self.downView.textView resignFirstResponder];
    
    CZTimeSelectView *selectView = [CZTimeSelectView selectView];
    selectView.pickView.dataSource = self;
    selectView.pickView.delegate = self;
    [selectView.OKbtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
    
    LewPopupViewAnimationSlide *animation = [[LewPopupViewAnimationSlide alloc]init];
    animation.type = LewPopupViewAnimationSlideTypeBottomBottom;
    [self lew_presentPopupView:selectView animation:animation dismissed:^{
        NSLog(@"时间选择视图已弹出");
    }];
    
}
#pragma mark - 时间选择器确定
- (void)selectTime:(UIButton *)btn
{
    UIView *view = btn.superview;
    
    UIPickerView *pickView = [view viewWithTag:10];
    
    long int rowYear = [pickView selectedRowInComponent:0];
    NSString *year = self.years[rowYear];
    long int rowMonth = [pickView selectedRowInComponent:1];
    NSString *month = self.months[rowMonth];
    long int rowDay = [pickView selectedRowInComponent:2];
    NSString *day = self.days[rowDay];
    long int rowTime = [pickView selectedRowInComponent:3];
    NSString *time = self.times[rowTime];
    
    self.downView.timeInfoLabel.text = [NSString stringWithFormat:@"%@年%@月%@日 %@", year, month, day, time];
    CGSize timeInfoSize = [self sizeWithText:self.downView.timeInfoLabel.text maxSize:CGSizeMake(MAXFLOAT, 20) fontSize:14];
    [self.downView.timeInfoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(timeInfoSize.width+1, timeInfoSize.height+1));
    }];
    [self lew_dismissPopupView];
}

#pragma mark - 设置提醒时间点击事件
- (void)onClickRemindView
{
    //收起键盘
    [self.downView.textView resignFirstResponder];
    
    CZMoreRemindTimeViewController *moreRemindTimeViewController = [[CZMoreRemindTimeViewController alloc]init];
    moreRemindTimeViewController.title = @"提醒时间";
    self.settingRemindDelegate = moreRemindTimeViewController;
    [self.settingRemindDelegate passModifySchedule:self.model];
    [self.navigationController pushViewController:moreRemindTimeViewController animated:YES];
    
}
#pragma mark - TextView在的代理方法
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入行程地点+内容(40字以内)"])
    {
        textView.text = @"";
        textView.alpha = 1.0;
    }
    [self didHideMoreTag];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.text = @"请输入行程地点+内容(40字以内)";
        textView.alpha = 0.5;
    }
}

#pragma mark -  监听textView文本改变实现限制字数

- (void)textViewEditChanged:(NSNotification *)obj{
    
    UITextView *textView = self.downView.textView;
    
    NSString *toBeString = textView.text;
    NSString *lang = self.textInputMode.primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"])
    {
        UITextRange *selectedRange = [textView markedTextRange];
        if (!selectedRange)
        {
            if (toBeString.length > MAXLENGTH)
            {
                textView.text = [toBeString substringToIndex:MAXLENGTH];
            }
        }else
        {
            
        }
    }else
    {
        if (toBeString.length > MAXLENGTH)
        {
            textView.text = [toBeString substringToIndex:MAXLENGTH];
        }
    }
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGFloat heigth = [self heightForString:self.downView.textView andWidth:rect.size.width - 8];
    self.downView.textView.contentSize = CGSizeMake(0, heigth+8);
    NSRange range = NSMakeRange([self.downView.textView.text length]- 1, 1);
    [self.downView.textView scrollRangeToVisible:range];
}
/**
 * @method 获取指定宽度width的字符串在UITextView上的高度
 * @param textView 待计算的UITextView
 * @param Width 限制字符串显示区域的宽度
 * @result float 返回的高度
 */
- (CGFloat) heightForString:(UITextView *)textView andWidth:(float)width
{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
}
//收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.downView.textView resignFirstResponder];
}
//设置导航栏的左右按钮
- (void)setNavigationBarItem
{
    UIImage *image = [UIImage imageNamed:@"backIcon"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    UIBarButtonItem *rigthButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(commintModify)];
    [self.navigationItem setRightBarButtonItem:rigthButton];
    
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 上方upView的点击事件
- (void)onClickMoreTag
{
    //收起键盘
    [self.downView.textView resignFirstResponder];
    
    self.isShow = !self.isShow;
    if (self.isShow)
    {
        [self didShowMoreTag];
    }else
    {
        [self didHideMoreTag];
    }
}
#pragma mark - 显示下拉更多标签按钮
- (void)didShowMoreTag
{
    self.upView.img.image = [UIImage imageNamed:@"up_arrow"];
    [UIView animateWithDuration:0.5 animations:^{
        //1.增加themeView的高度
        [self.upView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(VIEWH + 150);
        }];
        //显示分割线
        [self.upView.segLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.view.frame.size.width - 20);
        }];
        [self didShowTag];
        //3.重新布局
        [self.view layoutIfNeeded];
    }];
    
}
- (void)didShowTag
{
    [self updateHeightToNormal:self.meetingTag];
    [self updateHeightToNormal:self.appointmentTag];
    [self updateHeightToNormal:self.businessTag];
    [self updateHeightToNormal:self.sportTag];
    [self updateHeightToNormal:self.shoppingTag];
    [self updateHeightToNormal:self.entertainmentTag];
    [self updateHeightToNormal:self.partTag];
    [self updateHeightToNormal:self.otherTag];
    
}
- (void)updateHeightToNormal:(CZTagWithLabelView *)view
{
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(view.tagButton.imageView.image.size.height + 22);
    }];
    [view.tagButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(view.tagButton.imageView.image.size.height);
    }];
    [view.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(17);
    }];
}
#pragma mark - 隐藏下拉更多标签按钮
- (void)didHideMoreTag
{
    self.upView.img.image = [UIImage imageNamed:@"moreTagbuttonIcon"];
    //1.减少themeView的高度
    [UIView animateWithDuration:0.5 animations:^{
        //1.减少themeView的高度
        [self.upView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(VIEWH);
        }];
        //隐藏分割线
        [self.upView.segLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
        //隐藏标签
        [self didHideTag];
        //3.重新布局
        [self.view layoutIfNeeded];
        
    }];
}
- (void)didHideTag
{
    [self updateHeightToZero:self.meetingTag];
    [self updateHeightToZero:self.appointmentTag];
    [self updateHeightToZero:self.businessTag];
    [self updateHeightToZero:self.sportTag];
    [self updateHeightToZero:self.shoppingTag];
    [self updateHeightToZero:self.entertainmentTag];
    [self updateHeightToZero:self.partTag];
    [self updateHeightToZero:self.otherTag];
}
- (void)updateHeightToZero:(CZTagWithLabelView *)view
{
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    [view.tagButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    [view.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
}
#pragma mark - 初始化弹出的标签面板
- (void)initMoreTagView
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGFloat topPadding = rect.size.width * 0.05 + VIEWH;
    CGFloat leftPadding = rect.size.width * 0.07;
    CGFloat bottomPadding = rect.size.width * 0.04;
    
    CGFloat paddingToMeeting = rect.size.width * 0.16;      //约会距离会议的右边距
    CGFloat paddingToAppointment = rect.size.width * 0.17;  //出差距离约会的右边距
    CGFloat paddingToBusiness = rect.size.width * 0.14;     //运动距离出差的右边距
    CGFloat paddingToShopping = rect.size.width * 0.15;     //娱乐距离购物的右边距
    CGFloat paddingToEntertainment = rect.size.width * 0.17;//聚会距离娱乐的右边距
    CGFloat paddingToPart = rect.size.width * 0.14;         //其他距离聚会的右边距
    
    [self.meetingTag.tagButton addTarget:self action:@selector(selectTheme:) forControlEvents:UIControlEventTouchUpInside];
    [self.meetingTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upView.themeView.mas_top).with.offset(topPadding);
        make.left.equalTo(self.upView).with.offset(leftPadding);
    }];
    
    [self.appointmentTag.tagButton addTarget:self action:@selector(selectTheme:) forControlEvents:UIControlEventTouchUpInside];
    [self.appointmentTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.meetingTag.mas_top);
        make.left.equalTo(self.meetingTag.mas_right).with.offset(paddingToMeeting);
    }];
    
    [self.businessTag.tagButton addTarget:self action:@selector(selectTheme:) forControlEvents:UIControlEventTouchUpInside];
    [self.businessTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.meetingTag.mas_top);
        make.left.equalTo(self.appointmentTag.mas_right).with.offset(paddingToAppointment);;
    }];
    
    [self.sportTag.tagButton addTarget:self action:@selector(selectTheme:) forControlEvents:UIControlEventTouchUpInside];
    [self.sportTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.meetingTag.mas_top);
        make.left.equalTo(self.businessTag.mas_right).with.offset(paddingToBusiness);
    }];
    
    [self.shoppingTag.tagButton addTarget:self action:@selector(selectTheme:) forControlEvents:UIControlEventTouchUpInside];
    [self.shoppingTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.meetingTag.mas_left);
        make.bottom.equalTo(self.upView.mas_bottom).with.offset(-bottomPadding);
    }];
    
    [self.entertainmentTag.tagButton addTarget:self action:@selector(selectTheme:) forControlEvents:UIControlEventTouchUpInside];
    [self.entertainmentTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.meetingTag.mas_right).with.offset(paddingToShopping);
        make.bottom.equalTo(self.shoppingTag.mas_bottom);
    }];
    
    [self.partTag.tagButton addTarget:self action:@selector(selectTheme:) forControlEvents:UIControlEventTouchUpInside];
    [self.partTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.entertainmentTag.mas_right).with.offset(paddingToEntertainment);
        make.bottom.equalTo(self.shoppingTag.mas_bottom);
    }];
    
    [self.otherTag.tagButton addTarget:self action:@selector(selectTheme:) forControlEvents:UIControlEventTouchUpInside];
    [self.otherTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.partTag.mas_right).with.offset(paddingToPart);
        make.bottom.equalTo(self.shoppingTag.mas_bottom);
    }];
    
}

//选择行程主题
- (void)selectTheme:(UIButton *)btn
{
    UIView *view = btn.superview;
    
    UILabel *label = [view viewWithTag:10]; //10表示主题标签在其父视图中的Tag
    //UIButton *button = [view viewWithTag:9];//9表示主题按钮在其父视图中的Tag
    
    self.upView.themeNameLabel.text = label.text;
    
    if ([label.text isEqualToString:@"运动"])
    {
        self.upView.tagImgView.image = [UIImage imageNamed:@"sportSmallIcon"];
    }else if ([label.text isEqualToString:@"约会"])
    {
        self.upView.tagImgView.image  = [UIImage imageNamed:@"appointmentSmallIcon"];
    }else if ([label.text isEqualToString:@"出差"])
    {
        self.upView.tagImgView.image  = [UIImage imageNamed:@"businessSmallIcon"];
    }else if ([label.text isEqualToString:@"会议"])
    {
        self.upView.tagImgView.image  = [UIImage imageNamed:@"meetingSmallIcon"];
    }else if ([label.text isEqualToString:@"购物"])
    {
        self.upView.tagImgView.image  = [UIImage imageNamed:@"shoppingSmallIcon"];
    }else if ([label.text isEqualToString:@"娱乐"])
    {
        self.upView.tagImgView.image  = [UIImage imageNamed:@"entertainmentSmallIcon"];
    }else if ([label.text isEqualToString:@"聚会"])
    {
        self.upView.tagImgView.image  = [UIImage imageNamed:@"partSmallIcon"];
    }else
    {
        self.upView.tagImgView.image  = [UIImage imageNamed:@"otherSmallIcon"];
    }
    [self.upView.tagImgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.upView.tagImgView.image.size);
    }];
    //    [self.view layoutIfNeeded];
}
- (UIImage *)getThemeImage:(NSString *)theme
{
    if ([theme isEqualToString:@"运动"])
    {
        return [UIImage imageNamed:@"sportSmallIcon"];
    }else if ([theme isEqualToString:@"约会"])
    {
        return [UIImage imageNamed:@"appointmentSmallIcon"];
    }else if ([theme isEqualToString:@"出差"])
    {
        return [UIImage imageNamed:@"businessSmallIcon"];
    }else if ([theme isEqualToString:@"会议"])
    {
        return [UIImage imageNamed:@"meetingSmallIcon"];
    }else if ([theme isEqualToString:@"购物"])
    {
        return [UIImage imageNamed:@"shoppingSmallIcon"];
    }else if ([theme isEqualToString:@"娱乐"])
    {
        return [UIImage imageNamed:@"entertainmentSmallIcon"];
    }else if ([theme isEqualToString:@"聚会"])
    {
        return [UIImage imageNamed:@"partSmallIcon"];
    }else
    {
        return [UIImage imageNamed:@"otherSmallIcon"];
    }
    
}

#pragma mark - PickView代理

// UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 4;  // 返回2表明该控件只包含2列
}
// UIPickerViewDataSource中定义的方法，该方法的返回值决定该控件指定列包含多少个列表项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.years.count;
    }else if (component == 1)
    {
        return self.months.count;
    }else if (component == 2)
    {
        return self.days.count;
        
    }else
    {
        return self.times.count;
    }
    
}
// UIPickerViewDelegate中定义的方法，该方法返回的NSString将作为
// UIPickerView中指定列和列表项上显示的标题
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.years[row];
    }else if (component == 1)
    {
        return self.months[row];
    }else if (component == 2)
    {
        return self.days[row];
        
    }else
    {
        return self.times[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    self.days = [self isLeapyear:pickerView WithRow:row inComponent:component];
    
    [pickerView reloadAllComponents];
}

- (NSMutableArray *)isLeapyear:(UIPickerView *)pickerView WithRow:(NSInteger)row inComponent:(NSInteger)component
{NSMutableArray *days = [[NSMutableArray alloc]init];
    long int month = [pickerView selectedRowInComponent:1];
    NSString *currentMonth = self.months[month];
    long int currentYear = [pickerView selectedRowInComponent:0];
    int year = [self.years[currentYear] intValue];
    NSString *temp;
    
    if ((component == 0 || component == 1 || component == 2) && [currentMonth isEqualToString:@"02"])
    {
        if ((year % 4 == 0 && year % 100 != 0 ) || year % 400 == 0 )
        {//闰年
            
            for (int i = 0; i < 29; i++)
            {
                if (i < 9)
                {
                    temp = [NSString stringWithFormat:@"0%d", i+1];
                    [days addObject:temp];
                }else
                {
                    temp = [NSString stringWithFormat:@"%d",i+1];
                    [days addObject:temp];
                }
            }
        }
        else
        {//平年
            
            for (int i = 0; i < 28; i++)
            {
                if (i < 9)
                {
                    temp = [NSString stringWithFormat:@"0%d", i+1];
                    [days addObject:temp];
                }else
                {
                    temp = [NSString stringWithFormat:@"%d",i+1];
                    [days addObject:temp];
                }
            }
        }
    }else if ((component == 0 || component == 1 || component == 2) &&
              ([currentMonth isEqualToString:@"01"] ||
               [currentMonth isEqualToString:@"03"] ||
               [currentMonth isEqualToString:@"05"] ||
               [currentMonth isEqualToString:@"07"] ||
               [currentMonth isEqualToString:@"08"] ||
               [currentMonth isEqualToString:@"10"] ||
               [currentMonth isEqualToString:@"12"]))
    {
        for (int i = 0; i < 31; ++i)
        {
            if (i < 9)
            {
                temp = [NSString stringWithFormat:@"0%d", i+1];
                [days addObject:temp];
            }else
            {
                temp = [NSString stringWithFormat:@"%d",i+1];
                [days addObject:temp];
            }
            
        }
    }else
    {
        
        for (int i = 0; i < 30; i++)
        {
            if (i < 9)
            {
                temp = [NSString stringWithFormat:@"0%d", i+1];
                [days addObject:temp];
            }else
            {
                temp = [NSString stringWithFormat:@"%d",i+1];
                [days addObject:temp];
            }
        }
        
    }
    
    self.days = days;
    return self.days;}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    return rect.size.width *0.21;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    return rect.size.width * 0.08;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc]init];
    label.alpha = 0.8;
    label.tag = 10;
    CGSize size;
    if (component == 0)
    {
        label.text = self.years[row];
        size = [self setLabelStyle:label WithContent:self.years[row]];
    }else if (component == 1)
    {
        label.text = self.months[row];
        size = [self setLabelStyle:label WithContent:self.months[row]];
    }else if (component == 2)
    {
        label.text = self.days[row];
        size = [self setLabelStyle:label WithContent:self.days[row]];
        
    }else
    {
        label.text = self.times[row];
        size = [self setLabelStyle:label WithContent:self.times[row]];
    }
    
    UIView *vc = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    view = vc;
    [view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(size.width+1, size.height+1));
    }];
    
    return view;
}
//设置标签的样式
- (CGSize)setLabelStyle:(UILabel *)label WithContent:(NSString *)content
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    label.font = [UIFont systemFontOfSize:FONTSIZE];
    label.numberOfLines = 0;
    label.text = content;
    CGSize size = [self sizeWithText:content maxSize:CGSizeMake(rect.size.width * 0.55, MAXFLOAT) fontSize:FONTSIZE];
    
    return size;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
