//
//  CZMyActivityViewContoller.h
//  rc
//
//  Created by AlanZhang on 16/2/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZMyActivityViewContoller : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView  *tableView;

@end
