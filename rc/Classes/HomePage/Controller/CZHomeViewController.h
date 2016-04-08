//
//  CZHomeViewController.h
//  rc
//
//  Created by AlanZhang on 16/1/20.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZHomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) CityModel *ctmodel;
@property (strong, nonatomic) UIView *searchView;
@property (strong, nonatomic) UITableView *tableView;
@end
