//
//  RCCityViewController.h
//  rc
//
//  Created by 余笃 on 16/5/16.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityModel.h"

@interface RCCityViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,copy) NSURLSessionDataTask *(^getCityListBlock)();
@property (nonatomic,strong) UICollectionView *cityView;
@property (nonatomic,strong) CityList *ctList;
@property (nonatomic,strong) NSString *locateCityId;

@end
