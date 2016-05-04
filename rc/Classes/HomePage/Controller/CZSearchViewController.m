//
//  CZSearchViewController.m
//  rc
//
//  Created by AlanZhang on 16/1/28.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZSearchViewController.h"
#import "Masonry.h"
#import "CZActivitycell.h"
#import "RCSearchModel.h"
#import "CZActivityInfoViewController.h"
#include <sys/sysctl.h>
#define buttonSize CGSizeMake(65, 30)
#define IPHONE5PADDING  12
#define IPHONE6PADDING  23
#define IPHONE6PLUSPADDING  30.8

@interface CZSearchViewController ()
@property (strong, nonatomic) UIView *bgView;//tag 设为10
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UIButton *rightBtn;
@property (strong, nonatomic) UIView *hotSearchView;
@property (assign, nonatomic) CurrentDevice device;
@property (assign, nonatomic) CGFloat padding;//按钮之间的间距
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *popSearchAry;
@property (nonatomic,strong) ActivityList *searchResult;
@property (nonatomic,strong) UIScrollView *searchHistoryView;
@property (nonatomic, assign) double historyHeight;
@property (nonatomic, strong) UITableView *tableView;//显示搜索结果

@property (nonatomic,copy) NSURLSessionDataTask *(^getPopSerchBlock)();
@end

@implementation CZSearchViewController

#pragma mark - get data

-(void)configureBlocks{
    @weakify(self)
    self.getPopSerchBlock = ^(){
        @strongify(self)
        return [[DataManager manager] getPopularSearchSuccess:^(NSMutableArray *popSearchList) {
            @strongify(self)
            self.popSearchAry = popSearchList;
        } failure:^(NSError *error) {
            NSLog(@"Error:%@",error);
        }];
    };
}

-(void) setPopSearchAry:(NSMutableArray *)popSearchAry{
    _popSearchAry = popSearchAry;
    
    [self addHotSearchConstraint];
}

#pragma mark - View

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    self.device = [self currentDeviceSize];
    [self configureBlocks];
    self.getPopSerchBlock();
    [self addSearchBarConstraint];
    [self initSearchHistoryViewWithAll:NO];

}
#pragma mark - Tableview 数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.searchResult.list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1 创建可重用的自定义cell
    CZActivitycell *cell = (CZActivitycell*)[CZActivitycell activitycellWithTableView:tableView];
    
    //对cell内的控件进行赋值
    [self setCellValue:cell AtIndexPath:indexPath];
    
    //对cell内的控件进行布局
    [cell setSubViewsConstraint];
    
    //2 返回cell
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}
#pragma mark - 单元格的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CZActivityInfoViewController *activityInfoViewController = [[CZActivityInfoViewController alloc]init];
    activityInfoViewController.title = @"活动介绍";
    activityInfoViewController.activityModelPre = self.searchResult.list[indexPath.row];
    [self.navigationController pushViewController:activityInfoViewController animated:YES];
    
}
//给单元格进行赋值
- (void) setCellValue:(CZActivitycell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    ActivityModel *ac = self.searchResult.list[indexPath.row];
    
    [cell.ac_poster sd_setImageWithURL:[NSURL URLWithString:ac.acPoster] placeholderImage:[UIImage imageNamed:@"20160102.png"]];
    cell.ac_title.text = ac.acTitle;
    cell.ac_time.text = ac.acTime;
    cell.ac_place.text = ac.acPlace;
    NSMutableArray *Artags = [[NSMutableArray alloc]init];
    
    for (TagModel *model in ac.tagsList.list) {
        [Artags addObject:model.tagName];
    }
    
    NSString *tags = [Artags componentsJoinedByString:@","];
    cell.ac_tags.text = tags;
    
}
- (void)onClickTagBtn:(UIButton *)btn
{
    self.searchBar.text = btn.titleLabel.text;
    [self searchBarSearchButtonClicked:self.searchBar];
}

#pragma mark - 取消
- (void)onClick:(UIButton *)btn
{
    [self.searchBar resignFirstResponder];
    [self.navigationController popToRootViewControllerAnimated:YES];
    self.navigationController.navigationBarHidden = NO;
    
}

#pragma mark - 搜索记录事件处理
- (void)didClickedHistory:(UIGestureRecognizer *)sender {
    
    UILabel *label = (UILabel *)sender.view;
    self.searchBar.text = label.text;
    [RCSearchModel addSearchHistory:self.searchBar.text];
    [self initSearchHistoryViewWithAll:NO];
    [self.searchBar resignFirstResponder];
}

-(void)didClickedAllHistory:(id)sender {
    
}

- (void)didCLickedCleanSearchHistory:(id)sender {
    
    [RCSearchModel cleanAllSearchHistory];
    [self initSearchHistoryViewWithAll:NO];
}

-(void)showAllSearchHistory:(id)sender{
    [self initSearchHistoryViewWithAll:YES];
    [self addHotSearchConstraint];
}

-(void)deleteSearchHistoryWithI:(id)sender{
    [RCSearchModel deleteSearchHistoryWithI:(int)[sender tag]];
    [self initSearchHistoryViewWithAll:YES];
}

#pragma mark - search delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *cityId = [[NSString alloc]init];
    if ([userDefaults objectForKey:@"cityId"]) {
        cityId = [userDefaults objectForKey:@"cityId"];
    } else {
        cityId = @"1";
    }
    [[DataManager manager] getActivitySearchWithKeywords:self.searchBar.text startId:@"0" num:@"10" cityId:cityId success:^(ActivityList *acList) {
        self.searchResult = acList;
        [self.tableView reloadData];
        self.tableView.hidden = NO;
    } failure:^(NSError *error) {
        NSLog(@"Error:%@",error);
    }];
    self.scrollView.hidden = YES;
    [RCSearchModel addSearchHistory:searchBar.text];
    [self initSearchHistoryViewWithAll:NO];
    [searchBar resignFirstResponder];
}
// 当搜索内容变化时，执行该方法。很有用，可以实现时实搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.scrollView.hidden = NO;
    self.tableView.hidden = YES;
    
}


#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]init];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.top.equalTo(self.bgView.mas_bottom).offset(10);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc]init];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.tag = 10;
        [self.view addSubview:_bgView];
    }
    return _bgView;
}
- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.placeholder = @"请输入搜索内容";
        
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        [_searchBar setTranslucent:YES];
        _searchBar.layer.masksToBounds = YES;

        _searchBar.layer.cornerRadius = 13.0;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, 20)];
        view.backgroundColor = [UIColor whiteColor];
        [_bgView addSubview:_searchBar];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc]init];
        [_rightBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_rightBtn];
        
    }
    return _rightBtn;
}
- (UIView *)hotSearchView
{
    if (!_hotSearchView)
    {
        _hotSearchView = [[UIView alloc]init];
        _hotSearchView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:_hotSearchView];
    }
    return _hotSearchView;
}


#pragma mark - 搜索历史界面初始化
-(void)initSearchHistoryViewWithAll:(BOOL)all{
    if (!_searchHistoryView) {
        
        _searchHistoryView =[[UIScrollView alloc]init];
        _searchHistoryView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:_searchHistoryView];
        self.searchBar.delegate=self;
    }
    
    [[_searchHistoryView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        view.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:199.0/255.0  blue:204.0/255.0  alpha:1.0];
        [_searchHistoryView addSubview:view];
    }
    
    NSArray *array = [RCSearchModel getSearchHistory];
    CGFloat imageLeft = 12.0f;
    CGFloat textLeft = 34.0f;
    CGFloat height = 44.0f;
    int historyCount;
    if (all == NO) {
        historyCount = 2;
    } else {
        historyCount = (int)array.count;
    }
    _historyHeight=height*(historyCount+1);
    //set history list
    [_searchHistoryView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView).offset(10);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(_historyHeight);
    }];
    _searchHistoryView.contentSize = CGSizeMake(kScreenWidth, _historyHeight);
    
    for (int i = 0; i < historyCount; i++) {
        
        UILabel *lblHistory = [[UILabel alloc] initWithFrame:CGRectMake(textLeft, i * height, kScreenWidth - textLeft, height)];
        lblHistory.userInteractionEnabled = YES;
        lblHistory.font = [UIFont systemFontOfSize:14];
        lblHistory.textColor = [UIColor blackColor];
        lblHistory.text = array[i];
        
        UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        leftView.left = 12;
        leftView.centerY = lblHistory.centerY;
        leftView.image = [UIImage imageNamed:@"timeIcon"];
        
        UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 14, 14)];
        rightImageView.right = kScreenWidth - 12;
        rightImageView.centerY = lblHistory.centerY;
        rightImageView.image = [UIImage imageNamed:@"deleteIcon"];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setFrame:CGRectMake(0, 0, 14, 14)];
        deleteBtn.right = kScreenWidth - 12;
        deleteBtn.centerY = lblHistory.centerY;
        [deleteBtn setTag:i];
        [deleteBtn addTarget:self action:@selector(deleteSearchHistoryWithI:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(imageLeft, (i + 1) * height, kScreenWidth-imageLeft, 0.5)];
        view.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:199.0/255.0  blue:204.0/255.0  alpha:1.0];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickedHistory:)];
        [lblHistory addGestureRecognizer:tapGestureRecognizer];
        
        [_searchHistoryView addSubview:lblHistory];
        [_searchHistoryView addSubview:leftView];
        [_searchHistoryView addSubview:rightImageView];
        [_searchHistoryView addSubview:deleteBtn];
        [_searchHistoryView addSubview:view];
    }
    
    if (all == NO) {
        if(array.count) {
            UIButton *btnShowAll = [UIButton buttonWithType:UIButtonTypeCustom];
            btnShowAll.titleLabel.font = [UIFont systemFontOfSize:14];
            [btnShowAll setTitle:@"所有搜索历史" forState:UIControlStateNormal];
            [btnShowAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnShowAll setFrame:CGRectMake(0, 2 * height, kScreenWidth, height)];
            [_searchHistoryView addSubview:btnShowAll];
            [btnShowAll addTarget:self action:@selector(showAllSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
        }
    } else {
        UIButton *btnClean = [UIButton buttonWithType:UIButtonTypeCustom];
        btnClean.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnClean setTitle:@"清除搜索历史" forState:UIControlStateNormal];
        [btnClean setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnClean setFrame:CGRectMake(0, array.count * height, kScreenWidth, height)];
        [_searchHistoryView addSubview:btnClean];
        [btnClean addTarget:self action:@selector(didCLickedCleanSearchHistory:) forControlEvents:UIControlEventTouchUpInside];
    }
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(imageLeft, (array.count + 1) * height, kScreenWidth-imageLeft, 0.5)];
        view.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:199.0/255.0  blue:204.0/255.0  alpha:1.0];
        [_searchHistoryView addSubview:view];
    }
}

- (void)hideKeyboard
{
    [self.searchBar resignFirstResponder];
}
#pragma mark - 搜索框约束
- (void)addSearchBarConstraint
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGFloat searchBarW = rect.size.width * 0.82;
    CGFloat searchBarH = 44;
    CGSize btnSize = CGSizeMake(30, 30);
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(rect.size.width, 64));
    }];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).with.offset(0);
        make.top.equalTo(self.bgView.mas_top).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(searchBarW, searchBarH));
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchBar.mas_right).with.offset(10);
        make.top.equalTo(self.searchBar.mas_top).with.offset(8);
        make.size.mas_equalTo(btnSize);
    }];
    
}
//点击空白处收起键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.searchBar resignFirstResponder];
}
#pragma mark - 热门搜索约束
- (void) addHotSearchConstraint
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.bgView.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];

    CGFloat hotSearchH = [self heigthForTagButtonsView];
    [self.hotSearchView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView.mas_left);
        make.top.equalTo(self.scrollView.mas_top).offset(_historyHeight+20);
        make.size.mas_equalTo(CGSizeMake(rect.size.width, hotSearchH+44));
    }];
    UIView *imgAndLabelView = [[UIView alloc]init];
    [self.hotSearchView addSubview:imgAndLabelView];
    [imgAndLabelView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotSearchView.mas_left);
        make.top.equalTo(self.hotSearchView.mas_top);
        make.right.equalTo(self.hotSearchView.mas_right);
        make.height.mas_equalTo(44);
    }];
    //图片
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.image = [UIImage imageNamed:@"hotIcon"];
    [imgAndLabelView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imgAndLabelView.mas_centerY);
        make.left.equalTo(imgAndLabelView.mas_left).offset(self.padding);
        make.size.mas_equalTo(imgView.image.size);
    }];
    
    //标签-热门搜索
    UILabel *label = [[UILabel alloc]init];
    label.text = @"热门搜索";
    label.textColor = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:14];
    [imgAndLabelView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imgAndLabelView.mas_centerY);
        make.left.equalTo(imgView.mas_right).with.offset(14);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    //分割线
    UIView *segView = [[UIView alloc]init];
    segView.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:199.0/255.0  blue:204.0/255.0  alpha:1.0];
    [imgAndLabelView addSubview:segView];
    [segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hotSearchView.mas_left);
        make.top.equalTo(self.hotSearchView.mas_top).with.offset(43);
        make.size.mas_equalTo(CGSizeMake(rect.size.width, 1));
    }];
    
    //添加标签按钮
    [self addTagButton];
    
}

#pragma mark - 根据设备大小添加标签按钮
- (void)addTagButton
{
    int x = 0;
    int y = 0;
    CGFloat XPading = 0;
    CGFloat YPadding = 12;
    long int count = self.popSearchAry.count;
    for (int i = 0; i < count; i++)
    {
        UIButton *btn = [[UIButton alloc]init];
        [self.hotSearchView addSubview:btn];
        [self setButton:btn WithTittle:self.popSearchAry[i]];
        [btn addTarget:self action:@selector(onClickTagBtn:) forControlEvents:UIControlEventTouchUpInside];
        if ((i) % 4 == 0 && i != 0 )
        {
            x = 0;
            YPadding = 12 * (y + 2) + (y+1) * 30;
            y++;
        }
        XPading = self.padding * (x + 1) + x * 65;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.hotSearchView.mas_left).with.offset(XPading);
            make.top.equalTo(self.hotSearchView.mas_top).with.offset(YPadding + 44);
            make.size.mas_equalTo(buttonSize);
        }];
        x++;
    }
    
}
- (CGFloat)heigthForTagButtonsView
{

    CGFloat row = self.popSearchAry.count / 4.0;
    int height = (int)row;
    if (height == row)
    {
        return (height + 1) * 12 + height * 30;
    }else
    {
        height ++ ;
        return (height + 1) * 12 + height * 30;
    }
    
}

- (void)setButton:(UIButton *)button WithTittle:(NSString *)tittle
{
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitleColor:[UIColor colorWithRed:38.0/255.0 green:40.0/255.0 blue:50.0/255.0 alpha:0.6] forState:UIControlStateNormal];
    [button.layer setBorderWidth:0.5];    //设置边界的宽度
    //设置按钮的边界颜色
    CGColorRef color = [UIColor colorWithRed:38.0/255.0 green:40.0/255.0 blue:50.0/255.0 alpha:0.5].CGColor;
    [button.layer setBorderColor:color];

    [button setTitle:tittle forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [button.layer setCornerRadius:3];   //设置圆角
    
}

//获取当前设备
- (CurrentDevice)currentDeviceSize
{
    if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 4"] ||
        [[self getCurrentDeviceModel] isEqualToString:@"iPhone 5"])
    {
        self.padding = IPHONE5PADDING;
        return IPhone5;
        
    }else if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 6"])
    {
        self.padding = IPHONE6PADDING;
        return IPhone6;
    }else
    {
        self.padding = IPHONE6PLUSPADDING;
        return Iphone6Plus;
    }
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
