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
#import "BWaterflowLayout.h"
#import "RCAblumCollectionCell.h"
#import "RCNetworkingRequestOperationManager.h"
#import "RCAblumModel.h"
//MJReflesh--------------------------------
#import "MJRefresh.h"
#import "RCHomeRefreshHeader.h"
#define NAME_FONTSIZE  14
#define TIME_FONTSIZE  12
#define PLACE_FONTSIZE 12
#define TAG_FONTSIZE   11

@interface RCCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, CustomCollectionViewLayoutDelegate,BWaterflowLayoutDelegate>

@property (nonatomic, assign) CurrentDevice device;
@property (nonatomic, strong) UIScrollView *toolScrollView;
@property (nonatomic, strong) NSMutableArray *toolButtonArray;
@property (nonatomic, strong) IndustryList *indList;
@property (nonatomic, strong) ActivityList *acListRecived;
@property (nonatomic, strong) NSMutableDictionary *collectionViewByInd;
@property (nonatomic, strong) NSMutableDictionary *activityListByInd;
@property (nonatomic, strong) RCColumnScrollViewDelegate *scrollViewDelegate;

@property (nonatomic, copy) NSURLSessionDataTask *(^getIndListBlock)();
@property (nonatomic, copy) NSURLSessionDataTask *(^getActivityListWithIndBlock)(IndustryModel *model);
@property (nonatomic,copy) NSURLSessionDataTask *(^refreshAcListWithIndBlock)(IndustryModel *model,NSString *minAcId);
@property (nonatomic, strong) UIView *line; //工具栏下的线
@end

@implementation RCCollectionViewController

static NSString * const reuseIdentifier = @"RCColumnCell";
static NSString * const albumReuseIdentifier =@"albumCell";
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];

    [self initScrollView];
    [self configureBlocks];
    self.getIndListBlock();
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
        make.top.equalTo(self.toolScrollView.mas_bottom).offset(0);
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

#pragma mark - <UICollectionViewDataSource>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    RCCollectionView *cv = (RCCollectionView *)collectionView;
    if ([cv.indModel.indName isEqualToString:@"精选"])
    {
        NSArray *ablumArr = [self.activityListByInd valueForKey:@"精选"];
        return ablumArr.count;
    }else
    {
        NSMutableArray *activityList = [self.activityListByInd valueForKey:cv.indModel.indName];
        
        return activityList.count;
    }

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RCCollectionView *cv = (RCCollectionView *)collectionView;
    if ([cv.indModel.indName isEqualToString:@"精选"])
    {
        RCAblumCollectionCell *cell = (RCAblumCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:albumReuseIdentifier forIndexPath:indexPath];
//        [cell setPicture:[UIImage imageNamed:@"img_1"]];
//        [cell setTittle:@"六月的雨六月的雨六月的雨六月的雨六月的雨六月的雨六月的雨六月的雨六月的雨"];
        [cell setResponder:self.view];
        NSArray *ablumArr = [self.activityListByInd valueForKey:@"精选"];
        if (ablumArr.count != 0 && ablumArr != nil)
        {
            RCAblumModel *model = ablumArr[indexPath.row];
            [cell setModel:model];
        }
        
        return cell;
    }else
    {
        RCCollectionCell *cell = (RCCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        //[self collectionView:collectionView setCellValue:cell AtIndexPath:indexPath];
        NSMutableArray *activityList = [self.activityListByInd valueForKey:cv.indModel.indName];
        ActivityModel *model = activityList[indexPath.row];
        cell.model = model;
        
        [cell setSubviewConstraint];
        
        return cell;
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView setCellValue:(RCCollectionCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{

    RCCollectionView *cv = (RCCollectionView *)collectionView;
    NSMutableArray *activityList = [self.activityListByInd valueForKey:cv.indModel.indName];
    
    ActivityModel *model = activityList[indexPath.row];
    cell.acName.text = model.acTitle;
    int len = (int)[model.acTime length];
    NSString *timeStr = [model.acTime substringWithRange:NSMakeRange(0, len - 3)];
    cell.acTime.text = timeStr;
    cell.acPlace.text = model.acPlace;
    
    [cell.acImage sd_setImageWithURL:[NSURL URLWithString:model.acPoster] placeholderImage:[UIImage imageNamed:@"20160102.png"]];
    //[cell.acTagImgeView sd_setImageWithURL:[NSURL URLWithString:model.userInfo.userPic] placeholderImage:[UIImage imageNamed:@"20160102.png"]];
    //cell.acRelease.text = model.userInfo.userName;
    [cell.acTagImgeView setImage:[UIImage imageNamed:@"tagImage"]];
    NSMutableArray *Artags = [[NSMutableArray alloc]init];
    
    for (TagModel *tagmodel in model.tagsList.list) {
        [Artags addObject:tagmodel.tagName];
    }
    
    NSString *tags = [Artags componentsJoinedByString:@","];
    cell.acRelease.text = tags;
    //判断当前活动是否过期
    BOOL isHappened = [self isHappened:model];
    if (isHappened == YES)
    {
        cell.acName.textColor = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
        cell.acTime.textColor  = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
        cell.acPlace.textColor = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
        cell.acRelease.textColor  = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
        cell.acImage.alpha  = 0.6;
    }else
    {
        cell.acName.textColor = [UIColor blackColor];
        cell.acTime.textColor  = [UIColor blackColor];
        cell.acPlace.textColor = [UIColor blackColor];
        cell.acRelease.textColor  = [UIColor blackColor];
        cell.acImage.alpha  = 1.0;
    }

    
}

#pragma mark - 判断指定的行程是否已经发生
- (BOOL)isHappened:(ActivityModel *)model
{
    NSString *year = [model.acTime substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [model.acTime substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [model.acTime substringWithRange:NSMakeRange(8, 2)];
    NSString *strDate = [NSString stringWithFormat:@"%@%@%@",year,month,day];
    NSInteger intDate = [strDate integerValue];//指定行程的日期
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"yyyyMMdd"];//设置格式
    [dateformat setTimeZone:[[NSTimeZone alloc]initWithName:@"Asia/Beijing"]];//指定时区
    NSString *currentStrDate = [dateformat stringFromDate:date];
    NSInteger currentIntDate = [currentStrDate integerValue];//当前日期
    
    if (intDate > currentIntDate || intDate == currentIntDate)
    {
        return NO;
    }else
    {
        return YES;
    }
    
}

#pragma mark - UICollectionViewCell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    RCCollectionView *cv = (RCCollectionView *)collectionView;
    if ([cv.indModel.indName isEqualToString:@"精选"])
    {
        ;
    }else
    {
        NSMutableArray *activityList = [self.activityListByInd valueForKey:cv.indModel.indName];
        
        CZActivityInfoViewController *info = [[CZActivityInfoViewController alloc]init];
        info.title = @"活动介绍";
        info.activityModelPre = activityList[indexPath.row];
        
        [self.navigationController pushViewController:info animated:YES];
    }

}
#pragma mark - 返回指定数据的大小
- (CGSize)sizeByActivityModel:(ActivityModel *)model ForSepcifiedCell:(NSIndexPath *)indexPath
{
    CGFloat acImageW ; //图片的最大宽度,活动名的最大宽度
    CGFloat acImageH ; //图片的最大高度
    if (self.device == IPhone5)
    {
        acImageW = 142;
        acImageH = 142;
        
    }else if (self.device   == IPhone6)
    {
        acImageW = 165;
        acImageH = 165;
    }else
    {
  
        acImageW = 177;
        acImageH = 177;
    }
    CGSize maxSize = CGSizeMake(acImageW - 20, MAXFLOAT);
    CGSize acNameSize = [self sizeWithText:model.acTitle maxSize:maxSize fontSize:NAME_FONTSIZE];
    CGSize acTimeSize = [self sizeWithText:model.acTime maxSize:maxSize fontSize:TIME_FONTSIZE];
    CGSize acPlaceSize = [self sizeWithText:model.acPlace maxSize:maxSize fontSize:PLACE_FONTSIZE];
    CGSize acTagSize = [self sizeWithText:model.userInfo.userName maxSize:maxSize fontSize:TAG_FONTSIZE];
    CGFloat heigth = acImageH + 10 + (int)acNameSize.height + 10 + (int)acTimeSize.height + (int)acPlaceSize.height + 10 + (int)acTagSize.height+   5;

    return CGSizeMake(acImageW, heigth);
}
#pragma mark - 返回每个cell的高度
- (CGFloat)collectionView:(RCCollectionView *)collectionView waterFlowLayout:(RCCollectionViewLayout *)waterFlowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath
{
    //取出数据
    RCCollectionView *cv = (RCCollectionView *)collectionView;
    NSMutableArray *activityList = [self.activityListByInd valueForKey:cv.indModel.indName];
    return [self sizeByActivityModel:activityList[indexPath.row] ForSepcifiedCell:indexPath].height;
}


#pragma mark - get data
- (void)configureBlocks{
    @weakify(self);
    self.getIndListBlock = ^(){
        @strongify(self);
        return [[DataManager manager] getAllIndustriesWithSuccess:^(IndustryList *indList) {
            @strongify(self)
            self.indList = indList;
            for (IndustryModel *model in self.indList.list)
            {
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
            //按行业加载数据
            if ([model.indId isEqualToString:@"-1"]) {
                ActivityModel *acmodel = [[ActivityModel alloc]init];
                acmodel = acList.list.firstObject;
            }
//            NSLog(@"%@",model.indName);
            [self loadData:acList.list ByIndustry:model];
        } failure:^(NSError *error) {
            NSLog(@"Error:%@",error);
        }];
    };
    
    self.refreshAcListWithIndBlock = ^(IndustryModel *model,NSString *minAcId){
        @strongify(self);
        NSString *cityId = [[NSString alloc]init];
        if ([userDefaults objectForKey:@"cityId"]) {
            cityId = [userDefaults objectForKey:@"cityId"];
        } else {
            cityId = @"1";
        }
        return [[DataManager manager] checkIndustryWithCityId:cityId industryId:model.indId startId:minAcId success:^(ActivityList *acList) {
            @strongify(self);
            if ([minAcId isEqualToString:@"0"]) {
                [self refreshData:acList.list ByIndustry:model];
            } else {
                if (acList == nil) {
                     RCCollectionView *collectionView = [self getCurrentCollectionView];
                    [collectionView.mj_footer endRefreshingWithNoMoreData];
                } else {
                    [self getMoreData:acList.list ByIndustry:model];
                }
            }
        } failure:^(NSError *error) {
            NSLog(@"Error:%@",error);
        }];
    };
}

- (void)loadData:(NSArray *)acListRecived ByIndustry:(IndustryModel *)model
{
    if ([model.indName isEqualToString:@"精选"])
    {
        long int index = [self.indList.list indexOfObject:model];
        RCCollectionView *collectionView = [self creatAblumCollection:(int)index WithIndModel:model];
        NSMutableArray *acList = [[NSMutableArray alloc]init];
        for (ActivityModel *model in acListRecived)
        {
            [acList addObject:model];
        }
        [self.collectionViewByInd setObject:collectionView forKey:model.indName];
        //[self.activityListByInd setObject:acList forKey:model.indName];
        [self getAblumActivity:collectionView];
    }else
    {
        long int index = [self.indList.list indexOfObject:model];
        RCCollectionView *collectionView = [self createCollectionView:(int)index WithIndModel:model];
        NSMutableArray *acList = [[NSMutableArray alloc]init];
        for (ActivityModel *model in acListRecived) {
            [acList addObject:model];
        }
        [self.collectionViewByInd setObject:collectionView forKey:model.indName];
        [self.activityListByInd setObject:acList forKey:model.indName];
    }

}

-(void)refreshData:(NSArray *)acListRecived ByIndustry:(IndustryModel *)model{
    RCCollectionView *collectionView = [self.collectionViewByInd objectForKey:model.indName];
    NSMutableArray *acList = [[NSMutableArray alloc]init];
    for (ActivityModel *model in acListRecived) {
        [acList addObject:model];
    }
    [self.activityListByInd setObject:acList forKey:model.indName];
    [collectionView reloadData];
}

-(void)getMoreData:(NSArray *)acListRecived ByIndustry:(IndustryModel *)model{
    RCCollectionView *collectionView = [self.collectionViewByInd objectForKey:model.indName];
    NSMutableArray *acList = [self.activityListByInd objectForKey:model.indName];
    for (ActivityModel *model in acListRecived) {
        [acList addObject:model];
    }
    [self.activityListByInd setObject:acList forKey:model.indName];
    [collectionView reloadData];
}
#pragma mark - 请求精选数据
- (void)getAblumActivity:(RCCollectionView *) collectionView
{
    NSString *urlStr = @"http://appv2.myrichang.com/Home/Industry/getAlbums";
    NetWorkingRequestType type = POST;
    NSString *ct_id = [userDefaults objectForKey:@"cityId"];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:ct_id,@"ct_id",nil];
    [RCNetworkingRequestOperationManager request:urlStr requestType:type parameters:parameters completeBlock:^(NSData *data) {
        id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        //NSArray *activity = [dict valueForKey:@"data"];
        NSMutableArray *temp = [self initablumListWithDict:dict];
        [self.activityListByInd setObject:temp forKey:@"精选"];
        [collectionView reloadData];

    } errorBlock:^(NSError *error) {
        NSLog(@"请求失败:%@",error);
    }];
}
- (NSMutableArray *)initablumListWithDict:(NSDictionary *)dict
{
    NSNumber *code = [dict valueForKey:@"code"];
    if ([code isEqualToNumber:[[NSNumber alloc]initWithInt:200]])
    {//返回正确的数据
        
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        NSArray *data = [dict valueForKey:@"data"];
        for (NSDictionary *dic in data)
        {
            [temp addObject:[self ablumActivityfromDict:dic]];
        }
        return temp;
    }else if ([code isEqualToNumber:[[NSNumber alloc]initWithInt:210]])
    {//返回失败:操作类型无效或用户ID为空
        NSLog(@"获取精选失败:%@",[dict valueForKey:@"msg"]);
        return nil;
    }else
    {
        NSLog(@"获取精选其他错误：%@",code);
        return nil;
    }
}
- (RCAblumModel *)ablumActivityfromDict:(NSDictionary *)dict
{
    RCAblumModel *ablum_ac = [[RCAblumModel alloc]init];
    ablum_ac.album_id = [dict valueForKey:@"album_id"];
    ablum_ac.album_name = [dict valueForKey:@"album_name"];
    ablum_ac.album_img = [dict valueForKey:@"album_img"];
    ablum_ac.album_desc = [dict valueForKey:@"album_desc"];
    ablum_ac.album_time = [dict valueForKey:@"album_time"];
    ablum_ac.read_num = [dict valueForKey:@"read_num"];
    return ablum_ac;
}

-(void)setIndList:(IndustryList *)indList
{
    _indList = indList;
    IndustryModel *allAc = [[IndustryModel alloc]init];
    allAc.indId =@"-1";
    allAc.indName = @"综合";
    NSMutableArray *indAry =[[NSMutableArray alloc]initWithArray:indList.list];
    [indAry insertObject:allAc atIndex:0];
    IndustryModel *album = [[IndustryModel alloc]init];
    album.indId =@"-2";
    album.indName = @"精选";
    [indAry insertObject:album atIndex:0];
    _indList.list = [[NSArray alloc] initWithArray:indAry];
    //创建工具条按钮
    if (_indList.list != 0)
    {
        self.toolScrollView.hidden = NO;
        [self showToolButtons];
        self.scrollView.contentSize = CGSizeMake(_indList.list.count * kScreenWidth, 0);
        self.scrollViewDelegate.toolScrollView = self.toolScrollView;
    }else
    {//网络异常或者后台没有数据时
        self.toolScrollView.hidden = YES;
    }
}
#pragma mark - 创建精选collectionView
- (RCCollectionView *)creatAblumCollection:(int)index WithIndModel:(IndustryModel *)indModel
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat margin = 10;
    //CGFloat itemWH = (kScreenWidth - 2 * margin - 4) / 4 - margin;
    layout.itemSize = CGSizeMake(kScreenWidth, 200);
    layout.minimumInteritemSpacing = 0;//行间距
    layout.minimumLineSpacing = 0;    //列间距
    //CGFloat top = margin + 44;
    
    RCCollectionView *collectionView = [[RCCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.indModel = indModel;
    [self.scrollView addSubview:collectionView];
    [collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top).offset(-64);//64用于消除collectionView在ScrollView的位置影响
        make.left.equalTo(self.scrollView.mas_left).offset(index *kScreenWidth);
        make.width.mas_equalTo(kScreenWidth);
        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
    }];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.alwaysBounceHorizontal = NO;
    //if (iOS7Later) _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 2);
    collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
    collectionView.mj_header = [RCHomeRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    collectionView.mj_footer= [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMoreData)];
    [collectionView registerClass:[RCAblumCollectionCell class] forCellWithReuseIdentifier:albumReuseIdentifier];
    return collectionView;
}
#pragma mark - 根据行业在indlist中的下标生成对应的collectionView
- (RCCollectionView *)createCollectionView:(int)index WithIndModel:(IndustryModel *)indModel
{
//    RCCollectionViewLayout *layout= [[RCCollectionViewLayout alloc]init];
//    layout.layoutDelegate = self;

#pragma mark - 修改布局
    //创建布局
    BWaterflowLayout * layout = [[BWaterflowLayout alloc]init];
    layout.delegate = self;
    
    RCCollectionView * collectionView = [[RCCollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.indModel = indModel;
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

#pragma mark - <BWaterflowLayoutDelegate>

-(CGFloat)collectionView:(RCCollectionView *)collectionView waterflowLayout:(BWaterflowLayout *)waterflowLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth
{
    //取出数据
    RCCollectionView *cv = (RCCollectionView *)collectionView;
    NSMutableArray *activityList = [self.activityListByInd valueForKey:cv.indModel.indName];
    CGSize size = [self sizeByActivityModel:activityList[indexPath.row] ForSepcifiedCell:indexPath];

    return size.height;
}
//瀑布流列数
- (CGFloat)columnCountInWaterflowLayout:(BWaterflowLayout *)waterflowLayout
{
    return 2;
}
- (CGFloat)columnMarginInWaterflowLayout:(BWaterflowLayout *)waterflowLayout
{
    return 10;
    
}
- (CGFloat)rowMarginInWaterflowLayout:(BWaterflowLayout *)waterflowLayout
{
    return 10;
    
}
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(BWaterflowLayout *)waterflowLayout
{

    return UIEdgeInsetsMake(10, 10, 10, 10);
}
#pragma mark - 下拉对应的collectionView刷新数据
- (void)loadNewData
{
    //获取当前的collectionView
    RCCollectionView *collectionView = [self getCurrentCollectionView];
    if ([collectionView.indModel.indName isEqualToString:@"精选"])
    {
        [self.activityListByInd removeObjectForKey:@"精选"];
        [self getAblumActivity:collectionView];
    }else
    {
        if (self.refreshAcListWithIndBlock)
        {
            self.refreshAcListWithIndBlock(collectionView.indModel,@"0");
        }
    }

    [collectionView.mj_header endRefreshing];
    [collectionView.mj_footer endRefreshing];
}

//同时刷新所有collectionView
-(void)refreshColumn{
    if (self.refreshAcListWithIndBlock) {
        for (IndustryModel *indModel in self.indList.list) {
            self.refreshAcListWithIndBlock(indModel,@"0");
        }
    }
}
#pragma mark - 上拉对应的collectionView刷新数据
-(void)getMoreData
{
    //获取当前的collectionView
    RCCollectionView *collectionView = [self getCurrentCollectionView];
    if ([collectionView.indModel.indName isEqualToString:@"精选"])
    {
        [self getMoreAblum:collectionView];
    }else
    {
        NSMutableArray *acList = [self.activityListByInd objectForKey:collectionView.indModel.indName];
        ActivityModel *minModel = acList.lastObject;
        NSString *minId = minModel.acID;
        if (minId.length == 0)
        {
            [collectionView.mj_footer endRefreshingWithNoMoreData];
        } else
        {
            if (self.refreshAcListWithIndBlock)
            {
                self.refreshAcListWithIndBlock(collectionView.indModel,minId);
            }
            [collectionView.mj_footer endRefreshing];
        }
    }

}
#pragma mark - 精选的上拉刷新
- (void)getMoreAblum:(RCCollectionView *)collectionView
{
    NSMutableArray *ablumArr = [self.activityListByInd objectForKey:collectionView.indModel.indName];
    if (ablumArr.count == 0 || ablumArr == nil)
    {
        [self getAblumActivity:collectionView];
    }else
    {
        RCAblumModel *model = ablumArr.firstObject;
        NSString *ct_id = [userDefaults objectForKey:@"cityId"];
        NSString *URLString = @"http://appv2.myrichang.com/Home/Industry/getAlbums";
        NSString *start_id = model.album_id;
        NSDictionary *paramters = [NSDictionary dictionaryWithObjectsAndKeys:start_id, @"start_id",ct_id, @"ct_id", nil];
        [RCNetworkingRequestOperationManager request:URLString requestType:POST parameters:paramters completeBlock:^(NSData *data) {
            id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSArray *ablums = [dict valueForKey:@"data"];
            if (ablums.count == 0 || ablums == nil)
            {
                ;//[collectionView.mj_footer endRefreshing];
            }else
            {
                NSMutableArray *temp = [self initablumListWithDict:dict];
                for (RCAblumModel *model in temp)
                {
                    [ablumArr addObject:model];
                }
                //[collectionView.mj_footer endRefreshing];
            }
            [collectionView.mj_footer endRefreshing];
            [collectionView reloadData];
        } errorBlock:^(NSError *error) {
            NSLog(@"精选上拉刷新失败:%@",error);
            [collectionView.mj_footer endRefreshing];
        }];

    }
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
-(void)setAcListRecived:(ActivityList *)acListRecived
{
    _acListRecived = acListRecived;
    
}

- (UIScrollView *)toolScrollView
{
    if (!_toolScrollView) {
        _toolScrollView  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 68, kScreenWidth, 35)];
        _toolScrollView.backgroundColor = [UIColor whiteColor];
        //设置分布滚动，去掉水平和垂直滚动条
        _toolScrollView.showsHorizontalScrollIndicator = NO;
        _toolScrollView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_toolScrollView ];
        _toolScrollView.hidden = YES;
    }
    return _toolScrollView;
}

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
            //btnView.line.hidden = NO;
        }else
        {
            //btnView.line.hidden = YES;
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
//        btnView.backgroundColor = [UIColor redColor];
        
    }
//    [self.toolScrollView addSubview:[[UIView alloc]init]];
    self.line = [[UIView alloc]init];
    self.line.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];
    [self.toolScrollView addSubview:self.line];
    [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolScrollView).offset(34);
        make.left.equalTo(self.toolScrollView.mas_left).offset(10);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(1);
    }];
    
#pragma mark - 赋值scrollViewDelegate滚动按键数组
    self.scrollViewDelegate.toolButtonArray = self.toolButtonArray;
    self.scrollViewDelegate.line = self.line;
}

- (void)isToolButtonSelected:(UIButton *)btn
{
    for (int i = 0; i < self.toolButtonArray.count; ++i)
    {
        UIButton *button = self.toolButtonArray[i];
        //UIView *view = button.superview;
        //UIView *line = [view viewWithTag:12];
        //line.hidden = YES;
        button.selected = NO;
    }
    btn.selected = YES;
    //UIView *view = btn.superview;
    //UIView *line = [view viewWithTag:12];
    //line.hidden = NO;
}
- (CurrentDevice)device
{
    if (!_device)
    {
        _device = [self currentDeviceSize];
    }
    return _device;
}
- (RCColumnScrollViewDelegate *)scrollViewDelegate
{
    if (!_scrollViewDelegate)
    {
        _scrollViewDelegate = [[RCColumnScrollViewDelegate alloc]init];
        _scrollViewDelegate.device = [self currentDeviceSize];
        [self.view addSubview:_scrollViewDelegate];
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
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}
#pragma mark - 获取机型用于适配
- (CurrentDevice)currentDeviceSize
{
    if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 4"] ||
        [[self getCurrentDeviceModel] isEqualToString:@"iPhone 5"] )
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
