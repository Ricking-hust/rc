//
//  CZCityViewController.h
//  rc
//
//  Created by AlanZhang on 16/1/25.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CZCityView;
@interface CZCityViewController : UIViewController
@property (nonatomic, assign) City city;
@property (nonatomic, strong) CZCityView *beijing;
@property (nonatomic, strong) CZCityView *shanghai;
@property (nonatomic, strong) CZCityView *guangzhou;
@property (nonatomic, strong) CZCityView *wuhan;
@property (nonatomic, strong) UIView *bgView;


@end
