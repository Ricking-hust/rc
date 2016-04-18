//
//  CZActivityInfoViewController.m
//  rc
//
//  Created by AlanZhang on 16/1/15.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZActivityInfoViewController.h"
#import "ActivityModel.h"
#import "Masonry.h"
#import "CZTimeCell.h"
#import "CZActivityInfoCell.h"
#import "CZRemindMeView.h"
#import "RemindManager.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationSlide.h"
#import "UIImageView+WebCache.h"
#import "UINavigationBar+Awesome.h"
#import "UIImageView+LBBlurredImage.h"
#import "UIColor+YDAddition.h"
#import "MBProgressHUD.h"
#import "RCBarButton.h"
#import "RCBarButtonView.h"
#import "RCReleaseCell.h"
//ShareSDK-------------------------------------------
#import <ShareSDK/ShareSDK.h>
//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>

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

@property (nonatomic, strong) UIButton *collectionBtn;
@property (nonatomic, strong) UIButton *addToSchedule;
@property (nonatomic, strong) RCBarButtonView *barButtonView;

@property (nonatomic, strong) MBProgressHUD    *HUD;
@property (nonatomic, strong) NSString *isCollect;
@property (nonatomic, strong) NSString *planId;
@property (nonatomic, strong) NSMutableArray *plAlarm;
@property (nonatomic, strong) ActivityModel *activitymodel;
@property (nonatomic, assign) CGFloat acHtmlHeight;
@property (nonatomic, copy) NSURLSessionDataTask* (^getActivityBlock)();
@property (nonatomic, strong) UIWebView *webView;

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

#pragma mark - view

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didShowActivityInfo) name:@"getActivityInfo" object:nil];
    [self createSubViews];
    self.collectionBtn.hidden = YES;
    self.addToSchedule.hidden = YES;
    [self configureBlocks];
    self.getActivityBlock();
    //设置导航栏
    [self setNavigation];
//    UIImageView *imge = [[UIImageView alloc]init];
//    [self.view addSubview:imge];
//    NSURL *url = [NSURL URLWithString:@"http://img.myrichang.com/upload/2016-04-09_10:53:52_d41d8cd98f00b204e9800998ecf8427e.png"];
//    UIImage *imagea = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
//    imge.image = imagea;
//    [imge mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.centerY.equalTo(self.view);
//        make.size.mas_equalTo(imagea.size);
//    }];
    
}
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
- (void)didShowActivityInfo
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionBtn.hidden = NO;
    self.addToSchedule.hidden = NO;
    //设置tableView头
    [self layoutHeaderImageView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.isCollect = self.activitymodel.acCollect;
    [self setCollectionBtnStyle];
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
                    p{padding-left:5px;font-size:13px;padding-right:5px;line-height:150%}\
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

-(NSString *)isCollect{
    if (!_isCollect) {
        _isCollect = @"0";
    }
    return _isCollect;
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
    }else if(section == 2)
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen]bounds].size.width, 60.0/2)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 60, 30)];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"发布者";
        label.textColor = textcolor;
        [view addSubview:label];
      
    }else if (section == 3)
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen]bounds].size.width, 60.0/2)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 60, 30)];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"主讲人";
        label.textColor = textcolor;
        [view addSubview:label];
    }else
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen]bounds].size.width, 60.0/2)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 60, 30)];
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"更多内容";
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
    
    return 5;
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
            RCReleaseCell *cell = [[RCReleaseCell alloc]init];
            [self setCellValue:cell AtIndexPath:indexPath];
            [cell setSubViewsConstraint];
            
            return cell;
        }
            break;
        case 3:
        {//主讲人
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *acIntroduce = [[UILabel alloc]init];
            [cell addSubview:acIntroduce];
            //对cell的控件进行赋值
            [acIntroduce setText:self.activitymodel.acDesc];
            acIntroduce.font = [UIFont systemFontOfSize:FONTSIZE];
            acIntroduce.numberOfLines = 0;
            //对cell的控件进行布局
            
            CGSize maxSize = CGSizeMake(kScreenWidth - 30, MAXFLOAT);
            CGSize size = [self sizeWithText:self.activitymodel.acDesc maxSize:maxSize fontSize:FONTSIZE];
            [acIntroduce mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(cell.mas_centerX);
                make.centerY.equalTo(cell.mas_centerY);
                make.width.mas_equalTo((int)size.width+1);
                make.height.mas_equalTo((int)size.height+1);
            }];
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
                /* 忽略点击效果 */
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            return cell;
        }
            break;
    }
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
        return 60;
    }else if (indexPath.section == 3)
    {
        return [self heightForSpeakerCell];
    }else
    {
        return self.webView.frame.size.height;
    }
}
- (CGFloat)heightForSpeakerCell
{//主讲人Cell的高度
    CGSize maxSize = CGSizeMake(kScreenWidth - 20, MAXFLOAT);
    CGSize size = [self sizeWithText:self.activitymodel.acDesc maxSize:maxSize fontSize:FONTSIZE];
    return (int)size.height + 2*PADDING;
}
- (CGFloat)heightForAcInfoCell
{
    CGSize maxSize = CGSizeMake(kScreenWidth - 55, MAXFLOAT);
    CGSize placeSize = [self sizeWithText:self.activitymodel.acPlace maxSize:maxSize fontSize:FONTSIZE];
    CGSize scaleSize = [self sizeWithText:self.activitymodel.acSize maxSize:maxSize fontSize:FONTSIZE];
    CGSize paySize = [self sizeWithText:self.activitymodel.acPay maxSize:maxSize fontSize:FONTSIZE];
    return (int)placeSize.height + (int)scaleSize.height + (int)paySize.height + 3 + 4 *PADDING;
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
    NSLog(@"webViewDidStartLoad");
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
    //NSLog(@"R:%f,G:%f,B:%f,A:%f,H:%f,S:%f,BHSL:%f,AHSL:%f",red,green,blue,alpha,h,s,b,aHSL);
    CGFloat h2 = h+0.5,b2 = b+0.5;
    if (h2>1) {
        h2 -=1;
    }
    if (b2>1) {
        b2 -=1;
    }
    NSLog(@"H2:%f",h2);
    UIColor *textColor = [UIColor colorWithHue:h2 saturation:s brightness:b2 alpha:aHSL];
    self.acTittleLabel.textColor = textColor;
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
    self.collectionBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    self.addToSchedule = [UIButton buttonWithType:UIButtonTypeCustom];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor =[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tableView];
    [self.bottomView addSubview:self.collectionBtn];
    [self.bottomView addSubview:self.addToSchedule];
    
    [self.collectionBtn addTarget:self action:@selector(onClickCollection) forControlEvents:UIControlEventTouchUpInside];
    [self.addToSchedule addTarget:self action:@selector(onClickAdd) forControlEvents:UIControlEventTouchUpInside];
    
    [self.addToSchedule setTitle:@"加入行程" forState:UIControlStateNormal];
    [self.addToSchedule setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:130.0/255.0  blue:5.0/255.0  alpha:1.0]];

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
    
    //add collectionBtn constraints
    [self.collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(kScreenWidth * 0.33);
        make.height.mas_equalTo(50);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth * 0.33, 50));
    }];
    
    //add addToSchedule constriants
    [self.addToSchedule mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.collectionBtn.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(50);
    }];
    
}

-(void)setCollectionBtnStyle
{
    
    if ([self.isCollect isEqualToString:@"0"]) {
        [self.collectionBtn setImage:[UIImage imageNamed:@"collectionNormal"] forState:UIControlStateNormal];
        [self.collectionBtn setImage:[UIImage imageNamed:@"collectionSelected"] forState:UIControlStateHighlighted];
        [self.collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
        [self.collectionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {
        [self.collectionBtn setImage:[UIImage imageNamed:@"collectionSelected"] forState:UIControlStateNormal];
        [self.collectionBtn setImage:[UIImage imageNamed:@"collectionNormal"] forState:UIControlStateHighlighted];
        [self.collectionBtn setTitle:@"已收藏" forState:UIControlStateNormal];

    }
    [self.collectionBtn setTitleColor:[UIColor colorWithRed:38.0/255.0 green:40.0/255.0 blue:50.0/255.0 alpha:0.8] forState:UIControlStateNormal];
    self.collectionBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    self.collectionBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
}


- (void)setNavigation
{
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    //设置导航标题栏
    UILabel *titleLabel     = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font         = [UIFont systemFontOfSize:18];
    titleLabel.textColor    = [UIColor  whiteColor];
    titleLabel.textAlignment= NSTextAlignmentCenter;
    titleLabel.text = @"活动介绍";
    self.navigationItem.titleView = titleLabel;
    
//    //设置导航栏的左侧按钮
//    self.barButtonView = [[RCBarButtonView alloc]initWithFrame:CGRectMake(0, 0, 250, 30)];
//    [self.barButtonView setSubView];
//    [self.barButtonView.button addTarget:self action:@selector(backToForwardViewController) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithCustomView:self.barButtonView];
//    [self.navigationItem setLeftBarButtonItem:leftButton];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon_white"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    left.tintColor = [UIColor whiteColor];
    [self.navigationItem setLeftBarButtonItem:left];
    

#pragma mark - 顶部右侧分享按键
    UIImage *image =[UIImage imageNamed:@"shareIcon"];
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [shareButton setImage:image forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(didShare:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithCustomView:shareButton];
    [self.navigationItem setRightBarButtonItem:rightButton];
    [rightButton setTintColor:[UIColor whiteColor]];

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

- (void)didShare:(id)sender
{
    //1、创建分享参数
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:self.activitymodel.acDesc
                                       defaultContent:@"日常"
                                                image:[ShareSDK imageWithUrl:self.activitymodel.acPoster]
                                                title:self.activitymodel.acTitle
                                                  url:[NSString stringWithFormat:@"http://myrichang.com/activity.php?id=%@",self.activitymodel.acID]
                                          description:self.activitymodel.acTitle
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
    
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
    
    if ([DataManager manager].user.isLogin) {
        if ([self.isCollect isEqualToString:@"0"]) {
            [[DataManager manager] setActivityCollectWithUserID:[userDefaults objectForKey:@"userId"] acId:self.activityModelPre.acID opType:@"1" success:^(NSString *msg) {
                self.isCollect = @"1";
                [self.collectionBtn setImage:[UIImage imageNamed:@"collectionSelected"] forState:UIControlStateNormal];
                [self.collectionBtn setImage:[UIImage imageNamed:@"collectionNormal"] forState:UIControlStateHighlighted];
                [self.collectionBtn setTitle:@"已收藏" forState:UIControlStateNormal];
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
                [self.collectionBtn setImage:[UIImage imageNamed:@"collectionNormal"] forState:UIControlStateNormal];
                [self.collectionBtn setImage:[UIImage imageNamed:@"collectionSelected"] forState:UIControlStateHighlighted];
                [self.collectionBtn setTitle:@"收藏" forState:UIControlStateNormal];
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
    } else {
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.label.text = @"请登录";
        [self.HUD hideAnimated:YES afterDelay:0.6];
    }
    
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
                self.HUD.label.text = @"加入行程成功~(≧▽≦)/~";
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
                    self.HUD.label.text = @"加入行程提醒成功";
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
-(void)displayInfo
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //创建三个任务
    NSBlockOperation *operationA = [NSBlockOperation blockOperationWithBlock:^{
        [self configureBlocks];
        self.getActivityBlock();
        
        
    }];
    
    NSBlockOperation *operationB = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"task reflesh UI");
        
    }];
    
    NSBlockOperation *operationC = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"task c");
        //[self performSelectorOnMainThread:@selector(refleshUI) withObject:nil waitUntilDone:YES];
        self.view.backgroundColor = [UIColor whiteColor];
        //设置tableView头
        [self layoutHeaderImageView];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.isCollect = self.activitymodel.acCollect;
        [self setCollectionBtnStyle];
        //对tableView头进行赋值
        [self setTableViewHeader];
        [self.tableView reloadData];
    }];
    
    //设置三个任务相互依赖
    // operationB 任务依赖于 operationA
    [operationB addDependency:operationA];
    // operationC 任务依赖于 operationB
    [operationC addDependency:operationB];
    [operationC addDependency:operationA];
    
    
    //添加操作到队列中（自动异步执行任务，并发）
    [queue addOperation:operationA];
    [queue addOperation:operationB];
    [queue addOperation:operationC];
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
