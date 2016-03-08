//
//  CZCityView.m
//  rc
//
//  Created by AlanZhang on 16/1/25.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZCityView.h"
#import "Masonry.h"

@implementation CZCityView

- (id)initName:(NSString *)cityName WithImageString:(NSString *)imageString
{
    if (self = [super init])
    {
        self.cityBtn = [[UIButton alloc]init];
        self.locationImage = [[UIImageView alloc]init];
        self.locationImage.tag = 11;
        self.locationImage.hidden = YES;
        self.cityNameLabel = [[UILabel alloc]init];
        [self.cityNameLabel setTag:10];
        [self addSubview:self.cityBtn];
        [self addSubview:self.locationImage];
        [self addSubview:self.cityNameLabel];
        self.locationImage.image = [UIImage imageNamed:@"location"];
        [self.cityBtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
        [self.cityBtn.layer setCornerRadius:10];
        self.cityNameLabel.font = [UIFont systemFontOfSize:15];
        [self.cityBtn setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
        self.cityNameLabel.text = cityName;
    }

    return self;
}
- (void)setConstraints
{
    CGFloat selfW = 80;
    CGFloat btnW = selfW;
    CGFloat btnH = self.cityBtn.imageView.image.size.height;
    
    [self.cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    [self.locationImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cityNameLabel.mas_left).offset(-6);
        make.top.equalTo(self.cityBtn.mas_bottom).with.offset(22/2);
        make.size.mas_equalTo(self.locationImage.image.size);
    }];
    [self.cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cityBtn.mas_centerX).offset(-4);
        make.top.equalTo(self.locationImage);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(18);
    }];
}
@end
