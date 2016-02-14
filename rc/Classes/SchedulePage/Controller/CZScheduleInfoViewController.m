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

@property (strong, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *strTheme;
@property (copy, nonatomic) NSString *strTime;
@property (copy, nonatomic) NSString *strContent;
@property (copy, nonatomic) NSString *strRemindTime;
@end

@implementation CZScheduleInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"行程详情";
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
#pragma mark - 测试数据
    self.image = [UIImage imageNamed:@"businessIcon"];
    self.strTheme = @"出差";
    self.strTime = @"2012年12月12日 15:00";
    self.strContent = @"OS 是苹果公司为其移动产品开发的操作系统。它主要给 iPhone、iPod touch、iPad 以及 Apple TV 使用.";
    self.strRemindTime = @"提前一天";
    
    UIBarButtonItem *rigthItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    [self.navigationItem setRightBarButtonItem:rigthItem];
    
    UIImage *image = [UIImage imageNamed:@"backIcon"];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    [self createSubViews];

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
#pragma mark - 创建子控件
- (void) createSubViews
{
    
    [self createBgView];
    [self createTagImage];
    
    [self createScThemeLabel];
    [self createScTheme];
    
    [self createScTimeLabel];
    [self createScTime];
    
    [self createScContentLabel];
    [self createScContent];
    
    [self createScRemindTimeLabel];
    [self createScRemindTime];

}
- (void)createBgView
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    self.bgView = [[UIView alloc]init];
    //设置背景图片------------------------
    UIImage *image = [UIImage imageNamed:@"bg_background2"];
    self.bgView.layer.contents = (id) image.CGImage;    // 背景透明
    self.bgView.layer.backgroundColor = [UIColor clearColor].CGColor;
    [self.view addSubview:self.bgView];

    CGFloat bgViewW = rect.size.width * 0.9;            //父视图的宽
    CGFloat topPadding = bgViewW * 0.12;
    CGSize scContentSize = [self sizeWithText:self.strContent maxSize:CGSizeMake(rect.size.width * 0.55, MAXFLOAT) fontSize:FONTSIZE];

    CGSize labelSize = [self sizeWithText:self.strRemindTime maxSize:CGSizeMake(rect.size.width * 0.55, MAXFLOAT) fontSize:FONTSIZE];;
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(40+64);
        make.width.mas_equalTo(bgViewW);
        make.height.mas_equalTo(scContentSize.height + labelSize.height * 3 + topPadding*2 + 3*12);
    }];

}
- (void)createTagImage
{
    self.tagImage = [[UIImageView alloc]init];
#pragma mark - 测试数据
    self.tagImage.image = self.image;
    [self.bgView addSubview:self.tagImage];
    [self.tagImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).with.offset(-self.tagImage.image.size.height/2);
        make.centerX.equalTo(self.bgView);
        make.size.mas_equalTo(self.tagImage.image.size);
    }];
    
}
- (void)createScThemeLabel
{
    self.scThemeLabel = [[UILabel alloc]init];
    CGSize size = [self setLabelStyle:self.scThemeLabel WithContent:@"行程主题:"];
    [self.bgView addSubview:self.scThemeLabel];
    
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGFloat bgViewW = rect.size.width * 0.9;            //父视图的宽
    CGFloat topPadding = bgViewW * 0.12;
    [self.scThemeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).with.offset(20);
        make.top.equalTo(self.bgView.mas_top).with.offset(topPadding);
        make.size.mas_equalTo(CGSizeMake(size.width+1, size.height+1));
    }];
}
- (void)createScTheme
{
    self.scTheme = [[UILabel alloc]init];
    [self.bgView addSubview:self.scTheme];
#pragma mark - 测试数据
    CGSize size = [self setLabelStyle:self.scTheme WithContent:self.strTheme];
    [self.scTheme mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scThemeLabel.mas_right).with.offset(5);
        make.top.equalTo(self.scThemeLabel.mas_top).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(size.width+1, size.height+1));
    }];
}
- (void)createScTimeLabel
{
    self.scTimeLabel = [[UILabel alloc]init];
    [self.bgView addSubview:_scTimeLabel];
    CGSize size = [self setLabelStyle:self.scTimeLabel WithContent:@"提醒时间:"];
    
    [self.scTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scThemeLabel.mas_bottom).with.offset(PADDING);
        make.left.equalTo(self.scThemeLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width+1, size.height+1));
    }];

}
- (void)createScTime
{
    self.scTime = [[UILabel alloc]init];
    [self.bgView addSubview:self.scTime];
    CGSize size = [self setLabelStyle:self.scTime WithContent:self.strTime];
    [self.scTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scTimeLabel.mas_top);
        make.left.equalTo(self.scTimeLabel.mas_right).with.offset(5);
        make.size.mas_equalTo(CGSizeMake(size.width+1, size.height+1));
    }];

}
- (void)createScContentLabel
{
    self.scContentLabel = [[UILabel alloc]init];
    [self.bgView addSubview:self.scContentLabel];

    CGSize size = [self setLabelStyle:self.scContentLabel WithContent:@"行程内容:"];
    [self.scContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scTimeLabel.mas_bottom).with.offset(PADDING);
        make.left.equalTo(self.scThemeLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(size.width+1, size.height+1));
    }];

}
- (void)createScContent
{
    self.scContent = [[UILabel alloc]init];
    [self.bgView addSubview:self.scContent];
#pragma mark - 测试数据
    CGSize size = [self setLabelStyle:self.scContent WithContent:self.strContent];
    [self.scContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scContentLabel.mas_right).with.offset(5);
        make.top.equalTo(self.scContentLabel.mas_top);
        make.size.mas_equalTo(CGSizeMake(size.width+1, size.height+1));
    }];

}
- (void)createScRemindTimeLabel
{
    self.scRemindTimeLabel = [[UILabel alloc]init];
    [self.bgView addSubview:self.scRemindTimeLabel];
    CGSize size = [self setLabelStyle:self.scRemindTimeLabel WithContent:@"提醒时间:"];
    [self.scRemindTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scThemeLabel.mas_left);
        make.top.equalTo(self.scContent.mas_bottom).with.offset(PADDING);
        make.size.mas_equalTo(CGSizeMake(size.width+1, size.height+1));
    }];

}
- (void)createScRemindTime
{
    self.scRemindTime = [[UILabel alloc]init];
    [self.bgView addSubview:self.scRemindTime];
#pragma mark - 测试数据
    CGSize size = [self setLabelStyle:self.scRemindTime WithContent:self.strRemindTime];
    [self.scRemindTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scRemindTimeLabel.mas_right).with.offset(5);
        make.top.equalTo(self.scRemindTimeLabel).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(size.width+1, size.height+1));
    }];

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
