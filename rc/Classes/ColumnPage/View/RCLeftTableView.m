//
//  RCLeftTableView.m
//  rc
//
//  Created by AlanZhang on 16/3/20.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCLeftTableView.h"
#import "RCColumnTableView.h"
@implementation RCLeftTableView
- (void)reloadData
{
    [super reloadData];
    if (self.contentSize.height != 0)
    {
//        NSLog(@"left contentSize %f",self.contentSize.height);
        RCColumnTableView *rc = (RCColumnTableView *)self.superview;
        [rc.tableViewSate setValue:@"YES" forKey:@"leftTableView"];
    }
}
@end
