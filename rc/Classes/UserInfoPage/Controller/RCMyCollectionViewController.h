//
//  RCMyCollectionViewController.h
//  rc
//
//  Created by AlanZhang on 16/5/21.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCMyCollectionViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView  *tableView;
@end
