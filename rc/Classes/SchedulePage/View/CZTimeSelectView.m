//
//  CZTimeSelectView.m
//  rc
//
//  Created by AlanZhang on 16/2/11.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZTimeSelectView.h"
#import "Masonry.h"
#define FONTSIZE    14  //字体大小

@interface CZTimeSelectView ()
@property (nonatomic, strong) UILabel *year;
@property (nonatomic, strong) UILabel *month;
@property (nonatomic, strong) UILabel *day;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UIView *segment;


@end

@implementation CZTimeSelectView

+ (instancetype)selectView
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGFloat heigth = rect.size.width * 0.8;
    CZTimeSelectView *view = [[CZTimeSelectView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, heigth)];
    view.backgroundColor = [UIColor whiteColor];
    
    view.pickView  = [[UIPickerView alloc]init];
    view.pickView.tag = 10;

    [view addSubview:view.pickView];
    
    view.year = [[UILabel alloc]init];
    view.month = [[UILabel alloc]init];
    view.day = [[UILabel alloc]init];
    view.time = [[UILabel alloc]init];
    view.segment = [[UIView alloc]init];
    view.OKbtn = [[UIButton alloc]init];
    
    
    [view addSubview:view.year];
    [view addSubview:view.month];
    [view addSubview:view.day];
    [view addSubview:view.time];
    [view addSubview:view.segment];
    [view addSubview:view.OKbtn];
    [view setConstraints];
    return view;
}

- (void)setConstraints
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGFloat topPaddingRelativeToSuper = 20;
    CGFloat leftPaddingRelativeToSuper = rect.size.width * 0.14;
    CGSize size = [self setLabelStyle:self.year WithContent:@"年"];
    [self.year mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(topPaddingRelativeToSuper);
        make.left.equalTo(self.mas_left).with.offset(leftPaddingRelativeToSuper);
        make.size.mas_equalTo(size);
       
    }];
    size = [self setLabelStyle:self.month WithContent:@"月"];
    [self.month mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.year.mas_top);
        make.left.equalTo(self.year.mas_right).with.offset(rect.size.width  * 0.19);
        make.size.mas_equalTo(size);
    }];
    size = [self setLabelStyle:self.day WithContent:@"日"];
    [self.day mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.year.mas_top);
        make.left.equalTo(self.month.mas_right).with.offset(rect.size.width  * 0.179);
        make.size.mas_equalTo(size);
    }];
    size = [self setLabelStyle:self.time WithContent:@"时间"];
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.year.mas_top);
        make.left.equalTo(self.day.mas_right).with.offset(rect.size.width  * 0.15);
        make.size.mas_equalTo(size);
    }];
    
    [self.pickView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.year.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.size.mas_equalTo(CGSizeMake(rect.size.width, rect.size.width *0.52));
    }];
    
    self.segment.backgroundColor = [UIColor colorWithRed:122.0/255.0 green:122.0/255.0 blue:122.0/255.0 alpha:0.5];
    
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pickView.mas_bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(@6);
    }];
    
    self.OKbtn.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];
    [self.OKbtn setTitle:@"确  定" forState:UIControlStateNormal];
    [self.OKbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.OKbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.segment.mas_bottom);
        make.bottom.right.equalTo(self);
    }];
}

//设置标签的样式
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
