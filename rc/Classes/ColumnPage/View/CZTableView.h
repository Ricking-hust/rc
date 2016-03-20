//
//  CZTableView.h
//  rc
//
//  Created by AlanZhang on 16/3/10.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCTableVieContentSizeDelegate.h"
@interface CZTableView : UITableView
@property (nonatomic, weak) id<RCTableVieContentSizeDelegate> contentSizeDelegate;
@end
