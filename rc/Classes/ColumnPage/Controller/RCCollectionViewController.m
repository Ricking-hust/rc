//
//  RCCollectionViewController.m
//  rc
//
//  Created by AlanZhang on 16/3/31.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCCollectionViewController.h"
#import "RCCollectionView.h"
#import "Masonry.h"
#include <sys/sysctl.h>
#import "CZButtonView.h"
#import "IndustryModel.h"
#import "ActivityModel.h"
#import "DataManager.h"
#import "UINavigationBar+Awesome.h"
#import "CZActivityInfoViewController.h"
#import "RCCollectionViewLayout.h"
#import "RCCollectionCell.h"
#import "RCColumnScrollViewDelegate.h"
//MJReflesh--------------------------------
#import "MJRefresh.h"
#import "RCHomeRefreshHeader.h"
#define NAME_FONTSIZE 14
#define TIME_FONTSIZE 12
#define PLACE_FONTSIZE 12
#define TAG_FONTSIZE  11

@interface RCCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, CustomCollectionViewLayoutDelegate>

@property (nonatomic, strong) UIScrollView *toolScrollView;
@property (nonatomic, strong) NSMutableArray *toolButtonArray;
@property (nonatomic, strong) IndustryList *indList;
@property (nonatomic, strong) ActivityList *activityList;
@property (nonatomic, strong) NSMutableDictionary *collectionViewByInd;
@property (nonatomic, strong) NSMutableDictionary *activityListByInd;
@property (nonatomic, strong) RCColumnScrollViewDelegate *scrollViewDelegate;

@property (nonatomic, copy) NSURLSessionDataTask *(^getIndListBlock)();
@property (nonatomic, copy) NSURLSessionDataTask *(^getActivityListWithIndBlock)(IndustryModel *model);@end

@implementation RCCollectionViewController

static NSString * const reuseIdentifier = @"RCColumnCell";
- (RCColumnScrollViewDelegate *)scrollViewDelegate
{
    if (!_scrollViewDelegate)
    {
        _scrollViewDelegate = [[RCColumnScrollViewDelegate alloc]init];
    }
    return _scrollViewDelegate;
}
- (NSMutableDictionary *)activityListByInd
{
    if (!_activityListByInd)
    {
        _activityListByInd = [[NSMutableDictionary alloc]init];
    }
    return _activityListByInd;
}
- (NSMutableDictionary *)collectionViewByInd
{
    if (!_collectionViewByInd)
    {
        _collectionViewByInd = [[NSMutableDictionary alloc]init];
    }
    return _collectionViewByInd;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    [self initScrollView];
    [self configureBlocks];
    self.getIndListBlock();
    // Do any additional setup after loading the view.
}
#pragma mark - 初始化，scrollView用于平移多个collectionView
- (void)initScrollView
{
    self.scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:self.scrollView];

    //设置分布滚动，去掉水平和垂直滚动条
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self.scrollViewDelegate;
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolScrollView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.width.mas_equalTo(kScreenWidth);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark <UICollectionViewDataSource>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    RCCollectionView *cv = (RCCollectionView *)collectionView;
    ActivityList *activityList = [self.activityListByInd valueForKey:cv.indName];

    return activityList.list.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    RCCollectionCell *cell = (RCCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[RCCollectionCell alloc]init];
        // Well, nothingreally. Never again
        
    }
    
    [self collectionView:collectionView setCellValue:cell AtIndexPath:indexPath];
    [cell setSubviewConstraint];
    return cell;

}
- (void)collectionView:(UICollectionView *)collectionView setCellValue:(RCCollectionCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{

    RCCollectionView *cv = (RCCollectionView *)collectionView;
    ActivityList *activityList = [self.activityListByInd valueForKey:cv.indName];
    
    ActivityModel *model = activityList.list[indexPath.row];
    [cell.acImage sd_setImageWithURL:[NSURL URLWithString:model.acPoster] placeholderImage:[UIImage imageNamed:@"20160102.png"]];
    cell.acName.text = model.acTitle;
    int len = (int)[model.acTime length];
    NSString *timeStr = [model.acTime substringWithRange:NSMakeRange(0, len - 3)];
    cell.acTime.text = timeStr;
    cell.acPlace.text = model.acPlace;
    
    cell.acRelease.text = model.userInfo.userName;
}
#pragma mark - UICollectionViewDelegateFlowLayout
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RCCollectionView *cv = (RCCollectionView *)collectionView;
    ActivityList *activityList = [self.activityListByInd valueForKey:cv.indName];
    
    CZActivityInfoViewController *info = [[CZActivityInfoViewController alloc]init];
    info.title = @"活动介绍";
    info.activityModelPre = activityList.list[indexPath.row];

    [self.navigationController pushViewController:info animated:YES];
}
#pragma mark - 返回指定数据的大小
- (CGSize)sizeByActivityModel:(ActivityModel *)model ForSepcifiedCell:(NSIndexPath *)indexPath
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
    CGFloat heigth = acImageH + 10 + acNameSize.height + 10 + acTimeSize.height + acPlaceSize.height + 10 + acTagSize.height+10;
    return CGSizeMake(100, heigth);
}
//#pragma mark - CustomCollectionViewLayoutDelegate
- (CGFloat)collectionView:(RCCollectionView *)collectionView waterFlowLayout:(RCCollectionViewLayout *)waterFlowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    //取出数据
    RCCollectionView *cv = (RCCollectionView *)collectionView;
    ActivityList *activityList = [self.activityListByInd valueForKey:cv.indName];
     return [self sizeByActivityModel:activityList.list[indexPath.row] ForSepcifiedCell:indexPath].height;
}
#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

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
            //按行业加载数据
            [self loadData:acList ByIndustry:model];
        } failure:^(NSError *error) {
            NSLog(@"Error:%@",error);
        }];
    };
}
- (void)loadData:(ActivityList *)activityList ByIndustry:(IndustryModel *)model
{
    long int index = [self.indList.list indexOfObject:model];
    RCCollectionView *collectionView = [self createCollectionView:(int)index WithIndName:model.indName];
    [self.collectionViewByInd setObject:collectionView forKey:model.indName];
    [self.activityListByInd setObject:activityList forKey:model.indName];
}
-(void)setIndList:(IndustryList *)indList
{
    _indList = indList;
    //创建工具条按钮
    if (_indList)
    {
        [self showToolButtons];
        self.scrollView.contentSize = CGSizeMake(_indList.list.count * kScreenWidth, 0);
    }
}
#pragma mark - 根据行业在indlist中的下标生成对应的collectionView
- (RCCollectionView *)createCollectionView:(int)index WithIndName:(NSString *)indName
{
    RCCollectionViewLayout *layout= [[RCCollectionViewLayout alloc]init];
    layout.layoutDelegate = self;
    RCCollectionView * collectionView = [[RCCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.indName = indName;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.scrollView addSubview:collectionView];
    [collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top).offset(-64);//64用于消除collectionView在ScrollView的位置影响
        make.left.equalTo(self.scrollView.mas_left).offset(index *kScreenWidth);
        make.width.mas_equalTo(kScreenWidth);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
    }];
    collectionView.mj_header = [RCHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    collectionView.mj_footer= [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    // Register cell classes
    [collectionView registerClass:[RCCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    return collectionView;
}
#pragma mark - 下拉对应的collectionView刷新数据
- (void)loadNewData
{
    //获取当前的collectionView
    RCCollectionView *collectionView = [self getCurrentCollectionView];
    [collectionView.mj_header endRefreshing];
}
#pragma mark - 上拉对应的collectionView刷新数据
-(void)getMoreData
{
    //获取当前的collectionView
    RCCollectionView *collectionView = [self getCurrentCollectionView];
    [collectionView.mj_footer endRefreshing];
}
- (RCCollectionView *)getCurrentCollectionView
{
    NSString *indName = [[NSString alloc]init];
    for (int i = 0; i < self.toolButtonArray.count; i++)
    {
        UIButton *button = self.toolButtonArray[i];
        if (button.selected)
        {
            indName = button.titleLabel.text;
            break;
        }
    }
    return [self.collectionViewByInd valueForKey:indName];
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
#pragma mark - 按钮点击事件的处理代码
- (void)onClickTooBtn:(UIButton *)btn
{
    
    [self isToolButtonSelected:btn];
    //此处按钮点击事件的处理代码添加---------------
    NSString *tagName = btn.titleLabel.text;
    int index = 0;
    for (int i = 0; i<self.toolButtonArray.count; i++)
    {
        UIButton *button = self.toolButtonArray[i];
        if ([button.titleLabel.text isEqualToString:tagName])
        {
            index = i;
            break;
        }
    }
    [self.scrollView setContentOffsetX:index * kScreenWidth];
}

#pragma mark -创建工具条按钮
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
#pragma mark - 赋值scrollViewDelegate滚动按键数组
    self.scrollViewDelegate.toolButtonArray = self.toolButtonArray;
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
