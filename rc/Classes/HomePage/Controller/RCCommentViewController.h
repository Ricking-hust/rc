//
//  RCCommentViewViewController.h
//  rc
//
//  Created by 余笃 on 16/7/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCCommentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *commetnTableView;

@end
