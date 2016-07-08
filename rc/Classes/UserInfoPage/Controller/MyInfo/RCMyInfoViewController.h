//
//  RCPersonInfoViewController.h
//  rc
//
//  Created by AlanZhang on 16/5/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCMyInfoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView  *tableView;
@end
