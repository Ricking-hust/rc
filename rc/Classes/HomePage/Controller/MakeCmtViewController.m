//
//  MakeCmtViewController.m
//  rc
//
//  Created by 余笃 on 16/7/23.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "MakeCmtViewController.h"
#import "UINavigationBar+Awesome.h"
#import "Masonry.h"
#import "MBProgressHUD.h"
#define MAXLENGTH   200

@interface MakeCmtViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UIView *textViewSuperView;
@property (nonatomic, strong) UITextView *commmentTextView;
@property (nonatomic, strong) UILabel *textLimintLabel;

@property (nonatomic, strong) MBProgressHUD    *HUD;

@end

@implementation MakeCmtViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:self.commmentTextView];
    [self setNavigation];
    [self createSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建首页子控件
- (void)createSubViews{
    self.textViewSuperView = [[UIView alloc]init];
    self.commmentTextView  = [[UITextView alloc]init];
    self.textLimintLabel   = [[UILabel alloc]init];
    
    [self.view addSubview:self.textViewSuperView];
    [self.textViewSuperView addSubview:self.commmentTextView];
    [self.textViewSuperView addSubview:self.textLimintLabel];
    
    self.textViewSuperView.backgroundColor = [UIColor whiteColor];
    [self.textViewSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64+10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo([[UIScreen mainScreen]bounds].size.width * 0.38);
    }];
#pragma mark - test
    
    self.commmentTextView.userInteractionEnabled = YES;
    
    self.commmentTextView.scrollEnabled = YES;    //当文字超过视图的边框时是否允许滑动，默认为“YES”
    self.commmentTextView.editable = YES;        //是否允许编辑内容，默认为“YES”
    self.commmentTextView.delegate = self;       //设置代理方法的实现类
    self.commmentTextView.font=[UIFont fontWithName:@"Arial" size:14.0]; //设置字体名字和字体大小;
    self.commmentTextView.returnKeyType = UIReturnKeyDone;//return键的类型
    self.commmentTextView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    self.commmentTextView.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
    self.commmentTextView.textColor = [UIColor blackColor];
    self.commmentTextView.text = @"请输入评论";//设置显示的文本内容
    self.commmentTextView.alpha = 0.5;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.commmentTextView.font = [UIFont systemFontOfSize:13];
    
    [self.commmentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.textViewSuperView);
        make.height.mas_equalTo([[UIScreen mainScreen]bounds].size.width * 0.3);
    }];
    self.textLimintLabel.text = @"200字以内";
    self.textLimintLabel.alpha = 0.5;
    self.textLimintLabel.font = [UIFont systemFontOfSize:12];
    self.textLimintLabel.tintColor = [UIColor colorWithRed:38.0/255.0 green:40.0/255.0 blue:50.0/255.0 alpha:1.5];
    CGSize liminteLabelSize = [self sizeWithText:self.textLimintLabel.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:12];
    [self.textLimintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.bottom.equalTo(self.textViewSuperView).offset(-5);
        make.size.mas_equalTo(CGSizeMake(liminteLabelSize.width +1, liminteLabelSize.height+1));
    }];
    
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
    titleLabel.textColor    = themeColor;
    titleLabel.textAlignment= NSTextAlignmentCenter;
    titleLabel.text = @"评论详情";
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    left.tintColor = themeColor;
    [self.navigationItem setLeftBarButtonItem:left];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(makeIssue)];
    right.tintColor = themeColor;
    [self.navigationItem setRightBarButtonItem:right];
    
}
#pragma mark - textView代理
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
        return NO;
    }
    
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.commmentTextView.text isEqualToString:@"请输入评论"]) {
        self.commmentTextView.text = @"";
        self.commmentTextView.alpha = 1.0;
        self.commmentTextView.font = [UIFont systemFontOfSize:14];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.text = @"请输入评论";
        textView.alpha = 0.5;
    }
}

// 监听文本改变
- (void)textViewEditChanged:(NSNotification *)obj{
    
    UITextView *textView = self.commmentTextView;
    
    NSString *toBeString = textView.text;
    NSString *lang = self.textInputMode.primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"])
    {
        UITextRange *selectedRange = [textView markedTextRange];
        if (!selectedRange)
        {
            if (toBeString.length > MAXLENGTH)
            {
                textView.text = [toBeString substringToIndex:MAXLENGTH];
            }
        }else
        {
            
        }
    }else
    {
        if (toBeString.length > MAXLENGTH)
        {
            textView.text = [toBeString substringToIndex:MAXLENGTH];
        }
    }
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGFloat heigth = [self heightForString:self.commmentTextView andWidth:rect.size.width - 8];
    self.commmentTextView.contentSize = CGSizeMake(0, heigth+8);
    NSRange range = NSMakeRange([self.commmentTextView.text length]- 1, 1);
    [self.commmentTextView scrollRangeToVisible:range];
}
/**
 * @method 获取指定宽度width的字符串在UITextView上的高度
 * @param textView 待计算的UITextView
 * @param Width 限制字符串显示区域的宽度
 * @result float 返回的高度
 */
- (CGFloat) heightForString:(UITextView *)textView andWidth:(float)width{
    CGSize sizeToFit = [textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return sizeToFit.height;
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.commmentTextView resignFirstResponder];
}


- (void)backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)makeIssue{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.view addSubview:self.HUD];
    [self.HUD showAnimated:YES];
    [[DataManager manager] putFeedBackWithUserId:[userDefaults objectForKey:@"userId"] fbMail:[userDefaults objectForKey:@"userMail"] fbPhone:[userDefaults objectForKey:@"userPhone"] fbContent:self.commmentTextView.text success:^(NSString *msg) {
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.label.text = @"评论成功";
        [self.HUD hideAnimated:YES afterDelay:0.6];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.label.text = @"网络出现了点小问题。。。";
        [self.HUD hideAnimated:YES afterDelay:0.6];
        NSLog(@"Error:%@",error);
    }];
    [self.commmentTextView resignFirstResponder];
}

@end
