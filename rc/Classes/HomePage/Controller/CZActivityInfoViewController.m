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
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationSlide.h"
#import "UIImageView+WebCache.h"
#import "UINavigationBar+Awesome.h"
#import "UIImageView+LBBlurredImage.h"
#import "MBProgressHUD.h"

#define FONTSIZE 14
#define PADDING  10 //活动详情cell 中子控件之间的垂直间距
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

@property (nonatomic, strong) MBProgressHUD    *HUD;
@property (nonatomic, strong) NSString *isCollect;
@property (nonatomic, strong) NSString *planId;
@property (nonatomic, strong) NSMutableArray *plAlarm;
@property (nonatomic, strong) ActivityModel *activitymodel;
@property (nonatomic, assign) CGFloat acHtmlHeight;
@property (nonatomic, copy) NSURLSessionDataTask* (^getActivityBlock)();
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, assign) int webViewCellRefleshIndex;
@end

@implementation CZActivityInfoViewController

- (CGFloat)acHtmlHeight
{
    if (!_acHtmlHeight) {
        _acHtmlHeight = 10;
    }
    return _acHtmlHeight;
}
- (int)webViewCellRefleshIndex
{
    if (!_webViewCellRefleshIndex)
    {
        _webViewCellRefleshIndex = 0;
    }
    return _webViewCellRefleshIndex;
}
#pragma mark - view

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSubViews];
    self.collectionBtn.hidden = YES;
    self.addToSchedule.hidden = YES;
    [self getData];

    //设置导航栏
    [self setNavigation];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)getData
{
    dispatch_queue_t queue = dispatch_queue_create("cloumn", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [self configureBlocks];
         self.getActivityBlock();
        sleep(1);
    });
    dispatch_async(queue, ^{
        sleep(0.5);
    });
    
    dispatch_barrier_async(queue, ^{

    });
    
    dispatch_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI
            //获取活动收藏情况
            if (self.activitymodel != nil)
            {
                UIWebView *wv = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
                wv.delegate = self;
                NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
                [wv loadRequest:request];
                [self.view addSubview:wv];
                
                self.view.backgroundColor = [UIColor whiteColor];
                self.collectionBtn.hidden = NO;
                self.addToSchedule.hidden = NO;
                [self createSubViews];
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


        });
    });
}
- (void)setwebViewCellH
{
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
    self.webView.delegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    //预先加载url
    [self.webView loadHTMLString:self.activitymodel.acHtml baseURL:nil];
}
- (void)cellValue:(NSNotification *)notification
{
    NSIndexSet *section = [NSIndexSet indexSetWithIndex:1];
    [self.tableView reloadSections:section withRowAnimation:UITableViewRowAnimationFade];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

-(void)setActivitymodel:(ActivityModel *)activitymodel{
    
    _activitymodel = activitymodel;

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
            static NSString *identifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell){
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
        ((CZTimeCell*)cell).timeLabel.text = self.activitymodel.acTime;
        
    }else if([cell isKindOfClass:[CZActivityInfoCell class]])
    {
        ((CZActivityInfoCell *)cell).model = self.activitymodel;
    }else
    {
        ;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 47;
        
    }else if(indexPath.section == 1)
    {
        return [self heightForAcInfoCell];
    }else
    {
        return self.webView.frame.size.height;
    }
    
}
- (CGFloat)heightForAcInfoCell
{
    CGSize maxSize = CGSizeMake(kScreenWidth - 30, MAXFLOAT);
    CGSize placeSize = [self sizeWithText:self.activitymodel.acPlace maxSize:maxSize fontSize:FONTSIZE];
    CGSize scaleSize = [self sizeWithText:self.activitymodel.acSize maxSize:maxSize fontSize:FONTSIZE];
    CGSize paySize = [self sizeWithText:self.activitymodel.acPay maxSize:maxSize fontSize:FONTSIZE];
    return placeSize.height + scaleSize.height + paySize.height + 3 + 4 *PADDING;
}
#pragma mark - UIWebView Delegate Methods
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.webViewCellRefleshIndex++;
    //获取到webview的高度
    CGFloat height = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    self.webView.frame = CGRectMake(self.webView.frame.origin.x,self.webView.frame.origin.y, kScreenWidth, height);
    
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
    [self.header setFrame:CGRectMake(0, 0, kScreenWidth, 215)];
    self.tableView.tableHeaderView = self.header;
    self.headerImageView = [[UIImageView alloc]init];
    self.headerImageView.alpha = 0.7;
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.activitymodel.acPoster] placeholderImage:[UIImage imageNamed:@"20160102.png"]];
    
    [self.header addSubview:self.headerImageView];
    [self.headerImageView setImageToBlur:self.headerImageView.image blurRadius:21 completionBlock:nil];
    [self.headerImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.header.mas_top);
        make.left.equalTo(self.header.mas_left);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(215);
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
    //对tableView头进行布局
    [self setSubViewsConstraint];
    
}
// 下拉后图片拉伸的效果方法下载这个里面
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset = scrollView.contentOffset.y;  // 偏移的y值
    if (yOffset < 0)
    {
        CGFloat totalOffset = 215 + ABS(yOffset);

        [self.headerImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.header.mas_top).offset(yOffset);
            make.left.equalTo(self.header.mas_left);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(totalOffset);

        }];
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
    
    [self.acImageView sd_setImageWithURL:[NSURL URLWithString:self.activitymodel.acPoster] placeholderImage:[UIImage imageNamed:@"20160102.png"]];
    self.acTittleLabel.text   = self.activitymodel.acTitle;
    self.acTagImageView.image = [UIImage imageNamed:@"tagImage"];
    
    NSMutableArray *Artags = [[NSMutableArray alloc]init];
    
    for (TagModel *model in self.activitymodel.tagsList.list) {
        [Artags addObject:model.tagName];
    }
    
    NSString *tags = [Artags componentsJoinedByString:@","];
    self.acTagLabel.text      = tags;
    
}

//创建子控件
- (void)createSubViews
{
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
    
    [self.addToSchedule setTitle:@"加入日程" forState:UIControlStateNormal];
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
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    //设置导航标题栏
    UILabel *titleLabel     = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.font         = [UIFont systemFontOfSize:18];
    titleLabel.textColor    = [UIColor  whiteColor];
    titleLabel.textAlignment= NSTextAlignmentCenter;
    titleLabel.text = @"活动介绍";
    self.navigationItem.titleView = titleLabel;
    
    //设置导航栏的左侧按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    leftButton.tintColor = [UIColor whiteColor];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
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
        label.font = [UIFont systemFontOfSize:12];
        label.text = @"活动详情";
        label.textColor = textcolor;
        [view addSubview:label];
    }else
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,[[UIScreen mainScreen]bounds].size.width, 60.0/2)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 60, 30)];
        label.font = [UIFont systemFontOfSize:12];
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

#pragma mark - Click Event

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
                self.HUD.label.text = @"该活动已在您的日程中(╯3╰)";
                [self.HUD hideAnimated:YES afterDelay:0.6];
            } else {
                self.planId = planId;
                self.HUD.mode = MBProgressHUDModeCustomView;
                self.HUD.label.text = @"加入日程成功~(≧▽≦)/~";
                [self.HUD hideAnimated:YES afterDelay:0.6];
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
                [[DataManager manager] addPlanWithOpType:@"2" planId:self.activitymodel.planId userId:[userDefaults objectForKey:@"userId"] themeId:@"" planTime:@"" plAlarmOne:self.plAlarm[0] plAlarmTwo:self.plAlarm[1] plAlarmThree:self.plAlarm[2] planContent:@"" acPlace:@"" success:^(NSString *msg) {
                    self.HUD.mode = MBProgressHUDModeCustomView;
                    self.HUD.label.text = @"修改提醒成功~(≧▽≦)/~";
                    [self.HUD hideAnimated:YES afterDelay:0.6];
                } failure:^(NSError *error) {
                    self.HUD.mode = MBProgressHUDModeCustomView;
                    self.HUD.label.text = @"操作失败~>_<~ ";
                    [self.HUD hideAnimated:YES afterDelay:0.6];
                    NSLog(@"Error:%@",error);
                }];
            } else {
                self.planId = planId;
                [[DataManager manager] addPlanWithOpType:@"1" planId:self.planId userId:[userDefaults objectForKey:@"userId"] themeId:@"" planTime:@"" plAlarmOne:self.plAlarm[0] plAlarmTwo:self.plAlarm[1] plAlarmThree:self.plAlarm[2] planContent:@"" acPlace:@"" success:^(NSString *msg) {
                    self.HUD.mode = MBProgressHUDModeCustomView;
                    self.HUD.label.text = @"加入日程提醒成功~(≧▽≦)/~";
                    [self.HUD hideAnimated:YES afterDelay:0.6];
                } failure:^(NSError *error) {
                    self.HUD.mode = MBProgressHUDModeCustomView;
                    self.HUD.label.text = @"操作失败~>_<~ ";
                    [self.HUD hideAnimated:YES afterDelay:0.6];
                    NSLog(@"Error:%@",error);
                }];
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
    
    BOOL isSelecte = !btn.selected;
    if (isSelecte)
    {
        btn.selected = YES;
    }else
    {
        btn.selected = NO;
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
    
    for (int i = 0; i <3; i++)
    {
        UIButton *button = btnArray[i];
        if (button.selected)
        {
            NSLog(@"选中了%@按钮",button.titleLabel.text);
            self.plAlarm[i] = @"1";
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
