//
//  RCTableView.h
//  rc
//
//  Created by AlanZhang on 16/3/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCDisplayScheduleDelegate.h"
@class RCScrollView;
@interface RCTableView : UITableView<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *planListRanged;
@property (nonatomic, strong) NSMutableArray *scArray;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) RCScrollView *timeNodeSV;
@property  (nonatomic, weak) id<RCDisplayScheduleDelegate> showdDelegate;
@end
