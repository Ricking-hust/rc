//
//  CZActivityInfoViewController.m
//  rc
//
//  Created by AlanZhang on 16/1/15.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZActivityInfoViewController.h"
#import "ActivityIntroduction.h"
#import "ActivityModel.h"
#import "Masonry.h"
#import "CZTimeCell.h"
#import "CZActivityInfoCell.h"
#import "CZActivityDetailCell.h"
#import "CZRemindMeView.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationSlide.h"
#import "DataManager.h"
#import "ActivityModel.h"
#import "UIImageView+WebCache.h"
#import "UINavigationBar+Awesome.h"
#import "UIImageView+LBBlurredImage.h"
#import "EXTScope.h"


@interface CZActivityInfoViewController ()

@property(nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImageView *acImageView;
@property (nonatomic ,strong) UIImageView *acTagImageView;
@property (nonatomic, strong) UILabel *acTittleLabel;
@property (nonatomic, strong) UILabel *acTagLabel;

@property(nonatomic,strong) UIButton *collectionBtn;
@property(nonatomic,strong) UIButton *addToSchedule;

@property (nonatomic,strong)  ActivityModel *activitymodel;
@property (nonatomic, copy) NSURLSessionDataTask* (^getActivityBlock)();

@end

@implementation CZActivityInfoViewController

- (void)configureBlocks{
    @weakify(self);
    self.getActivityBlock = ^(){
        @strongify(self);
        
        return [[DataManager manager] getActivityContentWithAcId:self.activityModelPre.acID userId:@"1" success:^(ActivityModel *activity) {
            @strongify(self);
            self.activitymodel = activity;
        } failure:^(NSError *error) {
            NSLog(@"Error:%@",error);
        }];
    };
}

-(void) setActivitymodel:(ActivityModel *)activitymodel{
    
    _activitymodel = activitymodel;
    
    [self.tableView reloadData];
}

-(void)startgetAc{
    if (self.getActivityBlock) {
        self.getActivityBlock();
    }
}

//创建子控件
- (void)createSubViews
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.collectionBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    self.addToSchedule = [UIButton buttonWithType:UIButtonTypeCustom];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tableView];
    [self.bottomView addSubview:self.collectionBtn];
    [self.bottomView addSubview:self.addToSchedule];
    
    [self.collectionBtn addTarget:self action:@selector(onClickCollection) forControlEvents:UIControlEventTouchUpInside];
    [self.addToSchedule addTarget:self action:@selector(onClickAdd) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.addToSchedule setTitle:@"加入日程" forState:UIControlStateNormal];
    [self.addToSchedule setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:130.0/255.0  blue:5.0/255.0  alpha:1.0]];
    
    [self.collectionBtn setImage:[UIImage imageNamed:@"collectionNormal"] forState:UIControlStateNormal];
    [self.collectionBtn setImage:[UIImage imageNamed:@"collectionSelected"] forState:UIControlStateHighlighted];
    [self.collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [self.collectionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    CGSize size = [[UIScreen mainScreen]bounds].size;
    //add tableView constraints
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];
    
    //add bottomView constraints
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.tableView.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(size.width, 50));
    }];
    
    //add collectionBtn constraints
    [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(size.width * 0.33);
        make.height.mas_equalTo(50);
        make.size.mas_equalTo(CGSizeMake(size.width * 0.33, 50));
    }];
    
    //add addToSchedule constriants
    [self.addToSchedule mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.collectionBtn.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(50);
    }];
        
}

- (void)onClickCollection
{
//    NSLog(@"collection");
}

- (void)onClickAdd
{
//     NSLog(@"addToSchedule");
}

//界面加载完毕
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBlocks];
    [self createSubViews];
    
    //设置导航栏
    [self setNavigation];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    
    //设置tableView头
    [self layoutHeaderImageView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    @weakify(self);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @strongify(self);
        
        [self startgetAc];
        
    });
}
- (void)setNavigation
{
    //设置导航标题栏
    UILabel *titleLabel     = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font         = [UIFont systemFontOfSize:18];
    titleLabel.textColor    = [UIColor  whiteColor];
    titleLabel.textAlignment= NSTextAlignmentCenter;
    titleLabel.text = @"活动介绍";
    self.navigationItem.titleView = titleLabel;
    
    
    [self configureBlocks];
    [self createSubViews];
    
    
    //设置导航栏的左侧按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    leftButton.tintColor = [UIColor whiteColor];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
}

//左侧按钮的点击事件
- (void) backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            CZTimeCell *cell = [CZTimeCell timeCellWithTableView:tableView];
            [cell.remindMeBtn addTarget:self action:@selector(onClickRemindMe:) forControlEvents:UIControlEventTouchUpInside];
            //对cell的控件进行赋值
            [self setCellValue:cell AtIndexPath:indexPath];
            //对cell的控件进行布局
            [cell setSubViewsConstraint];

            return cell;
        }
            break;
        case 1:
        {
            CZActivityInfoCell *cell = [CZActivityInfoCell activityCellWithTableView:tableView];
            //对cell的控件进行赋值
            [self setCellValue:cell AtIndexPath:indexPath];
            //对cell的控件进行布局
            [cell setSubViewsConstraint];
            
            return cell;
        }
            break;
        default:
        {
            CZActivityDetailCell *cell = [CZActivityDetailCell detailCellWithTableView:tableView];

            return cell;
        }
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CZTimeCell *cell = (CZTimeCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.rowHeight;
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 60.0/2;//section头部高度
}
//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    UIColor *textcolor = [UIColor colorWithRed:131.0/255.0 green:131.0/255.0  blue:131.0/255.0  alpha:1.0];
    if (section == 0)
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen]bounds].size.width, 1)];
    }else if(section == 1)
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen]bounds].size.width, 60.0/2)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 30)];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"活动详情";
        label.textColor = textcolor;
        [view addSubview:label];
    }else
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen]bounds].size.width, 60.0/2)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 30)];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"活动介绍";
        label.textColor = textcolor;
        [view addSubview:label];
    }
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    return view;

}
//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
//section底部视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen]bounds].size.width, 1)];
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    return view;
}
// 配置tableView header UI布局
- (void)layoutHeaderImageView
{
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    self.header = [[UIView alloc]init];
    [self.header setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height * 0.25 + 64)];
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height * 0.25 + 64)];
    self.headerImageView.alpha = 0.7;
    //self.headerImageView.image  = [UIImage imageNamed:@"img_1"]; //headerView的背景模糊图片
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.activityModelPre.acPoster] placeholderImage:[UIImage imageNamed:@"20160102.png"]];
    
    [self.header addSubview:self.headerImageView];
    [self.headerImageView setImageToBlur:self.headerImageView.image blurRadius:21 completionBlock:nil];
    //headerView中的子控件
    self.acImageView    = [[UIImageView alloc]init];
    self.acTagImageView = [[UIImageView alloc]init];
    self.acTittleLabel  = [[UILabel alloc]init];
    self.acTagLabel     = [[UILabel alloc]init];
    
    [self.header addSubview:self.acImageView];
    [self.header addSubview:self.acTagImageView];
    [self.header addSubview:self.acTittleLabel];
    [self.header addSubview:self.acTagLabel];
    
    //对tableView头进行赋值
    [self setTableViewHeader];
    //对tableView头进行布局
    [self setSubViewsConstraint];
    
    self.tableView.tableHeaderView = self.header;
    
}
// 下拉后图片拉伸的效果方法下载这个里面
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat width = self.view.frame.size.width;     // 图片宽度
    CGFloat yOffset = scrollView.contentOffset.y;  // 偏移的y值
    if (yOffset < 0)
    {
        CGFloat totalOffset = 200 + ABS(yOffset);
        CGFloat f = totalOffset / 200;
        self.headerImageView.frame =  CGRectMake(- (width * f - width) / 2, yOffset, width * f, totalOffset);
    }
}

//对tableView头进行赋值
- (void)setTableViewHeader
{
    
    self.acTittleLabel.font          = [UIFont systemFontOfSize:15];
    self.acTittleLabel.numberOfLines = 0;
    self.acTittleLabel.textColor     = [UIColor whiteColor];
    self.acTagLabel.font             = [UIFont systemFontOfSize:12];
    self.acTagLabel.textColor        = self.acTittleLabel.textColor;
    
    self.acImageView.image    = [UIImage imageNamed:@"img_1"];
    self.acTittleLabel.text   = self.activityModelPre.acTitle;
    NSLog(@"acTitle:%@",self.activityModelPre.acTitle);
    self.acTagImageView.image = [UIImage imageNamed:@"tagImage"];
    self.acTagLabel.text      = @"录像机 电影";
    
}
- (void)setSubViewsConstraint
{
    [self.acImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.header).with.offset(64);
        make.left.equalTo(self.header).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(120, 120));
    }];
    CGSize screenSize = [[UIScreen mainScreen]bounds].size;
    CGSize maxSize = CGSizeMake(screenSize.width * 0.5, MAXFLOAT);
    CGSize tittleSize = [self sizeWithText:self.acTittleLabel.text maxSize:maxSize fontSize:15];
    [self.acTittleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.acImageView.mas_top).with.offset(15);
        make.left.equalTo(self.acImageView.mas_right).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(tittleSize.width + 1, tittleSize.height + 1));
    }];
    [self.acTagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.acImageView.mas_right).with.offset(25);
        make.bottom.equalTo(self.acImageView.mas_bottom).with.offset(-10);
        make.size.mas_equalTo(self.acTagImageView.image.size);
    }];
    [self.acTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.acTagImageView.mas_right).with.offset(10);
        make.top.equalTo(self.acTagImageView.mas_top);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
}

//cell的控件进行赋值
- (void) setCellValue:(UITableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[CZTimeCell class]])
    {
        ((CZTimeCell*)cell).timeLabel.text = self.activityModelPre.acTime;
    }else if ([cell isKindOfClass:[CZActivityInfoCell class]])
    {
        ((CZActivityInfoCell *)cell).model = self.activitymodel;
    }
}
//弹出提醒视图
- (void)onClickRemindMe:(UIButton *)btn
{
    CZRemindMeView *remindMeView = [CZRemindMeView remindMeView];
    remindMeView.remindBeforeOneDay.selected = YES;
    
    [remindMeView.remindBeforeOneDay addTarget:self action:@selector(onClickTimeRemind:) forControlEvents:UIControlEventTouchUpInside];
    
    [remindMeView.remindBeforeTwoDay addTarget:self action:@selector(onClickTimeRemind:) forControlEvents:UIControlEventTouchUpInside];
    [remindMeView.remindBeforeThreeDay addTarget:self action:@selector(onClickTimeRemind:) forControlEvents:UIControlEventTouchUpInside];
    [remindMeView.OKbtn addTarget:self action:@selector(onClickOK:) forControlEvents:UIControlEventTouchUpInside];
    remindMeView.parentVC = self;
    [remindMeView setSubView];
    
    LewPopupViewAnimationSlide *animation = [[LewPopupViewAnimationSlide alloc]init];
    animation.type = LewPopupViewAnimationSlideTypeBottomBottom;
    [self lew_presentPopupView:remindMeView animation:animation dismissed:^{
        NSLog(@"提醒视图已弹出");
    }];

}
/**
 *  设置提醒时间,获取按钮父视图
 *  按钮对应的tag依次为
 *  提前一天----->11
 *  提前二天----->12
 *  提前三天----->13
 *  确定-------->14
 */
- (void)onClickTimeRemind:(UIButton *)btn
{
    UIView *superView = btn.superview;
    NSMutableArray *btnArray = [[NSMutableArray alloc]init];
    [btnArray addObject:[superView viewWithTag:11]];
    [btnArray addObject:[superView viewWithTag:12]];
    [btnArray addObject:[superView viewWithTag:13]];
    
    [self isSelected:btnArray WithButton:btn];
#pragma mark - 测试语句
    NSLog(@"%@",btn.titleLabel.text);
#pragma mark - 结束
    
}

- (UIButton *)isSelected:(NSMutableArray *)btnArray WithButton:(UIButton *)btn
{
    for (int i = 0; i <btnArray.count; i++)
    {
        UIButton *btnTemp = (UIButton *)btnArray[i];
        btnTemp.selected = NO;
    }
    btn.selected = YES;
    return btn;
}

//确定提醒时间按钮点击事件
- (void)onClickOK:(UIButton *)btn
{
    UIView *superView = btn.superview;
    NSMutableArray *btnArray = [[NSMutableArray alloc]init];
    [btnArray addObject:[superView viewWithTag:11]];
    [btnArray addObject:[superView viewWithTag:12]];
    [btnArray addObject:[superView viewWithTag:13]];
    
    UIButton *selectedBtn = [self whichButtonSelected:btnArray];
#pragma mark - 测试语句
    NSLog(@"选中了%@按钮",selectedBtn.titleLabel.text);
#pragma mark - 结束
    
    [self lew_dismissPopupView];
}

//判断哪个按钮选中
- (UIButton *)whichButtonSelected:(NSMutableArray *)btnArray
{
    UIButton *selectedBtn ;
    for (int i = 0; i <btnArray.count; i++)
    {
        selectedBtn = (UIButton *)btnArray[i];
        if (selectedBtn.selected)
        {
            break;
        }
    }
    return selectedBtn;
}
/**
 *  计算字符串的长度
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
