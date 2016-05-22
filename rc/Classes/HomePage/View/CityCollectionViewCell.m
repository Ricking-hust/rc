//
//  CityCollectionViewCell.m
//  rc
//
//  Created by 余笃 on 16/5/17.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CityCollectionViewCell.h"
#import "Masonry.h"

@implementation CityCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

-(CityModel *)ctmodel{
    if (!_ctmodel) {
        _ctmodel = [[CityModel alloc]init];
    }
    return _ctmodel;
}

-(CZCityView *)ctView{
    if (!_ctView) {
        _ctView = [[CZCityView alloc]initName:@"暂无" WithImageString:@"location" isLocate:NO];
    }
    return _ctView;
}

-(void)setCityViewWithCityModel:(CityModel *)ctmodel{
    NSString *ctImageStr = [[NSString alloc]initWithFormat:@"http://img.myrichang.com/img/city/%@.png",ctmodel.cityID];
    self.ctView = [[CZCityView alloc]initName:ctmodel.cityName WithImageString:ctImageStr isLocate:self.ctmodel.isLocate];
    [self.ctView setConstraints];
    [self.contentView addSubview:self.ctView];
    
    [self.ctView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-22);
        make.height.mas_equalTo(80);
        make.width.mas_equalTo(80);
    }];

}

@end
