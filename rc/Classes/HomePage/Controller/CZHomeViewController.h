//
//  CZHomeViewController.h
//  rc
//
//  Created by AlanZhang on 16/1/20.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

@interface CZHomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate>
@property (nonatomic,strong) CityModel *ctmodel;
@property (strong, nonatomic) UIView *searchView;
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong) CLLocationManager *locationManager;
@end
