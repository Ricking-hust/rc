//
//  CityCollectionViewCell.h
//  rc
//
//  Created by 余笃 on 16/5/17.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CZCityView.h"
@class CityModel;
@interface CityCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *cityImage;
@property (nonatomic,strong) UIImageView *locateImage;
@property (strong, nonatomic) UILabel *cityName;
@property (nonatomic,strong) CZCityView *ctView;

@property (nonatomic,strong) CityModel *ctmodel;

-(void)setCityViewWithCityModel:(CityModel *)ctmodel;

@end