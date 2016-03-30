//
//  MyTableView.m
//  rc
//
//  Created by AlanZhang on 16/3/30.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "MyTableView.h"

@implementation MyTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)reloadData
{
    [super reloadData];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"contentSize" object:self];
}
@end
