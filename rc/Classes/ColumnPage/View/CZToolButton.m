//
//  CZToolButton.m
//  rc
//
//  Created by AlanZhang on 16/1/26.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZToolButton.h"
#define TITTLEFONTSIZE  15

@implementation CZToolButton

- (instancetype)initWithTittle:(NSString *)tittle
{
    if (self = [super init]) {
        [self setButton:self With:tittle];
    }
    return self;
}

- (void)setButton:(UIButton*)btn With:(NSString *)tittle
{
    //设置文本
    [btn setTitle:tittle forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:TITTLEFONTSIZE];
    UIColor *color = [UIColor colorWithRed:38.0/255.0 green:40.0/255.0 blue:50.0/255.0 alpha:0.8];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 30, 30)];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;

    //设置图片
    //[btn setBackgroundImage: forState:UIControlStateSelected];
}


//#pragma mark 去除按钮的高亮状态
//-(void)setHighlighted:(BOOL)highlighted
//{
//    NSLog(@"highligthed");
//}
//- (void) setSelected:(BOOL)selected
//{
//    NSLog(@"setSelected");
//}


@end
