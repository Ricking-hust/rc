//
//  RCTableVieContentSizeDelegate.h
//  rc
//
//  Created by AlanZhang on 16/3/20.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RCTableVieContentSizeDelegate <NSObject>
@optional
- (void)passTableView:(id)tableView;
- (void)passLoadState:(id)tableView;
@end
