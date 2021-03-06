//
//  CZActivityInfoViewController.m
//  rc
//
//  Created by AlanZhang on 16/1/15.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZActivityInfoViewController.h"
#import "ActivityModel.h"
#import "CommentModel.h"
#import "Masonry.h"
#import "CZTimeCell.h"
#import "AcPublisherCell.h"
#import "PreCommentView.h"
#import "CZActivityInfoCell.h"
#import "CZRemindMeView.h"
#import "RemindManager.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationSlide.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UINavigationBar+Awesome.h"
#import "UIImageView+LBBlurredImage.h"
#import "UIColor+YDAddition.h"
#import "RCBarButton.h"
#import "RCBarButtonView.h"
#import "RCReleaseCell.h"
#import "RCCommentViewController.h"
#import "PublisherViewController.h"
#import "RCNetworkingRequestOperationManager.h"
//----------------ShareSDK3.3-----------------
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#define FONTSIZE 14
#define PADDING  10 //活动详情cell 中子控件之间的垂直间距
#define HEADERH  215//高斯模糊图片的高度
@interface CZActivityInfoViewController ()

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIImageView *acImageView;
@property (nonatomic, strong) UIImageView *acTagImageView;
@property (nonatomic, strong) UILabel *acTittleLabel;
@property (nonatomic, strong) UILabel *acTagLabel;

@property (nonatomic, strong) UIButton *addSchedule;
@property (nonatomic, strong) UIButton *signUp;
@property (nonatomic, strong) RCBarButtonView *barButtonView;
@property (nonatomic, strong) PreCommentView *prePreCommentView;

@property (nonatomic, strong) NSString *isCollect;
@property (nonatomic, strong) NSString *isFollwed;
@property (nonatomic, strong) NSString *planId;
@property (nonatomic, strong) NSMutableArray *plAlarm;
@property (nonatomic, strong) ActivityModel *activitymodel;
@property (nonatomic,strong) CommentList *hotComList;
@property (nonatomic, assign) CGFloat acHtmlHeight;
@property (nonatomic, copy) NSURLSessionDataTask* (^getActivityBlock)();
@property (nonatomic, copy) NSURLSessionDataTask* (^getHotCommentBlock)();
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *collectionItem;

@property (nonatomic,assign)  BOOL isShowComment;

/**
 *  面板
 */
@property (nonatomic, strong) UIView *panelView;

/**
 *  加载视图
 */
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@end

@implementation CZActivityInfoViewController
- (CGFloat)acHtmlHeight
{
    if (!_acHtmlHeight) {
        _acHtmlHeight = 10;
    }
    return _acHtmlHeight;
}
- (UIBarButtonItem *)collectionItem
{
    if (!_collectionItem)
    {
        UIImage *collectionImage =[UIImage imageNamed:@"collectionNormal"];
        _collectionItem = [[UIBarButtonItem alloc]initWithImage:collectionImage style:UIBarButtonItemStylePlain target:self action:@selector(onClickCollection)];
    }
    return _collectionItem;
}
#pragma mark - view

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didShowActivityInfo) name:@"getActivityInfo" object:nil];
    [self createSubViews];
    self.addSchedule.hidden = YES;
    self.signUp.hidden = YES;
    [self configureBlocks];
    self.getActivityBlock();
    self.getHotCommentBlock();
    //设置导航栏
    [self setNavigation];
    
}
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
- (void)didShowActivityInfo
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.addSchedule.hidden = NO;
    self.signUp.hidden = NO;
    //设置tableView头
    [self layoutHeaderImageView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.isCollect = self.activitymodel.acCollect;
    self.isFollwed = self.activitymodel.followed;
    [self setaddScheduleStyle];
    //对tableView头进行赋值
    [self setTableViewHeader];
    [self.tableView reloadData];
    [self setwebViewCellH];
}
- (void)setwebViewCellH
{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    self.webView.delegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    self.webView.scalesPageToFit = NO;
    //加载url
    NSString *css = @"<style type='text/css'>\
                        img{width: 100%}\
                        p{padding-left:5px;font-size:13px;padding-right:5px;line-height:150%;\
                        text-align:justify;text-justify:inter-ideograph;}\
                     </style>";
    self.activitymodel.acHtml = [NSString stringWithFormat:@"%@%@",self.activitymodel.acHtml,css];
    NSURL *baseURL = [NSURL fileURLWithPath:self.activitymodel.acHtml];
    [self.webView loadHTMLString:self.activitymodel.acHtml baseURL:baseURL];

}
- (void)cellValue:(NSNotification *)notification
{
    NSIndexSet *section = [NSIndexSet indexSetWithIndex:1];
    [self.tableView reloadSections:section withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Data
- (void)configureBlocks{
    @weakify(self);
    self.getActivityBlock = ^(){
        @strongify(self);
        NSString *userId = [[NSString alloc]init];
        if ([userDefaults objectForKey:@"userId"]) {
            userId = [userDefaults objectForKey:@"userId"];
        } else {
            userId = @"-1";
        }
        return [[DataManager manager] getActivityContentWithAcId:self.activityModelPre.acID userId:userId success:^(ActivityModel *activity) {
            @strongify(self);
            self.activitymodel = activity;
        } failure:^(NSError *error) {
            NSLog(@"Error:%@",error);
        }];
    };
    
    self.getHotCommentBlock = ^(){
        @strongify(self);
        NSString *userId = [[NSString alloc]init];
        if ([userDefaults objectForKey:@"userId"]) {
            userId = [userDefaults objectForKey:@"userId"];
        } else {
            userId = @"-1";
        }
        return [[DataManager manager] getPopularCommentsWithAcID:self.activityModelPre.acID usrID:userId success:^(CommentList *comList) {
            self.hotComList = comList;
        } failure:^(NSError *error) {
            NSLog(@"Error:%@",error);
        }];
    };
}

-(void)setActivityModelPre:(ActivityModel *)activityModelPre{
    _activityModelPre = activityModelPre;
    
}
#pragma mark - 数据下载完毕
-(void)setActivitymodel:(ActivityModel *)activitymodel{
    
    _activitymodel = activitymodel;
    if (_activitymodel.acTitle)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"getActivityInfo" object:_activitymodel];
    }
}

-(void)setHotComList:(CommentList *)hotComList{
    
    _hotComList = hotComList;
    [self.prePreCommentView.preCommentView reloadData];
}

-(NSString *)isCollect{
    if (!_isCollect) {
        _isCollect = @"0";
    }
    return _isCollect;
}
-(NSString *)isFollwed{
    if (!_isFollwed) {
        _isFollwed = @"0";
    }
    return _isFollwed;
}

-(NSString *)planId{
    if (!_planId) {
        _planId = @"joined";
    }
    return _planId;
}

-(NSMutableArray *)plAlarm{
    if (!_plAlarm) {
        _plAlarm = [NSMutableArray arrayWithObjects:@"0",@"0",@"0", nil];
    }
    return _plAlarm;
}
//左侧按钮的点击事件
- (void) backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - Table view data source
//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    if (section == 4) {
        return 0;
    }
    return 30;
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
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 60, 30)];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"活动详情";
        label.textColor = textcolor;
        [view addSubview:label];
    }else if (section == 2)
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen]bounds].size.width, 60.0/2)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 60, 30)];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"发布者";
        label.textColor = textcolor;
        [view addSubview:label];
    }
    else
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen]bounds].size.width, 60.0/2)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 60, 30)];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"活动详情";
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {//时间
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
        {//活动详情
            CZActivityInfoCell *cell = [CZActivityInfoCell activityCellWithTableView:tableView];
            //对cell的控件进行赋值
            [self setCellValue:cell AtIndexPath:indexPath];
            //对cell的控件进行布局
            [cell setSubViewsConstraint];
            return cell;
        }
            break;
        case 2:
        {//发布者
            AcPublisherCell *cell = [[AcPublisherCell alloc]init];
            //对cell的控件进行赋值
            [cell setSubviewsValueWithImage:self.activitymodel.userInfo.userPic PubName:self.activitymodel.userInfo.userName isFollowed:self.activitymodel.followed];
            //轻拍Tap
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(turnToPublisherView)];
            [cell.publisher addGestureRecognizer:tap];
            if ([DataManager manager].user.isLogin) {
                [cell.follow addTarget:self action:@selector(followOrDis:) forControlEvents:UIControlEventTouchUpInside];
            } else {
                self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
                self.HUD.removeFromSuperViewOnHide = YES;
                [self.view addSubview:self.HUD];
                [self.HUD showAnimated:YES];
                self.HUD.mode = MBProgressHUDModeCustomView;
                self.HUD.label.text = @"请登录";
                [self.HUD hideAnimated:YES afterDelay:0.6];
            }
            return cell;
        }
            break;
        default:
        {//更多内容
            static NSString *identifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                [cell.contentView addSubview:self.webView];
                self.isShowComment = NO;
                self.prePreCommentView = [[PreCommentView alloc]init];
                self.prePreCommentView.commentList = _hotComList;
                [self.prePreCommentView.showCommentBtn addTarget:self action:@selector(onClickShowCommment) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:self.prePreCommentView];
                [self.prePreCommentView setSubViewsValue];
                [self.prePreCommentView showOrDissMissCommentWith:NO];
                [self.prePreCommentView.checkMoreBtn addTarget:self action:@selector(checkMorCommment) forControlEvents:UIControlEventTouchUpInside];
                [self.prePreCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(cell.contentView.mas_left);
                    make.right.equalTo(cell.contentView.mas_right);
                    make.height.mas_equalTo(35);
                    make.bottom.equalTo(cell.contentView.mas_bottom);
                }];
                /* 忽略点击效果 */
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            return cell;
        }
            break;
    }
}


//非两端对齐
- (void) cell:(UITableViewCell *)cell Constraint:(UILabel *)acIntroduce
{
    acIntroduce.numberOfLines = 0;
    acIntroduce.font = [UIFont systemFontOfSize:FONTSIZE];
    CGSize maxSize = CGSizeMake(kScreenWidth - 30, MAXFLOAT);
    CGSize size = [self sizeWithText:self.activitymodel.acDesc maxSize:maxSize fontSize:FONTSIZE];
    [acIntroduce mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.mas_top).offset(PADDING);
        make.left.equalTo(cell.mas_left).offset(15);
        make.right.equalTo(cell.mas_right).offset(-15);
        make.width.mas_equalTo((int)size.width + 1);
        make.height.mas_equalTo((int)size.height + 1);
    }];
}

//cell的控件进行赋值
- (void) setCellValue:(UITableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[CZTimeCell class]])
    {
        NSString *dateStr = [self.activitymodel.acTime substringWithRange:NSMakeRange(0, 10)];
        NSString *week = [self weekLabelStr:dateStr];
        NSString *time = [self.activitymodel.acTime substringWithRange:NSMakeRange(11, 5)];
        ((CZTimeCell*)cell).timeLabel.text = [NSString stringWithFormat:@"时间: %@ %@ %@",dateStr, week, time];
        
    }else if([cell isKindOfClass:[CZActivityInfoCell class]])
    {
        ((CZActivityInfoCell *)cell).model = self.activitymodel;
    }else if([cell isKindOfClass:[RCReleaseCell class]])
    {
        RCReleaseCell *rcell = (RCReleaseCell *)cell;
        [rcell.imgIcon sd_setImageWithURL:[NSURL URLWithString:self.activitymodel.userInfo.userPic]placeholderImage:[UIImage imageNamed:@"meetingIcon"]];

        [rcell.label setText:self.activitymodel.userInfo.userName];
    }else
    {
        ;
    }
}

- (NSString *)weekLabelStr:(NSString *)dateStr
{
    NSString *year = [dateStr substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [dateStr substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [dateStr substringWithRange:NSMakeRange(8, 2)];
    NSString *strWeek = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"yyyy-MM-dd"];//设置格式
    [dateformat setTimeZone:[[NSTimeZone alloc]initWithName:@"Asia/Beijing"]];//指定时区
    NSDate *date = [dateformat dateFromString:strWeek];
    return [self weekStringFromDate:date];
    
}

/**
 *  根据日期返回星期
 *
 * @param date 指定的日期
 *
 * @return 返回指定日期的星期
 */
-(NSString *)weekStringFromDate:(NSDate *)date
{
    NSArray *weeks = @[[NSNull null],@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    NSCalendar *calendar =[[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone =[[NSTimeZone alloc]initWithName:@"Asia/Beijing"];
    [calendar setTimeZone:timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *components = [calendar components:calendarUnit fromDate:date];
    return [weeks objectAtIndex:components.weekday];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0)
    {
        return 47;
        
    }else if(indexPath.section == 1)
    {
        return [self heightForAcInfoCell];
    }else if (indexPath.section == 2)
    {
        return [self heightForSpeakerCell];
    }else
    {
        return self.webView.frame.size.height+35;
    }
}
- (CGFloat)heightForSpeakerCell
{//发布者Cell的高度
    return 45 + 2*PADDING;
}
- (CGFloat)heightForAcInfoCell
{
    CGSize maxSize = CGSizeMake(kScreenWidth - 55, MAXFLOAT);
    CGSize speakerMaxSize = CGSizeMake(kScreenWidth - 70, MAXFLOAT);
    CGSize placeSize = [self sizeWithText:self.activitymodel.acPlace maxSize:maxSize fontSize:FONTSIZE];
    CGSize scaleSize = [self sizeWithText:self.activitymodel.acSize maxSize:maxSize fontSize:FONTSIZE];
    CGSize paySize = [self sizeWithText:self.activitymodel.acPay maxSize:maxSize fontSize:FONTSIZE];
    CGSize speakerSize = [self sizeWithText:self.activitymodel.acDesc maxSize:speakerMaxSize fontSize:FONTSIZE];
    return (int)placeSize.height + (int)scaleSize.height + (int)paySize.height + (int)speakerSize.height+ 3 + 5 *PADDING;
}
#pragma mark - UIWebView Delegate Methods
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //获取到webview的高度
    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    self.webView.frame = CGRectMake(self.webView.frame.origin.x,self.webView.frame.origin.y, kScreenWidth, height);
//    //给网页增加css样式
//    [webView stringByEvaluatingJavaScriptFromString:
//     @"var tagHead = document.documentElement.firstChild;"
//     "var tagStyle = document.createElement(\'style\');"
//     "tagStyle.setAttribute(\'type\', \'text/css\');"
//     "tagStyle.appendChild(document.createTextNode(\'p{padding-left:5px;font-size:14px;line-height:150%}\'));"
//     "tagStyle.appendChild(document.createTextNode(\'img{width:100%}\'));"
//     "var tagHeadAdd = tagHead.appendChild(tagStyle);"];

    [self.tableView reloadData];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    NSLog(@"didFailLoadWithError===%@", error);
}

// 配置tableView header UI布局
- (void)layoutHeaderImageView
{
    self.header = [[UIView alloc]init];
    [self.header setFrame:CGRectMake(0, 0, kScreenWidth, HEADERH)];
    self.tableView.tableHeaderView = self.header;
    self.headerImageView = [[UIImageView alloc]init];
    self.headerImageView.alpha = 0.7;
    
    __block UIColor *imageColor = [[UIColor alloc]init];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.activitymodel.acPoster] placeholderImage:[UIImage imageNamed:@"20160102.png"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.headerImageView setImageToBlur:self.headerImageView.image blurRadius:21 completionBlock:nil];
        imageColor = [UIColor getImageColor:self.headerImageView.image];
        //[self.headerImageView changeImageBright:self.headerImageView.image Bright:0.3];
    }];
    [self.header addSubview:self.headerImageView];

    [self.headerImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.header.mas_top);
        make.left.equalTo(self.header.mas_left);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(HEADERH);
    }];
    //headerView中的子控件
    self.acImageView    = [[UIImageView alloc]init];
    self.acTagImageView = [[UIImageView alloc]init];
    self.acTittleLabel  = [[UILabel alloc]init];
    self.acTagLabel     = [[UILabel alloc]init];
    
    [self.header addSubview:self.acImageView];
    [self.header addSubview:self.acTagImageView];
    [self.header addSubview:self.acTittleLabel];
    [self.header addSubview:self.acTagLabel];
    
    self.acTagImageView.image = [UIImage imageNamed:@"tagImage"];
    self.acTittleLabel.text = self.activitymodel.acTitle;
    CGFloat red,green,blue,alpha,h,s,b,aHSL;
    [imageColor getRed:& red green:& green blue:& blue alpha:& alpha];
    [imageColor getHue:&h saturation:&s brightness:&b alpha:&aHSL];
    if (b<0.5) {
        UIColor *textColor = [UIColor whiteColor];
        self.acTittleLabel.textColor = textColor;
    } else {
        UIColor *textColor = [UIColor blackColor];
        self.acTittleLabel.textColor = textColor;
    }
    
    //重新设置导航栏颜色
    UILabel *newLab = (UILabel *)self.navigationItem.titleView;
    UIBarButtonItem *leftView = self.navigationItem.leftBarButtonItem;
    UIBarButtonItem *rightView = self.navigationItem.rightBarButtonItem;
    leftView.tintColor = self.acTittleLabel.textColor;
    rightView.tintColor = self.acTittleLabel.textColor;
    newLab.textColor = self.acTittleLabel.textColor;
    self.collectionItem.tintColor = self.acTittleLabel.textColor;
    //对tableView头进行布局
    [self setSubViewsConstraint];
    
}
#pragma mark - tableView的滚动事件
// 下拉后图片拉伸的效果方法下载这个里面
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset = scrollView.contentOffset.y;  // 偏移的y值
    if (yOffset <= 0)
    {
        CGFloat totalOffset = HEADERH + ABS(yOffset);

        [self.headerImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.header.mas_top).offset(yOffset);
            make.left.equalTo(self.header.mas_left);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(totalOffset);

        }];

    }

    if (yOffset < HEADERH - 64)
    {
//        self.barButtonView.label.text = @"活动介绍";
        
        [UIView animateWithDuration:0.5 animations:^{
            [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
        }];
        
    }else
    {
//        self.barButtonView.label.text = self.activitymodel.acTitle;
        [UIView animateWithDuration:0.5 animations:^{
            [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0]];
        }];
    }
}

//对tableView头进行赋值
- (void)setTableViewHeader
{
    self.acTittleLabel.font          = [UIFont systemFontOfSize:15];
    self.acTittleLabel.numberOfLines = 0;
    self.acTagLabel.font             = [UIFont systemFontOfSize:12];
    self.acTagLabel.textColor        = self.acTittleLabel.textColor;
    
    [self.acImageView sd_setImageWithURL:[NSURL URLWithString:self.activitymodel.acPoster] placeholderImage:[UIImage imageNamed:@"20160102.png"]];
    self.acTittleLabel.text   = self.activitymodel.acTitle;
    self.acTagImageView.image = [UIImage imageNamed:@"tagImage_white"];
    NSMutableArray *tagAry = [[NSMutableArray alloc]init];
    for (TagModel *model in self.activitymodel.tagsList.list) {
        [tagAry addObject:model.tagName];
    }
    NSString *tagStr = [tagAry componentsJoinedByString:@","];
    self.acTagLabel.text      = tagStr;
    
}
#pragma mark - 创建子控件
- (void)createSubViews
{
    //加载等待视图
    self.panelView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.panelView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.panelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    self.loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.loadingView.frame = CGRectMake((self.view.frame.size.width - self.loadingView.frame.size.width) / 2, (self.view.frame.size.height - self.loadingView.frame.size.height) / 2, self.loadingView.frame.size.width, self.loadingView.frame.size.height);
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.panelView addSubview:self.loadingView];
    
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    self.addSchedule =[UIButton buttonWithType:UIButtonTypeCustom];
    self.signUp = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor =[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tableView];
    [self.bottomView addSubview:self.addSchedule];
    [self.bottomView addSubview:self.signUp];
    
    [self.addSchedule addTarget:self action:@selector(onClickAdd) forControlEvents:UIControlEventTouchUpInside];
    [self.signUp addTarget:self action:@selector(onClickSignUp) forControlEvents:UIControlEventTouchUpInside];
    
    [self.signUp setTitle:@"我要报名" forState:UIControlStateNormal];
    [self.signUp setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:130.0/255.0  blue:5.0/255.0  alpha:1.0]];

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
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 50));
    }];
    
    //add addSchedule constraints
    [self.addSchedule mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(kScreenWidth / 2);
        make.height.mas_equalTo(50);
        //make.size.mas_equalTo(CGSizeMake(kScreenWidth / 2, 50));
    }];
    
    //add signUp constriants
    [self.signUp mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addSchedule.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(50);
    }];
    
}

-(void)setaddScheduleStyle
{
    if ([self.activitymodel.plan isEqualToString:@"1"]) {
        //[self.addSchedule setImage:[UIImage imageNamed:@"collectionNormal"] forState:UIControlStateNormal];
        //[self.addSchedule setImage:[UIImage imageNamed:@"collectionSelected"] forState:UIControlStateHighlighted];
        [self.addSchedule setTitle:@"已加入行程" forState:UIControlStateNormal];
        [self.addSchedule setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        //[self.addSchedule setImage:[UIImage imageNamed:@"collectionSelected"] forState:UIControlStateNormal];
        //[self.addSchedule setImage:[UIImage imageNamed:@"collectionNormal"] forState:UIControlStateHighlighted];
        [self.addSchedule setTitle:@"加入行程" forState:UIControlStateNormal];

    }
    [self.addSchedule setTitleColor:[UIColor colorWithRed:38.0/255.0 green:40.0/255.0 blue:50.0/255.0 alpha:0.8] forState:UIControlStateNormal];
    //self.addSchedule.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    //self.addSchedule.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

//设置导航栏
- (void)setNavigation
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    //设置导航标题栏
    UILabel *titleLabel     = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font         = [UIFont systemFontOfSize:18];
    titleLabel.textColor    = self.acTittleLabel.textColor;
    titleLabel.textAlignment= NSTextAlignmentCenter;
    titleLabel.text = @"活动介绍";
    self.navigationItem.titleView = titleLabel;
    
    //设置导航栏的左侧按钮
//    self.barButtonView = [[RCBarButtonView alloc]initWithFrame:CGRectMake(0, 0, 250, 30)];
//    [self.barButtonView setSubView];
//    [self.barButtonView.button addTarget:self action:@selector(backToForwardViewController) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:self.barButtonView];
//    [self.navigationItem setLeftBarButtonItem:leftButton];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon_white"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    left.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:left];

    //设置导航栏的右侧按钮
    UIImage *shareImage =[UIImage imageNamed:@"shareIcon"];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithImage:shareImage style:UIBarButtonItemStylePlain target:self action:@selector(didShare:)];
    shareItem.tintColor = [UIColor whiteColor];

    [self.navigationItem setRightBarButtonItems:@[shareItem, self.collectionItem]];

}

- (void)showLoadingView:(BOOL)flag
{
    if (flag)
    {
        [self.view addSubview:self.panelView];
        [self.loadingView startAnimating];
    }
    else
    {
        [self.panelView removeFromSuperview];
    }
}
#pragma mark - 分享
- (void)didShare:(id)button
{
    //sharSDK3.3
    //1、创建分享参数
    NSArray* imageArray = @[self.activitymodel.acPoster];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"日常"
                                         images:imageArray
                                            url:[NSURL URLWithString:[NSString stringWithFormat:@"http://myrichang.com/activity.php?id=%@",self.activitymodel.acID]]
                                          title:self.activitymodel.acTitle
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertController *chooseView = [UIAlertController alertControllerWithTitle:@"分享成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                               UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                   
                               }];
                               [chooseView addAction:cancelAction];
                               
                               [self presentViewController:chooseView animated:YES completion:nil];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertController *chooseView = [UIAlertController alertControllerWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@",error] preferredStyle:UIAlertControllerStyleAlert];
                               UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                   
                               }];
                               [chooseView addAction:cancelAction];
                               
                               [self presentViewController:chooseView animated:YES completion:nil];

                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
}
//对tableView头进行布局
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
        make.top.equalTo(self.acTagImageView.mas_top).offset(-5);
        make.size.mas_equalTo(CGSizeMake(150, 20));
    }];
}

#pragma mark - 活动收藏
- (void)onClickCollection
{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.view addSubview:self.HUD];
    [self.HUD showAnimated:YES];
    
    if ([DataManager manager].user.isLogin)
    {
        if ([self.isCollect isEqualToString:@"0"]) {
            [[DataManager manager] setActivityCollectWithUserID:[userDefaults objectForKey:@"userId"] acId:self.activityModelPre.acID opType:@"1" success:^(NSString *msg) {
                self.isCollect = @"1";
                //[self.addSchedule setImage:[UIImage imageNamed:@"collectionSelected"] forState:UIControlStateNormal];
                //[self.addSchedule setImage:[UIImage imageNamed:@"collectionNormal"] forState:UIControlStateHighlighted];
                //[self.addSchedule setTitle:@"已加入行程" forState:UIControlStateNormal];
                self.HUD.mode = MBProgressHUDModeCustomView;
                self.HUD.label.text = @"收藏成功";
                [self.HUD hideAnimated:YES afterDelay:0.6];
            } failure:^(NSError *error) {
                self.HUD.mode = MBProgressHUDModeCustomView;
                self.HUD.label.text = @"操作失败";
                [self.HUD hideAnimated:YES afterDelay:0.6];
                NSLog(@"Error:%@",error);
            }];
        } else {
            [[DataManager manager] setActivityCollectWithUserID:[userDefaults objectForKey:@"userId"] acId:self.activityModelPre.acID opType:@"2" success:^(NSString *msg) {
                self.isCollect = @"0";
                //[self.addSchedule setImage:[UIImage imageNamed:@"collectionNormal"] forState:UIControlStateNormal];
                //[self.addSchedule setImage:[UIImage imageNamed:@"collectionSelected"] forState:UIControlStateHighlighted];
                //[self.addSchedule setTitle:@"加入行程" forState:UIControlStateNormal];
                self.HUD.mode = MBProgressHUDModeCustomView;
                self.HUD.label.text = @"取消收藏成功";
                [self.HUD hideAnimated:YES afterDelay:0.6];
            } failure:^(NSError *error) {
                self.HUD.mode = MBProgressHUDModeCustomView;
                self.HUD.label.text = @"操作失败";
                [self.HUD hideAnimated:YES afterDelay:0.6];
                NSLog(@"Error:%@",error);
            }];
        }
    } else
    {
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.label.text = @"请登录";
        [self.HUD hideAnimated:YES afterDelay:0.6];
    }
    
}
#pragma mark - 我要报名 2.0新增接口
- (void)onClickSignUp
{
    NSString *urlStr = @"http://appv2.myrichang.com/Home/Activity/enrollActivity";
    NetWorkingRequestType type = POST;
    NSString *usr_id = [userDefaults objectForKey:@"userId"];
    
    NSString *ac_id = self.activitymodel.acID;
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:usr_id,@"usr_id",ac_id,@"ac_id",nil];
    [RCNetworkingRequestOperationManager request:urlStr requestType:type parameters:parameters completeBlock:^(NSData *data) {
        id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSString *msg = [dict valueForKey:@"msg"];
        if ([msg isEqualToString:@"操作成功！"])
        {
            [self.signUp setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.signUp.userInteractionEnabled = NO;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            // Set the annular determinate mode to show task progress.
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"报名成功。";
            [hud hideAnimated:YES afterDelay:0.7];
            
        }else if ([msg isEqualToString:@"操作失败！"])
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"请不要重复报名！";
            [hud hideAnimated:YES afterDelay:0.7];
            
        }
        NSLog(@"%@",msg);
    } errorBlock:^(NSError *error) {
        NSLog(@"请求失败:%@",error);
    }];

}
#pragma mark - 添加行程
- (void)onClickAdd
{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.view addSubview:self.HUD];
    [self.HUD showAnimated:YES];
    
    if ([DataManager manager].user.isLogin) {
        [[DataManager manager] joinTripWithUserId:[userDefaults objectForKey:@"userId"] acId:self.activityModelPre.acID opType:@"1" success:^(NSString *planId) {
            if ([planId isEqualToString:@"joined"]) {
                self.HUD.mode = MBProgressHUDModeCustomView;
                self.HUD.label.text = @"该活动已在您的行程中(╯3╰)";
                [self.HUD hideAnimated:YES afterDelay:0.6];
            } else {
                self.planId = planId;
                self.HUD.mode = MBProgressHUDModeCustomView;
                self.HUD.label.text = @"加入成功~(≧▽≦)/~";

                [self.addSchedule setTitle:@"已加入行程" forState:UIControlStateNormal];
                [self.HUD hideAnimated:YES afterDelay:0.6];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"scState" object:@"update"];
            }
        } failure:^(NSError *error) {
            self.HUD.mode = MBProgressHUDModeCustomView;
            self.HUD.label.text = @"操作失败~>_<~ ";
            [self.HUD hideAnimated:YES afterDelay:0.6];
            NSLog(@"Error:%@",error);
        }];
    } else {
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.label.text = @"请登录";
        [self.HUD hideAnimated:YES afterDelay:0.6];
    }
}

- (void)onClickRemind{
    
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.view addSubview:self.HUD];
    [self.HUD showAnimated:YES];
    
    if ([DataManager manager].user.isLogin) {
        [[DataManager manager] joinTripWithUserId:[userDefaults objectForKey:@"userId"] acId:self.activityModelPre.acID opType:@"1" success:^(NSString *planId) {
            if ([planId isEqualToString:@"joined"]) {
                [[DataManager manager] addPlanWithOpType:@"2" planId:self.activitymodel.planId userId:[userDefaults objectForKey:@"userId"] themeId:self.activitymodel.acTheme planTime:self.activitymodel.acTime plAlarmOne:self.plAlarm[0] plAlarmTwo:self.plAlarm[1] plAlarmThree:self.plAlarm[2] planContent:@"" acPlace:@"" success:^(NSString *replanId) {
                    RemindManager *remindma = [[RemindManager alloc]init];
                    //先清除与本活动相关的所有本地通知
                    [remindma removeLocalNotificationWithNotificationId:self.activitymodel.planId];
                    //添加本地推送
                    NSDate *date = [remindma dateFromString:self.activitymodel.acTime];
                    if ([self.plAlarm[0] isEqualToString:@"1"]) {
                        NSDate *dateP1 = [NSDate dateWithTimeInterval:-3600 sinceDate:date];
                        [remindma scheduleLocalNotificationWithDate:dateP1 Title:self.activitymodel.acTitle notiID:planId];
                    }
                    if ([self.plAlarm[2] isEqualToString:@"1"]) {
                        NSDate *dateP2 = [NSDate dateWithTimeInterval:-86400 sinceDate:date];
                        [remindma scheduleLocalNotificationWithDate:dateP2 Title:self.activitymodel.acTitle notiID:planId];
                    }
                    if ([self.plAlarm[3] isEqualToString:@"1"]) {
                        NSDate *dateP3 = [NSDate dateWithTimeInterval:-259200 sinceDate:date];
                        [remindma scheduleLocalNotificationWithDate:dateP3 Title:self.activitymodel.acTitle notiID:planId];
                    }
                    //弹出提示框
                    self.HUD.mode = MBProgressHUDModeCustomView;
                    self.HUD.label.text = @"修改提醒成功";
                    [self.HUD hideAnimated:YES afterDelay:0.6];
                } failure:^(NSError *error) {
                    self.HUD.mode = MBProgressHUDModeCustomView;
                    self.HUD.label.text = @"操作失败";
                    [self.HUD hideAnimated:YES afterDelay:0.6];
                    NSLog(@"Error:%@",error);
                }];
            } else {
                self.planId = planId;
                [[DataManager manager] addPlanWithOpType:@"1" planId:self.planId userId:[userDefaults objectForKey:@"userId"] themeId:@"" planTime:@"" plAlarmOne:self.plAlarm[0] plAlarmTwo:self.plAlarm[1] plAlarmThree:self.plAlarm[2] planContent:@"" acPlace:@"" success:^(NSString *replanId) {
                    RemindManager *remindma = [[RemindManager alloc]init];
                    //添加本地推送
                    NSDate *date = [remindma dateFromString:self.activitymodel.acTime];
                    if ([self.plAlarm[0] isEqualToString:@"1"]) {
                        NSDate *dateP1 = [NSDate dateWithTimeInterval:-3600 sinceDate:date];
                        [remindma scheduleLocalNotificationWithDate:dateP1 Title:self.activitymodel.acTitle notiID:planId];
                    }
                    if ([self.plAlarm[2] isEqualToString:@"1"]) {
                        NSDate *dateP2 = [NSDate dateWithTimeInterval:-86400 sinceDate:date];
                        [remindma scheduleLocalNotificationWithDate:dateP2 Title:self.activitymodel.acTitle notiID:planId];
                    }
                    if ([self.plAlarm[3] isEqualToString:@"1"]) {
                        NSDate *dateP3 = [NSDate dateWithTimeInterval:-259200 sinceDate:date];
                        [remindma scheduleLocalNotificationWithDate:dateP3 Title:self.activitymodel.acTitle notiID:planId];
                    }
                    self.HUD.mode = MBProgressHUDModeCustomView;
                    self.HUD.label.text = @"报名提醒成功";
                    [self.HUD hideAnimated:YES afterDelay:0.6];
                } failure:^(NSError *error) {
                    self.HUD.mode = MBProgressHUDModeCustomView;
                    self.HUD.label.text = @"操作失败";
                    [self.HUD hideAnimated:YES afterDelay:0.6];
                    NSLog(@"Error:%@",error);
                }];
            }
        } failure:^(NSError *error) {
            self.HUD.mode = MBProgressHUDModeCustomView;
            self.HUD.label.text = @"操作失败";
            [self.HUD hideAnimated:YES afterDelay:0.6];
            NSLog(@"Error:%@",error);
        }];
    } else {
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.label.text = @"请登录";
        [self.HUD hideAnimated:YES afterDelay:0.6];
    }
}

#pragma mark - 关注点击事件
-(void)followOrDis:(UIButton *)btn{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.view addSubview:self.HUD];
    [self.HUD showAnimated:YES];
    
    if ([DataManager manager].user.isLogin)
    {
        if ([self.isFollwed isEqualToString:@"0"]) {
            [[DataManager manager] setPubFollwedWithUserID:[userDefaults objectForKey:@"userId"] publisherId:self.activityModelPre.userInfo.userId opType:@"1" success:^(NSString *msg) {
                self.isFollwed = @"1";
                [btn setTitle:@"已关注" forState:UIControlStateNormal];
                self.HUD.mode = MBProgressHUDModeCustomView;
                self.HUD.label.text = @"关注成功";
                [self.HUD hideAnimated:YES afterDelay:0.6];
            } failure:^(NSError *error) {
                self.HUD.mode = MBProgressHUDModeCustomView;
                self.HUD.label.text = @"操作失败";
                [self.HUD hideAnimated:YES afterDelay:0.6];
                NSLog(@"Error:%@",error);
            }];
        } else {
            [[DataManager manager] setPubFollwedWithUserID:[userDefaults objectForKey:@"userId"] publisherId:self.activityModelPre.userInfo.userId opType:@"2" success:^(NSString *msg) {
                self.isFollwed = @"0";
                [btn setTitle:@"+ 关注" forState:UIControlStateNormal];
                self.HUD.mode = MBProgressHUDModeCustomView;
                self.HUD.label.text = @"取消关注成功";
                [self.HUD hideAnimated:YES afterDelay:0.6];
            } failure:^(NSError *error) {
                self.HUD.mode = MBProgressHUDModeCustomView;
                self.HUD.label.text = @"操作失败";
                [self.HUD hideAnimated:YES afterDelay:0.6];
                NSLog(@"Error:%@",error);
            }];
        }
    } else
    {
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.label.text = @"请登录";
        [self.HUD hideAnimated:YES afterDelay:0.6];
    }

}

#pragma mark - 弹出提醒视图
- (void)onClickRemindMe:(UIButton *)btn
{
    CZRemindMeView *remindMeView = [CZRemindMeView remindMeView];
    [remindMeView.notRemind addTarget:self action:@selector(onClickTimeRemind:) forControlEvents:UIControlEventTouchUpInside];
    [remindMeView.remindBeforeOneHour addTarget:self action:@selector(onClickTimeRemind:) forControlEvents:UIControlEventTouchUpInside];
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
 *  不提醒------>10
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
    [btnArray addObject:[superView viewWithTag:10]];
    
    BOOL isSelecte = !btn.selected;
    if (isSelecte)
    {
        btn.selected = YES;
    }else
    {
        btn.selected = NO;
    }
    if (btn.tag == 10)
    {
        for (int i = 0; i<btnArray.count; i++)
        {
            UIButton *button = btnArray[i];
            if (button.tag != 10)
            {
                button.selected = NO;
                self.plAlarm[i] = @"0";
            }
        }
    }else
    {
        UIButton *button = btnArray.lastObject;
        button.selected = NO;
    }
}

//确定提醒时间按钮点击事件
- (void)onClickOK:(UIButton *)btn
{
    UIView *superView = btn.superview;
    NSMutableArray *btnArray = [[NSMutableArray alloc]init];
    [btnArray addObject:[superView viewWithTag:11]];
    [btnArray addObject:[superView viewWithTag:12]];
    [btnArray addObject:[superView viewWithTag:13]];
    [btnArray addObject:[superView viewWithTag:10]];
    
    for (int i = 0; i <btnArray.count; i++)
    {
        UIButton *button = btnArray[i];
        if (button.selected && button.tag != 10)
        {
            self.plAlarm[i] = @"1";
        } else {
            self.plAlarm[i] = @"0";
        }
    }
    
    [self onClickRemind];
    [self lew_dismissPopupView];
}

-(void)turnToPublisherView{
    PublisherViewController *publisherViewController = [[PublisherViewController alloc]init];
    [self.navigationController pushViewController:publisherViewController animated:YES];
}

#pragma mark - 评论视图点击事件
-(void)onClickShowCommment{
    if (self.isShowComment == NO) {
        [self.prePreCommentView showOrDissMissCommentWith:YES];
        [UIView animateWithDuration:0.5 animations:^{
            [self.prePreCommentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(300 + 28);
            }];
        } completion:^(BOOL finished) {
            self.isShowComment = YES;
        }];
    }
    if (self.isShowComment == YES) {
        [self.prePreCommentView showOrDissMissCommentWith:NO];
        [UIView animateWithDuration:0.5 animations:^{
            [self.prePreCommentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(35);
            }];
        } completion:^(BOOL finished) {
            self.isShowComment = NO;
        }];
    }
}

-(void)checkMorCommment{
    RCCommentViewController *commentViewController = [[RCCommentViewController alloc]init];
    commentViewController.acModel = self.activitymodel;
    commentViewController.title = @"评论详情";
    [self.navigationController pushViewController:commentViewController animated:YES];
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
