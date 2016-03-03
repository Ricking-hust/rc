//
//  CZUpView.m
//  rc
//
//  Created by AlanZhang on 16/3/2.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZUpView.h"
#define FONTSIZE    14  //字体大小
@implementation CZUpView

- (id)init
{
    if (self = [super init])
    {
        self.themeView  = [[UIView alloc]init];
        self.tagImgView = [[UIImageView alloc]init];
        UILabel *label = [[UILabel alloc]init];
        self.themeLabel = label;
        self.themeNameLabel = [[UILabel alloc]init];
        self.themeNameLabel.font = [UIFont systemFontOfSize:FONTSIZE];
        self.img = [[UIImageView alloc]init];
        self.segLine = [[UIView alloc]init];
        self.segLine.backgroundColor = [UIColor redColor];
        
        [self addSubview:self.themeView];
        [self.themeView addSubview:self.themeLabel];
        [self.themeView addSubview:self.tagImgView];
        [self.themeView addSubview:self.themeNameLabel];
        [self.themeView addSubview:self.img];
        [self.themeView addSubview:self.segLine];
       
    }
    self.backgroundColor = [UIColor whiteColor];
    return self;
}
- (void)setThemeLabel:(UILabel *)themeLabel
{
    //行程主题
    _themeLabel = themeLabel;
    _themeLabel.text = @"行程主题";
    _themeLabel.alpha = 0.8;
    _themeLabel.font = [UIFont systemFontOfSize:FONTSIZE];
}

@end
