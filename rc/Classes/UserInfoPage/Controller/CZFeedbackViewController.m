//
//  CZFeedbackViewController.m
//  rc
//
//  Created by AlanZhang on 16/2/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZFeedbackViewController.h"
#import "Masonry.h"
#define MAXLENGTH   5

@interface CZFeedbackViewController() <UITextViewDelegate>
@property (nonatomic, strong) UIView *textViewSuperView;
@property (nonatomic, strong) UITextView *feedbackTextView;
@property (nonatomic, strong) UILabel *textLimintLabel;
@property (nonatomic, strong) UIButton *commintButton;
@end
@implementation CZFeedbackViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"建议反馈";
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    //注册通知,确定contentTextView的text的字数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewEditChanged:) name:UITextViewTextDidChangeNotification object:self.feedbackTextView];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
    [self createSubViews];
}
- (void)backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createSubViews
{
    self.textViewSuperView = [[UIView alloc]init];
    self.feedbackTextView  = [[UITextView alloc]init];
    self.textLimintLabel   = [[UILabel alloc]init];
    self.commintButton     = [[UIButton alloc]init];
    
    [self.view addSubview:self.textViewSuperView];
    [self.textViewSuperView addSubview:self.feedbackTextView];
    [self.textViewSuperView addSubview:self.textLimintLabel];
    [self.view addSubview:self.commintButton];
    
    self.textViewSuperView.backgroundColor = [UIColor whiteColor];
    [self.textViewSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64+10);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo([[UIScreen mainScreen]bounds].size.width * 0.38);
    }];
#pragma mark - test
    
    self.feedbackTextView.userInteractionEnabled = YES;
    
    self.feedbackTextView.scrollEnabled = YES;    //当文字超过视图的边框时是否允许滑动，默认为“YES”
    self.feedbackTextView.editable = YES;        //是否允许编辑内容，默认为“YES”
    self.feedbackTextView.delegate = self;       //设置代理方法的实现类
    self.feedbackTextView.font=[UIFont fontWithName:@"Arial" size:14.0]; //设置字体名字和字体大小;
    self.feedbackTextView.returnKeyType = UIReturnKeyDone;//return键的类型
    self.feedbackTextView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    self.feedbackTextView.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
    self.feedbackTextView.textColor = [UIColor blackColor];
    self.feedbackTextView.text = @"请输入你对日常的建议";//设置显示的文本内容
    self.feedbackTextView.alpha = 0.5;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.feedbackTextView.font = [UIFont systemFontOfSize:13];

    [self.feedbackTextView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    self.commintButton.layer.cornerRadius = 5.0f;
    self.commintButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];
    self.commintButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.commintButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.commintButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.commintButton addTarget:self action:@selector(commintFeedback) forControlEvents:UIControlEventTouchUpInside];
    [self.commintButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textViewSuperView.mas_bottom).with.offset(15);
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(65, 30));
    }];
}
- (void)commintFeedback
{
    [self.feedbackTextView resignFirstResponder];
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
    if ([self.feedbackTextView.text isEqualToString:@"请输入你对日常的建议"]) {
        self.feedbackTextView.text = @"";
        self.feedbackTextView.alpha = 1.0;
        self.feedbackTextView.font = [UIFont systemFontOfSize:14];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""])
    {
        textView.text = @"请输入你对日常的建议";
        textView.alpha = 0.5;
    }
}

// 监听文本改变
- (void)textViewEditChanged:(NSNotification *)obj{
    
    UITextView *textView = self.feedbackTextView;
    
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
    CGFloat heigth = [self heightForString:self.feedbackTextView andWidth:rect.size.width - 8];
    self.feedbackTextView.contentSize = CGSizeMake(0, heigth+8);
    NSRange range = NSMakeRange([self.feedbackTextView.text length]- 1, 1);
    [self.feedbackTextView scrollRangeToVisible:range];
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
    [self.feedbackTextView resignFirstResponder];
}
@end
