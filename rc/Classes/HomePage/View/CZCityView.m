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
    //从xib中加载subview
    NSBundle *bundle = [NSBundle mainBundle];
    //加载xib中得view
    CZCityView *cityView = [[bundle loadNibNamed:@"CZCityView" owner:nil options:nil] lastObject];

    [cityView.cityBtn.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [cityView.cityBtn.layer setCornerRadius:10];

    return cityView;
}

#pragma mark - 测试用
- (void)updateSubViewsConstraints
{
    [self.cityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    [self.locationImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cityBtn.mas_left).with.offset(-10);
        make.top.equalTo(self.cityBtn.mas_bottom).with.offset(22/2);
        
    }];
    [self.cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locationImage.mas_right).with.offset(10/2);
        make.top.equalTo(self.locationImage);
    }];

}

@end
