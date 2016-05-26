//
//  CZCityView.m
//  rc
//
//  Created by AlanZhang on 16/1/25.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZCityView.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@implementation CZCityView

- (id)initName:(NSString *)cityName WithImageString:(NSString *)imageString isLocate:(BOOL)isLocate
{
    if (self = [super init])
    {
        self.cityView = [[UIImageView alloc]init];
        self.locationImage = [[UIImageView alloc]init];
        self.locationImage.tag = 11;
        if (isLocate) {
            self.locationImage.hidden = NO;
        } else {
            self.locationImage.hidden = YES;
        }
        self.cityNameLabel = [[UILabel alloc]init];
        [self.cityNameLabel setTag:10];
        [self addSubview:self.cityView];
        [self addSubview:self.locationImage];
        [self addSubview:self.cityNameLabel];
        self.locationImage.image = [UIImage imageNamed:@"location"];
        [self.cityView.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
        [self.cityView.layer setCornerRadius:10];
        self.cityNameLabel.font = [UIFont systemFontOfSize:15];
        [self.cityView sd_setImageWithURL:[NSURL URLWithString:imageString] placeholderImage:[UIImage imageNamed:@"Beijing_Icon"]];
        self.cityNameLabel.text = cityName;
    }

    return self;
}
- (void)setConstraints
{
    CGFloat selfW = 80;
    CGFloat btnW = selfW;
    CGFloat btnH = self.cityView.image.size.height;
    
    [self.cityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    [self.locationImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cityNameLabel.mas_left).offset(-6);
        make.top.equalTo(self.cityView.mas_bottom).with.offset(22/2);
        make.size.mas_equalTo(self.locationImage.image.size);
    }];
    [self.cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.cityView.mas_centerX).offset(-4);
        make.top.equalTo(self.locationImage);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(18);
    }];
}
@end
