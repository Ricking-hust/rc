//
//  CZScheduleInfoViewController.m
//  rc
//
//  Created by AlanZhang on 16/2/6.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZScheduleInfoViewController.h"
#import "Masonry.h"
#import "CZUpdateScheduleViewController.h"
#import "CZScheduleViewController.h"
#import "PlanModel.h"
#import "CZTimeNodeCell.h"
#import "CZTimeTableViewDelegate.h"

#define FONTSIZE    14  //字体大小
#define PADDING     5

@interface CZScheduleInfoViewController ()

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIImageView *tagImage;

@property (strong, nonatomic) UILabel *scThemeLabel;
@property (strong, nonatomic) UILabel *scTheme;

@property (strong, nonatomic) UILabel *scTimeLabel;
@property (strong, nonatomic) UILabel *scTime;

@property (strong, nonatomic) UILabel *scContentLabel;
@property (strong, nonatomic) UILabel *scContent;

@property (strong, nonatomic) UILabel *scRemindTimeLabel;
@property (strong, nonatomic) UILabel *scRemindTime;

@end

@implementation CZScheduleInfoViewController
- (NSArray *)scArray
{
    if (!_scArray)
    {
        _scArray = [[NSArray alloc]init];
    }
    return _scArray;
}
- (NSMutableArray *)planListRanged
{
    if (!_planListRanged)
    {
        _planListRanged = [[NSMutableArray alloc]init];
    }
    return _planListRanged;
}
- (UITableView *)timeNodeTableView
{
    if (!_timeNodeTableView)
    {
        _timeNodeTableView = [[UITableView alloc]init];
    }
    return _timeNodeTableView;
}
- (void)createSubView
{
    self.bgView = [[UIView alloc]init];
    self.tagImage = [[UIImageView alloc]init];
    self.scThemeLabel = [[UILabel alloc]init];
    self.scTheme = [[UILabel alloc]init];
    self.scTimeLabel = [[UILabel alloc]init];
    self.scTime = [[UILabel alloc]init];
    self.scContentLabel = [[UILabel alloc]init];
    self.scContent = [[UILabel alloc]init];
    self.scRemindTimeLabel = [[UILabel alloc]init];
    self.scRemindTime = [[UILabel alloc]init];
    self.deleteBtn = [[UIButton alloc]init];
    [self.deleteBtn addTarget:self action:@selector(deleteSC) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 删除行程
- (void)deleteSC
{
    NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:self.scArray];
    [tempArray removeObjectAtIndex:self.scIndex];

    if (tempArray.count == 0)
    {
        [self.planListRanged removeObjectAtIndex:self.timeNodeIndex];
        [self.timeNodeTableView reloadData];
        long int count = self.navigationController.viewControllers.count;
        CZScheduleViewController *sc = self.navigationController.viewControllers[count - 2];
        UITableViewCell *cell = self.timeNodeTableView.visibleCells.firstObject;
        if ([cell isKindOfClass:[CZTimeNodeCell class]])
        {
            sc.scIndex = self.timeNodeTableView.visibleCells.firstObject.tag;
            self.scArray = self.planListRanged[cell.tag];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"timeNode" object:self.planListRanged];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scArray" object:self.scArray];
        }else
        {
            self.scArray = nil;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"scArray" object:self.scArray];
        }
        
    }else
    {
        [self.planListRanged removeObjectAtIndex:self.timeNodeIndex];
        self.scArray = [[NSArray alloc]initWithArray:tempArray];
        [self.planListRanged insertObject:self.scArray atIndex:self.timeNodeIndex];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"scArray" object:self.scArray];
    }

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setStateOfCurrentCell:(CZTimeNodeCell *)cell
{

    cell.selectedPoint.hidden = NO;
    
    [cell.upLineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(cell.selectedPoint.mas_top).offset(-4);
    }];
    
    [cell.downLineView mas_updateConstraints:^(MASConstraintMaker *make){
        make.top.equalTo(cell.selectedPoint.mas_bottom).offset(4);
    }];
    
    [cell layoutIfNeeded];
}
- (void)didDisplayInfo
{
    PlanModel *model = self.scArray[self.scIndex];
    self.tagImage.image = [self getTagImageFormNString:model.themeName];
    self.scTheme.text = model.themeName;
    self.scTime.text = model.planTime;
    self.scContent.text = model.planContent;
    self.scRemindTime.text = model.plAlarmOne;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigation];
    [self createSubView];
    [self addSubViewToView];
    [self didDisplayInfo];
    [self addConstraint];

}
- (void)addSubViewToView
{
    self.scThemeLabel.font = [UIFont systemFontOfSize:FONTSIZE];
    self.scTheme.font = [UIFont systemFontOfSize:FONTSIZE];
    self.scTimeLabel.font = [UIFont systemFontOfSize:FONTSIZE];
    self.scTime.font = [UIFont systemFontOfSize:FONTSIZE];
    self.scContentLabel.font = [UIFont systemFontOfSize:FONTSIZE];
    self.scContent.font = [UIFont systemFontOfSize:FONTSIZE];
    self.scRemindTimeLabel.font = [UIFont systemFontOfSize:FONTSIZE];
    self.scRemindTime.font = [UIFont systemFontOfSize:FONTSIZE];
    self.scContent.numberOfLines = 0;
    self.scRemindTime.numberOfLines = 0;
    
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.tagImage];
    [self.bgView addSubview:self.scThemeLabel];
    [self.bgView addSubview:self.scTheme];
    [self.bgView addSubview:self.scTimeLabel];
    [self.bgView addSubview:self.scTime];
    [self.bgView addSubview:self.scContentLabel];
    [self.bgView addSubview:self.scContent];
    [self.bgView addSubview:self.scRemindTimeLabel];
    [self.bgView addSubview:self.scRemindTime];
    [self.view addSubview:self.deleteBtn];
}
- (void)addConstraint
{
    [self addTagImageConstraint];
    [self addscThemeLabelConstraint];
    [self addscThemeConstraint];
    [self addscTimeLabelConstraint];
    [self addsctimeConstraint];
    [self addscContentlabelCosntraint];
    [self addscContentConstraint];
    [self addscRemindTimeLabelConstraint];
    [self addscRemindTimeConstraint];
    [self addBgViewConstraint];
    [self addDeleteBtnConstraint];
}
- (void)addTagImageConstraint
{
    [self.tagImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).with.offset(-self.tagImage.image.size.height/2);
        make.centerX.equalTo(self.bgView);
        make.size.mas_equalTo(self.tagImage.image.size);
    }];
}
- (void)addscThemeLabelConstraint
{
    CGSize size = [self setLabelStyle:self.scThemeLabel WithContent:@"行程主题:"];
    [self.scThemeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).with.offset(20);
        make.top.equalTo(self.bgView.mas_top).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(size.width+1, size.height+1));
    }];
    
}
- (void)addscThemeConstraint
{
    CGSize size = [self setLabelStyle:self.scTheme WithContent:self.scTheme.text];
    [self.scTheme mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scThemeLabel.mas_right).with.offset(5);
        make.top.equalTo(self.scThemeLabel.mas_top).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(size.width+1, size.height+1));
    }];
    
}
- (void)addscTimeLabelConstraint
{
    CGSize size = [self setLabelStyle:self.scTimeLabel WithContent:@"提醒时间:"];
    [self.scTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scThemeLabel.mas_bottom).with.offset(PADDING);
        make.left.equalTo(self.scThemeLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width+1, size.height+1));
    }];
}
- (void)addsctimeConstraint
{
    CGSize size = [self setLabelStyle:self.scTime WithContent:self.scTime.text];
    [self.scTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scTimeLabel.mas_top);
        make.left.equalTo(self.scTimeLabel.mas_right).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(size.width+1, size.height+1));
    }];
}
- (void)addscContentlabelCosntraint
{
    CGSize size = [self setLabelStyle:self.scContentLabel WithContent:@"行程内容:"];
    [self.scContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scTimeLabel.mas_bottom).with.offset(PADDING);
        make.left.equalTo(self.scThemeLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width+1, size.height+1));
    }];
    
}
- (void)addscContentConstraint
{
    CGSize size = [self setLabelStyle:self.scContent WithContent:self.scContent.text];
    [self.scContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scContentLabel.mas_right).with.offset(5);
        make.top.equalTo(self.scContentLabel.mas_top);
        make.size.mas_equalTo(CGSizeMake(size.width+1, size.height+1));
    }];
}
- (void)addscRemindTimeLabelConstraint
{
    CGSize size = [self setLabelStyle:self.scRemindTimeLabel WithContent:@"提醒时间:"];
    [self.scRemindTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scThemeLabel.mas_left);
        make.top.equalTo(self.scContent.mas_bottom).with.offset(PADDING);
        make.size.mas_equalTo(CGSizeMake(size.width+1, size.height+1));
    }];
}
- (void)addscRemindTimeConstraint
{
    CGSize size = [self setLabelStyle:self.scRemindTime WithContent:self.scRemindTime.text];
    [self.scRemindTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scRemindTimeLabel.mas_right).with.offset(5);
        make.top.equalTo(self.scRemindTimeLabel).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(size.width+1, size.height+1));
    }];
}
- (void)addDeleteBtnConstraint
{
    self.deleteBtn.layer.cornerRadius = 2.0f;
    self.deleteBtn.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:64.0/255.0 blue:0 alpha:1.0];
    [self.deleteBtn setTitle:@"删除按钮" forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.deleteBtn];
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom).offset(10);
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self.view.frame.size.width - 40);
    }];
}
- (void)addBgViewConstraint
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    //设置背景图片------------------------
    UIImage *image = [UIImage imageNamed:@"bg_background2"];
    self.bgView.layer.contents = (id) image.CGImage;    // 背景透明
    self.bgView.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    CGFloat bgViewW = rect.size.width * 0.9;            //父视图的宽
    CGFloat topPadding = bgViewW * 0.12;
    CGSize scContentSize = [self sizeWithText:self.scContent.text maxSize:CGSizeMake(rect.size.width * 0.55, MAXFLOAT) fontSize:FONTSIZE];
    
    CGSize scRemindTimeSize = [self sizeWithText:self.scRemindTime.text maxSize:CGSizeMake(rect.size.width * 0.55, MAXFLOAT) fontSize:FONTSIZE];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(40+64);
        make.width.mas_equalTo(bgViewW);
        make.height.mas_equalTo(scContentSize.height + scRemindTimeSize.height * 3 + topPadding*2 + 20);
    }];
    
}
- (UIImage *)getTagImageFormNString:(NSString *)str
{
    if ([str isEqualToString:@"运动"])
    {
        return [UIImage imageNamed:@"sportSmallIcon"];
    }else if ([str isEqualToString:@"约会"])
    {
        return [UIImage imageNamed:@"appointmentSmallIcon"];
    }else if ([str isEqualToString:@"出差"])
    {
        return [UIImage imageNamed:@"businessSmallIcon"];
    }else if ([str isEqualToString:@"会议"])
    {
        return [UIImage imageNamed:@"meetingSmallIcon"];
    }else if ([str isEqualToString:@"购物"])
    {
        return [UIImage imageNamed:@"shoppingSmallIcon"];
    }else if ([str isEqualToString:@"娱乐"])
    {
        return [UIImage imageNamed:@"entertainmentSmallIcon"];
    }else if ([str isEqualToString:@"聚会"])
    {
        return [UIImage imageNamed:@"partSmallIcon"];
    }else
    {
        return [UIImage imageNamed:@"otherSmallIcon"];
    }
    
}

- (void)setNavigation
{
    self.title = @"行程详情";
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    UIBarButtonItem *rigthItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    [self.navigationItem setRightBarButtonItem:rigthItem];
    
    UIImage *image = [UIImage imageNamed:@"backIcon"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
}
- (void)edit
{
    CZUpdateScheduleViewController *updateScheduleViewController = [[CZUpdateScheduleViewController alloc]init];
    updateScheduleViewController.title = @"修改行程";
    [self.navigationController pushViewController:updateScheduleViewController animated:YES];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGSize)setLabelStyle:(UILabel *)label WithContent:(NSString *)content
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    label.font = [UIFont systemFontOfSize:FONTSIZE];
    label.numberOfLines = 0;
    label.text = content;
    label.alpha = 0.8;
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


@end
