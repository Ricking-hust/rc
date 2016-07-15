//
//  RCColumnScrollViewDelegate.m
//  rc
//
//  Created by AlanZhang on 16/4/1.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCColumnScrollViewDelegate.h"

@interface RCColumnScrollViewDelegate()
@property (nonatomic, assign) int index;
@end
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
    if (decelerate)
    {
        CGFloat x = self.index * (26 + 42) + 10;
        [UIView animateWithDuration:0 animations:^{
            [self.line setFrame:CGRectMake(x, 34, 42, 1)];
        }];
    }
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.index = (scrollView.contentOffset.x + scrollView.frame.size.width / 2)/ scrollView.frame.size.width;
    if (self.toolButtonArray.count != 0)
    {
        UIButton *button = self.toolButtonArray[self.index];
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
        CGFloat x = scrollView.contentOffsetX * 42 / kScreenWidth + 10 + self.index * 26;
        [self.line setFrame:CGRectMake(x, 34, 42, 1)];
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
