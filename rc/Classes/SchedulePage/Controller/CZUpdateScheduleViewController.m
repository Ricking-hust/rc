//
//  CZUpdateScheduleViewController.m
//  rc
//
//  Created by AlanZhang on 16/2/6.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZUpdateScheduleViewController.h"
#import "Masonry.h"
#import "UIViewController+LewPopupViewController.h"
#import "LewPopupViewAnimationSlide.h"
#import "CZTimeSelectView.h"
#define FONTSIZE    14  //字体大小

@interface CZUpdateScheduleViewController ()<UITextViewDelegate,UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIView *themeView;
@property (strong, nonatomic) UILabel *themeLabel;
@property (strong, nonatomic) UIImageView *tagimageView;
@property (strong, nonatomic) UILabel *tagLabel;
@property (strong, nonatomic) UIButton *moreTagButton;

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UITextView *contentTextView;
@property (strong, nonatomic) UILabel *limitedLabel;
@property (strong, nonatomic) UIView *segmentView;

@property (strong, nonatomic) UIView *timeView;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *timeInfo;
@property (strong, nonatomic) UIButton *moreTimeButton;
@property (strong, nonatomic) UIView *segmentViewReletiveToRv;

@property (strong, nonatomic) UIView *remindView;
@property (strong, nonatomic) UILabel *remindLabel;
@property (strong, nonatomic) UILabel *remindInfo;
@property (strong, nonatomic) UIButton *moreRemindButton;

@property (strong, nonatomic) UIButton *deleteScheduleButton;

@property (strong, nonatomic) UIView *timeSelectView;

#pragma mark - 测试数据
@property (copy, nonatomic) NSString *strThemelabel;
@property (copy, nonatomic) NSString *strContent;
@property (copy, nonatomic) NSString *strTime;
@property (copy, nonatomic) NSString *strRemind;
@property (copy, nonatomic) NSString *strTagImg;

#pragma mark - 选择器数据
@property (strong, nonatomic) NSMutableArray *years;
@property (strong, nonatomic) NSMutableArray *months;
@property (strong, nonatomic) NSMutableArray *days;
@property (strong, nonatomic) NSMutableArray *times;

@end

@implementation CZUpdateScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#pragma mar - 测试数据
    self.strThemelabel = @"出差";
    self.strContent = @"你是我的小呀小苹果，怎么爱你都不嫌多，啊啊啊啊啊你你欠工工工工";
    self.strTime = @"2012年12月12日22日 22:22";
    self.strRemind = @"提前一天";
    self.strTagImg = @"businessSmallIcon";
    
    self.title = @"修改行程";
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    //设置导航栏的左右按钮
    [self setNavigationBarItem];
    [self createSubViews];
    
}

#pragma mark - 懒加载选择器的数据
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
- (NSArray *)times
{
    if (!_times)
    {
        _times = [[NSMutableArray alloc]init];
        NSString *temp;
        for (int i = 0; i < 12; ++i)
        {
            if (i < 9)
            {
                temp = [NSString stringWithFormat:@"12:0%d", i+1];
                [_times addObject:temp];
            }else
            {
                temp = [NSString stringWithFormat:@"12:%d",i+1];
                [_times addObject:temp];          
            }

        }
    }
    return _times;
}
#pragma mark - 创建子控件
- (void)createSubViews
{
    [self createThemeView];
    
    [self createContentView];
}
- (void)createThemeView
{
    CGRect screenRect = [[UIScreen mainScreen]bounds];
    self.themeView = [[UIView alloc]init];
    self.themeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.themeView];
    CGFloat themeViewH = screenRect.size.width * 0.12;            //themeView的高度
    [self.themeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(64+10);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.height.mas_equalTo(themeViewH);
        make.width.mas_equalTo(screenRect.size.width);
    }];
    
    //行程主题
    self.themeLabel = [[UILabel alloc]init];
    self.themeLabel.text = @"行程主题";
    [self.themeView addSubview:self.themeLabel];
    CGFloat leftPaddingInThemeViewOfThemeLabel = 10;
    CGSize themeLabelSize = [self setLabelStyle:self.themeLabel WithContent:self.themeLabel.text];
    self.themeLabel.alpha = 0.8;
    [self.themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.themeView);
        make.left.equalTo(self.themeView.mas_left).with.offset(leftPaddingInThemeViewOfThemeLabel);
        make.size.mas_equalTo(CGSizeMake(themeLabelSize.width+1, themeLabelSize.height+1));
    }];
    
    //themeView的下分割线
    UIView *segmentDownLine = [[UIView alloc]init];
    segmentDownLine.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0];
    segmentDownLine.alpha = 0.5;
    [self.themeView addSubview:segmentDownLine];
    [segmentDownLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.themeView.mas_left);
        make.bottom.equalTo(self.themeView.mas_bottom);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(screenRect.size.width);
    }];
    //下拉按钮,标签,行程图标
    CGFloat padding = 5;    //下拉按钮,标签,行程图标三者之间的间距
    
    self.moreTagButton = [[UIButton alloc]init];
    [self.themeView addSubview:self.moreTagButton];
    [self.moreTagButton addTarget:self action:@selector(onClickMoreTagButton) forControlEvents:UIControlEventTouchUpInside];
    [self.moreTagButton setImage:[UIImage imageNamed:@"moreTagbuttonIcon"] forState:UIControlStateNormal];
    
    CGFloat rightPaddingInThemeViewOfMoreTagButton = 10;
    [self.moreTagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.themeView);
        make.right.equalTo(self.themeView.mas_right).with.offset(-rightPaddingInThemeViewOfMoreTagButton);
        make.size.mas_equalTo(CGSizeMake(self.moreTagButton.imageView.image.size.width+10, self.moreTagButton.imageView.image.size.height));
    }];
    
    self.tagLabel = [[UILabel alloc]init];
    [self.themeView addSubview:self.tagLabel];
#pragma mark - 行程标签测试语句
    self.tagLabel.text = self.strThemelabel;
    CGSize tagLabelSize = [self setLabelStyle:self.tagLabel WithContent:self.tagLabel.text];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.themeView);
        make.right.equalTo(self.moreTagButton.mas_left).with.offset(-padding);
        make.size.mas_equalTo(CGSizeMake(tagLabelSize.width+1, tagLabelSize.height+1));
    }];
    
    self.tagimageView = [[UIImageView alloc]init];
    [self.themeView addSubview:self.tagimageView];
#pragma mark - 行程图标测试语句
    self.tagimageView.image = [UIImage imageNamed:self.strTagImg];
    [self.tagimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.themeView);
        make.right.equalTo(self.tagLabel.mas_left).with.offset(-padding);
        make.size.mas_equalTo(self.tagimageView.image.size);
    }];
    
}

- (void)createContentView
{
    CGRect screenRect = [[UIScreen mainScreen]bounds];
    self.contentView = [[UIView alloc]init];
    [self.view addSubview:self.contentView];
//    self.contentView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    CGFloat topPaddingRelativeToThemeView = 10;
    CGFloat contentViewH = screenRect.size.width * 0.12 *2 + screenRect.size.width * 0.32 + topPaddingRelativeToThemeView * 4;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.themeView.mas_bottom).with.offset(topPaddingRelativeToThemeView);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(contentViewH);
    }];

    [self createContentTextView];
    [self createLimitedLabel];
    [self createTimeView];
    [self createRemindView];
    [self createDeleteScheduleButton];
    
}
#pragma mark -  创建TextView
- (void)createContentTextView
{
    CGRect screenRect = [[UIScreen mainScreen]bounds];
    
    self.contentTextView = [[UITextView alloc]init];
    [self.contentView addSubview:self.contentTextView];
#pragma mark - test field
    self.contentTextView.backgroundColor = [UIColor whiteColor];
    
    self.contentTextView.scrollEnabled = NO;    //当文字超过视图的边框时是否允许滑动，默认为“YES”
    self.contentTextView.editable = YES;        //是否允许编辑内容，默认为“YES”
    self.contentTextView.delegate = self;       //设置代理方法的实现类
    self.contentTextView.font=[UIFont fontWithName:@"Arial" size:14.0]; //设置字体名字和字体大小;
    self.contentTextView.returnKeyType = UIReturnKeyDone;//return键的类型
    self.contentTextView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    self.contentTextView.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
    self.contentTextView.textColor = [UIColor blackColor];
    self.contentTextView.text = @"请输入行程地点+内容(40字以内)";//设置显示的文本内容
    self.contentTextView.alpha = 0.5;
    
    
    //self.contentTextView.placeholder = @"请输入行程地点+内容(40字以内)";
    
    CGFloat padding = 10;
    CGFloat contentTextFieldH = screenRect.size.width * 0.23;
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(padding);
        make.top.equalTo(self.contentView.mas_top).with.offset(padding);
        make.right.equalTo(self.contentView.mas_right).with.offset(-padding);
        make.height.mas_equalTo(contentTextFieldH);
    }];
}
- (void)createLimitedLabel
{
    self.limitedLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.limitedLabel];
    self.limitedLabel.text = @"40字";
    CGFloat padding = 10;
    CGSize LimitedLabelSize = [self setLabelStyle:self.limitedLabel WithContent:self.limitedLabel.text];
    self.limitedLabel.alpha = 0.5;
    [self.limitedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentTextView.mas_bottom).with.offset(padding);
        make.right.equalTo(self.contentTextView.mas_right);
        make.size.mas_equalTo(CGSizeMake(LimitedLabelSize.width+1, LimitedLabelSize.height+1));
    }];
    //LimitedLabel下分割线
    UIView *segmentDownLine = [[UIView alloc]init];
    [self.contentView addSubview:segmentDownLine];
    segmentDownLine.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1.0];
    segmentDownLine.alpha = 0.5;
    CGFloat paddingReletiveToLimintedLabel = 10;
    [segmentDownLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.limitedLabel.mas_bottom).with.offset(paddingReletiveToLimintedLabel);
        make.left.and.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    //下分割线下的分割视图
    self.segmentView = [[UIView alloc]init];
    [self.contentView addSubview:self.segmentView];
    self.segmentView.backgroundColor = self.view.backgroundColor;
    CGFloat segmentViewH = 10;      //分割视图的高度
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(segmentDownLine.mas_bottom);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(segmentViewH);
    }];
}
- (void)createTimeView
{
    self.timeView = [[UIView alloc]init];
    [self.contentView addSubview:self.timeView];
    self.timeView.backgroundColor = [UIColor whiteColor];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentView.mas_bottom);
        make.left.and.right.equalTo(self.contentView);
        make.height.equalTo(self.themeView.mas_height);
    }];
    
    //创建timeLabel
    self.timeLabel = [[UILabel alloc]init];
    [self.timeView addSubview:self.timeLabel];
    self.timeLabel.text = @"行程时间";
    CGFloat padding = 10;
    CGSize timeLabelSize = [self setLabelStyle:self.timeLabel WithContent:self.timeLabel.text];
    self.timeLabel.alpha = self.themeLabel.alpha;
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeView);
        make.left.equalTo(self.themeLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(timeLabelSize.width+1, timeLabelSize.height+1));
    }];
    //创建mroeTimeButton,timeInfo
    self.moreTimeButton = [[UIButton alloc]init];
    [self.timeView addSubview:self.moreTimeButton];
    [self.moreTimeButton setImage:[UIImage imageNamed:@"moreTagbuttonIcon"] forState:UIControlStateNormal];
    [self.moreTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeView);
        make.right.equalTo(self.timeView.mas_right).with.offset(-padding);
        make.size.mas_equalTo(CGSizeMake(self.moreTimeButton.imageView.image.size.width+5, self.moreTimeButton.imageView.image.size.height));
    }];
    [self.moreTimeButton addTarget:self action:@selector(onClickMoreTimeButton) forControlEvents:UIControlEventTouchUpInside];
    
    self.timeInfo = [[UILabel alloc]init];
    [self.timeView addSubview:self.timeInfo];
    CGSize timeInfoSize = [self setLabelStyle:self.timeInfo WithContent:self.strTime];
    
    [self.timeInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeView);
        make.right.equalTo(self.moreTimeButton.mas_left).with.offset(-padding);
        make.size.mas_equalTo(CGSizeMake(timeInfoSize.width+1, timeInfoSize.height+1));
    }];
    
    //创建
    self.segmentViewReletiveToRv = [[UIView alloc]init];
    [self.contentView addSubview:self.segmentViewReletiveToRv];
    self.segmentViewReletiveToRv.backgroundColor = self.view.backgroundColor;
    [self.segmentViewReletiveToRv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeView.mas_bottom);
        make.left.and.right.equalTo(self.contentView);
        make.height.mas_equalTo(padding);
    }];
    
}
- (void)createRemindView
{
    self.remindView = [[UIView alloc]init];
    [self.contentView addSubview:self.remindView];
    self.remindView.backgroundColor = [UIColor whiteColor];
    [self.remindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentViewReletiveToRv.mas_bottom);
        make.left.and.right.equalTo(self.contentView);
        make.height.equalTo(self.themeView.mas_height);
    }];
    //创建
    self.remindLabel = [[UILabel alloc]init];
    [self.remindView addSubview:self.remindLabel];
    self.remindLabel.text = @"需要提醒";
    CGSize remindLabelSize = [self setLabelStyle:self.remindLabel WithContent:self.remindLabel.text];
    self.remindLabel.alpha = self.themeLabel.alpha;
    [self.remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.remindView);
        make.left.equalTo(self.themeLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(remindLabelSize.width+1, remindLabelSize.height+1));
    }];
    
    //创建moreRemindButton,remindInfo
    self.moreRemindButton = [[UIButton alloc]init];
    [self.remindView addSubview:self.moreRemindButton];
    [self.moreRemindButton setImage:[UIImage imageNamed:@"moreTagbuttonIcon"] forState:UIControlStateNormal];
    CGFloat padding = 10;
    [self.moreRemindButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.remindView.mas_right).with.offset(-padding);
        make.centerY.equalTo(self.remindView);
        make.size.mas_equalTo(CGSizeMake(self.moreRemindButton.imageView.image.size.width+5, self.moreRemindButton.imageView.image.size.height));
    }];
    
    self.remindInfo = [[UILabel alloc]init];
    [self.remindView addSubview:self.remindInfo];
    CGSize remindInfoSize = [self setLabelStyle:self.remindInfo WithContent:self.strRemind];
    [self.remindInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.remindView);
        make.right.equalTo(self.moreRemindButton.mas_left).with.offset(-padding);
        make.size.mas_equalTo(CGSizeMake(remindInfoSize.width+1, remindInfoSize.height+1));
    }];
    
    
}
- (void)createDeleteScheduleButton
{
    CGRect screenRect = [[UIScreen mainScreen]bounds];
    self.deleteScheduleButton = [[UIButton alloc]init];
    [self.view addSubview:self.deleteScheduleButton];
    [self.deleteScheduleButton setTitle:@"删除行程" forState:UIControlStateNormal];
    [self.deleteScheduleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.deleteScheduleButton setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:79.0/255.0 blue:14.0/255.0 alpha:1.0]];
    CGFloat buttonW = screenRect.size.width * 0.85;
    CGFloat buttonH = buttonW * 0.14;
    CGFloat paddingRelativeToContentView = 20;
    [self.deleteScheduleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.contentView.mas_bottom).with.offset(paddingRelativeToContentView);
        make.size.mas_equalTo(CGSizeMake(buttonW, buttonH));
    }];
}
//设置导航栏的左右按钮
- (void)setNavigationBarItem
{
    UIImage *image = [UIImage imageNamed:@"backIcon"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    UIBarButtonItem *rigthButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(OK)];
    [self.navigationItem setRightBarButtonItem:rigthButton];
    
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
//确定修改按钮
- (void)OK
{
    
}

//更多标签按钮点击事件
- (void)onClickMoreTagButton
{

}

//提醒时间按钮点击事件
- (void)onClickMoreTimeButton
{
    CZTimeSelectView *selectView = [CZTimeSelectView selectView];
    selectView.pickView.dataSource = self;
    selectView.pickView.delegate = self;
    [selectView.OKbtn addTarget:self action:@selector(didSelectedTime:) forControlEvents:UIControlEventTouchUpInside];
    LewPopupViewAnimationSlide *animation = [[LewPopupViewAnimationSlide alloc]init];
    animation.type = LewPopupViewAnimationSlideTypeBottomBottom;
    [self lew_presentPopupView:selectView animation:animation dismissed:^{
        NSLog(@"提醒视图已弹出");
    }];
}
- (void)didSelectedTime:(UIButton *)btn
{
    UIView *view = btn.superview;
    
    NSLog(@"%@",view);
    
    UIPickerView *pickView = [view viewWithTag:10];

    long int rowYear = [pickView selectedRowInComponent:0];
    NSString *year = self.years[rowYear];
    long int rowMonth = [pickView selectedRowInComponent:1];
    NSString *month = self.months[rowMonth];
    long int rowDay = [pickView selectedRowInComponent:2];
    NSString *day = self.days[rowDay];
    long int rowTime = [pickView selectedRowInComponent:3];
    NSString *time = self.times[rowTime];
    
    NSString *detailTime = [NSString stringWithFormat:@"%@年%@月%@日%@", year, month, day, time];
    NSLog(@"%@",detailTime);
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
#pragma mark - TextView在的代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.contentTextView.text isEqualToString:@"请输入行程地点+内容(40字以内)"]) {
        self.contentTextView.text = @"";
        self.contentTextView.alpha = 1.0;
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
