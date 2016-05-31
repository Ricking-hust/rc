//
//  CZMyReleseViewController.h
//  rc
//
//  Created by AlanZhang on 16/2/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZMyReleseViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *superOfButtons;
@property (nonatomic, strong) UIButton *checkedButton;
@property (nonatomic, strong) UIButton *willCheckButton;
@property (nonatomic, strong) UIView *lineDownOfWillCheckButton;
@property (nonatomic, strong) UIView *lineDownOfCheckButton;

@end
