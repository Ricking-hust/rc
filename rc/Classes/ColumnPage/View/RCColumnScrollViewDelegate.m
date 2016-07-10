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
        self.toolScrollView = [[UIScrollView alloc]init];
        self.device = IPhone5;
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
        //to do here -----------------------------------
        CGFloat padding = kScreenWidth * 0.07;
        if (self.device == IPhone5)
        {
            if ([button.titleLabel.text isEqualToString:@"人文"] && button.selected == YES)
            {
                [self.toolScrollView setContentOffsetX:padding + 30];
                
            }
            if ([button.titleLabel.text isEqualToString:@"其他"] && button.selected == YES)
            {
                [self.toolScrollView setContentOffsetX:(padding + 30) *2];
                
            }
            if ([button.titleLabel.text isEqualToString:@"综合"] && button.selected == YES)
            {
                [self.toolScrollView setContentOffsetX:0];
            }
            if ([button.titleLabel.text isEqualToString:@"互联网"] && button.selected == YES)
            {
                [self.toolScrollView setContentOffsetX:0];
            }
        }else if (self.device == IPhone6)
        {
            if ([button.titleLabel.text isEqualToString:@"人文"] && button.selected == YES)
            {
                [self.toolScrollView setContentOffsetX:27.5];
                
            }
            if ([button.titleLabel.text isEqualToString:@"其他"] && button.selected == YES)
            {
                [self.toolScrollView setContentOffsetX:(padding + 30) + 27.5];
                
            }
            if ([button.titleLabel.text isEqualToString:@"综合"] && button.selected == YES)
            {
                [self.toolScrollView setContentOffsetX:0];
            }
            if ([button.titleLabel.text isEqualToString:@"互联网"] && button.selected == YES)
            {
                [self.toolScrollView setContentOffsetX:0];
            }
        }else
        {
            if ([button.titleLabel.text isEqualToString:@"其他"] && button.selected == YES)
            {
                [self.toolScrollView setContentOffsetX:padding + 30];
                
            }
            if ([button.titleLabel.text isEqualToString:@"综合"] && button.selected == YES)
            {
                [self.toolScrollView setContentOffsetX:0];
            }
        }

    }
}
- (void)isToolButtonSelected:(UIButton *)btn
{
    for (int i = 0; i < self.toolButtonArray.count; ++i)
    {
        UIButton *button = self.toolButtonArray[i];
        //UIView *view = button.superview;
        //UIView *line = [view viewWithTag:12];
        //line.hidden = YES;
        button.selected = NO;
    }
    btn.selected = YES;
    //UIView *view = btn.superview;
    //UIView *line = [view viewWithTag:12];
    //line.hidden = NO;
}
@end
