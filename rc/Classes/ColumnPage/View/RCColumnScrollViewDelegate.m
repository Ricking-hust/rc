//
//  RCColumnScrollViewDelegate.m
//  rc
//
//  Created by AlanZhang on 16/4/1.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCColumnScrollViewDelegate.h"

@implementation RCColumnScrollViewDelegate
- (id)init
{
    if (self = [super init])
    {
        self.toolButtonArray = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffsetX / kScreenWidth;
    
    if (self.toolButtonArray.count != 0)
    {
        UIButton *button = self.toolButtonArray[index];
        [self isToolButtonSelected:button];
    }
}
- (void)isToolButtonSelected:(UIButton *)btn
{
    for (int i = 0; i < self.toolButtonArray.count; ++i)
    {
        UIButton *button = self.toolButtonArray[i];
        UIView *view = button.superview;
        UIView *line = [view viewWithTag:12];
        line.hidden = YES;
        button.selected = NO;
    }
    btn.selected = YES;
    UIView *view = btn.superview;
    UIView *line = [view viewWithTag:12];
    line.hidden = NO;
}
@end
