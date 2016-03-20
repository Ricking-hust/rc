//
//  RCRightTableView.m
//  rc
//
//  Created by AlanZhang on 16/3/20.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCRightTableView.h"
#import "RCColumnTableView.h"
@implementation RCRightTableView
- (void)reloadData
{
    [super reloadData];
    if (self.contentSize.height != 0)
    {
//        NSLog(@"right contentSize %f",self.contentSize.height);
        RCColumnTableView *rc = (RCColumnTableView *)self.superview;
        [rc.tableViewSate setValue:@"YES" forKey:@"rightTableView"];
    }
}
@end
