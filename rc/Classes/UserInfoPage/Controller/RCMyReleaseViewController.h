//
//  RCMyReleaseViewController.h
//  rc
//
//  Created by AlanZhang on 16/5/23.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCMyReleaseViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *superOfButtons;
@property (nonatomic, strong) UIButton *releasedButton;
@property (nonatomic, strong) UIButton *checkingButton;
@property (nonatomic, strong) UIButton *notPassButton;
@property (nonatomic, strong) UIView *lineDownOfReleasedButton;
@property (nonatomic, strong) UIView *lineDownOfCheckingButton;
@property (nonatomic, strong) UIView *lineDownOfNotPassButton;
@end
