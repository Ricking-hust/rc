//
//  RCScrollView.m
//  rc
//
//  Created by AlanZhang on 16/3/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCScrollView.h"
#import "Masonry.h"
#define Animination 0.1
#define NodeH 114
//每个节点的高度为114，即滚动114到下一个节点
@interface RCScrollView ()

@end
@implementation RCScrollView
- (id)init
{
    if (self = [super init])
    {
        self.planList = [[PlanList alloc]init];
        self.planListRanged = [[NSMutableArray alloc]init];
        self.nodeIndex = [[NSNumber alloc]initWithInt:0];
        self.currentOffsetY = 0;
        self.isUp = YES;
        self.upLine = [[UIView alloc]init];
        self.downLine = [[UIView alloc]init];
        self.point = [[UIView alloc]init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTimeNodeScrollView:) name:@"sendTimeNodeScrollView" object:nil];
    }
    return self;
}
- (void)getTimeNodeScrollView:(NSNotification *)notification
{
    self.nodeIndex = notification.object;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.isUp)
    {
        [self scrollEndDeceleratingUp:scrollView ToTimeNode:scrollView.contentOffsetY];
    }else
    {
        [self scrollEndDeceleratingDown:scrollView ToTimeNode:scrollView.contentOffsetY];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        if (self.isUp)
        {
            [self scrollEndDraggingUp:scrollView ToTimeNode:scrollView.contentOffsetY];
        }else
        {
            [self scrollEndDraggingDown:scrollView ToTimeNode:scrollView.contentOffsetY];
        }


    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.currentOffsetY < scrollView.contentOffsetY)
    {
        self.isUp = YES;
    }else
    {
        self.isUp = NO;
    }
}
//EndDecelerating上拉
- (void)scrollEndDeceleratingUp:(UIScrollView *)scrollView ToTimeNode:(CGFloat)offsetY
{
    int index = offsetY / NodeH;
    CGFloat location = (offsetY-[self.nodeIndex intValue] * NodeH) / NodeH;
    CGFloat sub = location - (int)location;
    if (sub < 0.5)
    {
        index = [self.nodeIndex intValue] + (int)location;
        
    }else
    {
        index = [self.nodeIndex intValue] + (int)(location+1);
        
    }
    if (index > self.planListRanged.count-1)
    {
        index = (int)self.planListRanged.count-1;
    }
    self.nodeIndex = [[NSNumber alloc]initWithInt:index];
    [UIView animateWithDuration:0.5 animations:^{
        [scrollView setContentOffsetY:([self.nodeIndex intValue]) * NodeH];
        [self restoreNodeState];
        [self setNodeState];
    }];
    //保存当前的Y方向滑动距离
    self.currentOffsetY = ([self.nodeIndex intValue]) * NodeH;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refleshSC" object:self.nodeIndex];
}
//EndDecelerating下拉
- (void)scrollEndDeceleratingDown:(UIScrollView *)scrollView ToTimeNode:(CGFloat)offsetY
{
    if (offsetY < 0)
    {
        self.nodeIndex = [[NSNumber alloc]initWithInt:0];
    }else
    {
        CGFloat location = (self.currentOffsetY - offsetY)/NodeH;
        int index = [self.nodeIndex intValue];
        index = index - (int)location;
        CGFloat sub = location - (int)location;
        if (sub < 0.5)
        {
            ;
        }else
        {
            index-- ;
            if (index < 0)
            {
                index = 0;
            }
            
        }
        
        self.nodeIndex = [[NSNumber alloc]initWithInt:index];
    }
    [UIView animateWithDuration:0.5 animations:^{
        [scrollView setContentOffsetY:([self.nodeIndex intValue]) * NodeH];
        [self restoreNodeState];
        [self setNodeState];
    }];
    //保存当前的Y方向滑动距离
    self.currentOffsetY = ([self.nodeIndex intValue]) * NodeH;

    [[NSNotificationCenter defaultCenter]postNotificationName:@"refleshSC" object:self.nodeIndex];
}
//EndDraggingDown下拉
- (void)scrollEndDraggingDown:(UIScrollView *)scrollView ToTimeNode:(CGFloat)offsetY
{
    int index = [self.nodeIndex intValue];
    if (offsetY < 0)
    {
        self.nodeIndex = [[NSNumber alloc]initWithInt:0];
    }else
    {
        CGFloat location = (self.currentOffsetY - offsetY)/NodeH;
        CGFloat sub = location - (int)location;
        if (sub < 0.5)
        {
            index = [self.nodeIndex intValue] - (int)location;
        }else
        {
            if ((int)location <= 0)
            {
                index--;
            }else
            {
                index = [self.nodeIndex intValue] - (int)location-1;
            }
            
            if (index < 0)
            {
                index = 0;
            }
        }

        self.nodeIndex = [[NSNumber alloc]initWithInt:index];

    }
    [UIView animateWithDuration:0.5 animations:^{
        [scrollView setContentOffsetY:([self.nodeIndex intValue]) * NodeH];
        [self restoreNodeState];
        [self setNodeState];
    }];
    //保存当前的Y方向滑动距离
    self.currentOffsetY = ([self.nodeIndex intValue]) * NodeH;

    [[NSNotificationCenter defaultCenter]postNotificationName:@"refleshSC" object:self.nodeIndex];
}
//EndDraggingDown上拉
- (void)scrollEndDraggingUp:(UIScrollView *)scrollView ToTimeNode:(CGFloat)offsetY
{
    int index = offsetY / NodeH;
    CGFloat location = (offsetY-[self.nodeIndex intValue] * NodeH) / NodeH;
    CGFloat sub = location - (int)location;
    if (sub < 0.5)
    {
        ;
    }else
    {
        index = [self.nodeIndex intValue] + (int)location +1;
        
    }
    if (index > self.planListRanged.count-1)
    {
        index = (int)self.planListRanged.count-1;
    }
    self.nodeIndex = [[NSNumber alloc]initWithInt:index];
    [UIView animateWithDuration:0.5 animations:^{
        [scrollView setContentOffsetY:([self.nodeIndex intValue]) * NodeH];
        [self restoreNodeState];
        [self setNodeState];
    }];
    //保存当前的Y方向滑动距离
    self.currentOffsetY = ([self.nodeIndex intValue]) * NodeH;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"refleshSC" object:self.nodeIndex];
}
- (void)restoreNodeState
{
    [self.upLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
    }];
    [self.downLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.point.mas_bottom);
    }];
    [self.point mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upLine.mas_bottom);
        
    }];

}
- (void)setNodeState
{
    self.upLine = [self viewWithTag:1+([self.nodeIndex intValue])];
    self.downLine = [self viewWithTag:1000 +([self.nodeIndex intValue])];
    self.point = [self viewWithTag:100 + ([self.nodeIndex intValue])];
    [self.upLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(10);
    }];
    [self.downLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.point.mas_bottom).offset(10);
    }];
    [self.point mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.upLine.mas_bottom).offset(10);

    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
