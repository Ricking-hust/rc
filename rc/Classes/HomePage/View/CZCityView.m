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

+ (instancetype)cityView
{
    CZCityView *cityView = [[CZCityView alloc]init];
    cityView.cityBtn = [[UIButton alloc]init];
    cityView.locationImage = [[UIImageView alloc]init];
    cityView.locationImage.tag = 11;
    cityView.cityNameLabel = [[UILabel alloc]init];
    [cityView.cityNameLabel setTag:10];
    [cityView addSubview:cityView.cityBtn];
    [cityView addSubview:cityView.locationImage];
    [cityView addSubview:cityView.cityNameLabel];
    
    [cityView.cityBtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [cityView.cityBtn.layer setCornerRadius:10];
    cityView.cityNameLabel.font = [UIFont systemFontOfSize:15];

    return cityView;
}
- (void)setConstraints
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGFloat cityViewW = rect.size.width * 0.21;
    CGFloat cityViewH = rect.size.width * 0.30;
    CGFloat btnW = cityViewW;
    CGFloat btnH = cityViewW;
    CGSize loactionImgSize = self.locationImage.image.size;
    CGSize labelSize = [self.cityNameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.left.and.top.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(cityViewW, cityViewH));
    }];
    
    [self.cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.size.mas_equalTo(CGSizeMake(btnW, btnH));
    }];
    [self.locationImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cityBtn.mas_left).with.offset(10);
        make.top.equalTo(self.cityBtn.mas_bottom).with.offset(22/2);
        make.size.mas_equalTo(loactionImgSize);
    }];
    [self.cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationImage.mas_right).with.offset(10/2);
        make.top.equalTo(self.locationImage);
        make.size.mas_equalTo(labelSize);
    }];
}
@end
