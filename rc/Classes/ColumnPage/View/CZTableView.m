//
//  CZTableView.m
//  rc
//
//  Created by AlanZhang on 16/3/10.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZTableView.h"
#import "RCColumnTableView.h"
@implementation CZTableView

- (void)reloadData
{
    [super reloadData];
    
    if (self.contentSize.height != 0)
    {
        RCColumnTableView *rcColumn = (RCColumnTableView *)self.superview;
        if (self.tag == 11)
        {//左边tableView
            NSLog(@"left contentSize %f",self.contentSize.height);
            [self.contentSizeDelegate passTableView:self];
            
        }else
        {
            NSLog(@"right contentSize %f",self.contentSize.height);
            [self.contentSizeDelegate passTableView:self];
            
        }
    }


}
@end
