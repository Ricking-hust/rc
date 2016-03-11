//
//  CZTableView.m
//  rc
//
//  Created by AlanZhang on 16/3/10.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZTableView.h"

@implementation CZTableView


- (void)reloadData
{
    [super reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ContentSize" object:self];
}
@end
