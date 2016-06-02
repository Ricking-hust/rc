//
//  RCDirectView.m
//  rc
//
//  Created by 余笃 on 16/5/31.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCDirectView.h"
#import "Masonry.h"

static const int buttonSize = 41;

@implementation RCDirectView

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.hotBtn = [[UIButton alloc]init];
        self.univerBtn = [[UIButton alloc]init];
        self.besidesBtn = [[UIButton alloc]init];
        self.careChoiceBtn = [[UIButton alloc]init];
        self.hotLable = [[UILabel alloc]init];
        self.univerLable = [[UILabel alloc]init];
        self.besidesLable = [[UILabel alloc]init];
        self.careChoiceLable = [[UILabel alloc]init];
        [self addSubview:self.hotBtn];
        [self addSubview:self.univerBtn];
        [self addSubview:self.besidesBtn];
        [self addSubview:self.careChoiceBtn];
        [self addSubview:self.hotLable];
        [self addSubview:self.univerLable];
        [self addSubview:self.besidesLable];
        [self addSubview:self.careChoiceLable];
    }
    return self;
}

-(void)setSubView{
    
    UIImage *hotImage = [UIImage imageNamed:@"remen_icon"];
    [self.hotBtn setImage:hotImage forState:UIControlStateNormal];
    [self.hotBtn setImage:hotImage forState:UIControlStateHighlighted];
    self.hotLable.font = [UIFont systemFontOfSize:12];
    self.hotLable.text = @"热门";
    self.hotLable.textColor = [UIColor blackColor];
    
    UIImage *univerImage = [UIImage imageNamed:@"daxue_icon"];
    [self.univerBtn setImage:univerImage forState:UIControlStateNormal];
    [self.univerBtn setImage:univerImage forState:UIControlStateHighlighted];
    self.univerLable.font = [UIFont systemFontOfSize:12];
    self.univerLable.text = @"大学";
    self.univerLable.textColor = [UIColor blackColor];;
    
    UIImage *besidesImage = [UIImage imageNamed:@"fujin_icon"];
    [self.besidesBtn setImage:besidesImage forState:UIControlStateNormal];
    [self.besidesBtn setImage:besidesImage forState:UIControlStateHighlighted];
    self.besidesLable.font = [UIFont systemFontOfSize:12];
    self.besidesLable.text = @"附近";
    self.besidesLable.textColor = [UIColor blackColor];;
    
    UIImage *careChoiceImage = [UIImage imageNamed:@"jingxuan_icon"];
    [self.careChoiceBtn setImage:careChoiceImage forState:UIControlStateNormal];
    [self.careChoiceBtn setImage:careChoiceImage forState:UIControlStateHighlighted];
    self.careChoiceLable.font = [UIFont systemFontOfSize:12];
    self.careChoiceLable.text = @"热门";
    self.careChoiceLable.textColor = [UIColor blackColor];;
    
    [self.hotBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(kScreenWidth/8);
        make.top.equalTo(self.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(buttonSize, buttonSize));
    }];
    [self.hotLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.hotBtn.mas_centerX);
        make.top.equalTo(self.hotBtn.mas_bottom).offset(7);
    }];
    
    [self.univerBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(kScreenWidth*3/8);
        make.top.equalTo(self.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(buttonSize, buttonSize));
    }];
    [self.univerLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.univerBtn.mas_centerX);
        make.top.equalTo(self.hotBtn.mas_bottom).offset(7);
    }];
    
    [self.besidesBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(kScreenWidth*5/8);
        make.top.equalTo(self.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(buttonSize, buttonSize));
    }];
    [self.besidesLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.besidesBtn.mas_centerX);
        make.top.equalTo(self.hotBtn.mas_bottom).offset(7);
    }];
    
    [self.careChoiceBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(kScreenWidth*7/8);
        make.top.equalTo(self.mas_top).offset(15);
        make.size.mas_equalTo(CGSizeMake(buttonSize, buttonSize));
    }];
    [self.careChoiceLable mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.careChoiceBtn.mas_centerX);
        make.top.equalTo(self.hotBtn.mas_bottom).offset(7);
    }];
}

@end
