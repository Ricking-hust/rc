//
//  RCScrollView.m
//  rc
//
//  Created by AlanZhang on 16/3/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCScrollView.h"
#import "Masonry.h"
#define NodeH 114
//每个节点的高度为104，即滚动104到下一个节点
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
        self.isUpRange = YES;
        self.isDownRange = YES;
        self.isNodeChanged = NO;
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
    [self newNodeIndex:scrollView.contentOffsetY];
    if (self.isNodeChanged == YES)
    {
        [scrollView setContentOffsetY:([self.nodeIndex intValue]) * NodeH];
        self.isNodeChanged = NO;
        //设置节点状态--------
        [self restoreNodeState];
        [self setNodeState];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refleshSC" object:self.nodeIndex];
    }
    if (self.nodeIndex == 0)
    {
        if (scrollView.contentOffsetY< 10 && scrollView.contentOffsetY >-10)
        {
            [scrollView setContentOffsetY:0];
            //设置节点状态----------
            [self restoreNodeState];
            [self setNodeState];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refleshSC" object:self.nodeIndex];
        }
    }

}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self newNodeIndex:scrollView.contentOffsetY];
        if (self.isNodeChanged == YES)
        {
            [scrollView setContentOffsetY:([self.nodeIndex intValue]) * NodeH];
            self.isNodeChanged = NO;
            //设置节点状态----------
            [self restoreNodeState];
            [self setNodeState];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refleshSC" object:self.nodeIndex];
        }
        if (self.nodeIndex == 0)
        {
            if (scrollView.contentOffsetY< 10 && scrollView.contentOffsetY >-10)
            {
                [scrollView setContentOffsetY:0];
                //设置节点状态----------
                [self restoreNodeState];
                [self setNodeState];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"refleshSC" object:self.nodeIndex];
            }
        }

    }

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

- (void)upRange:(CGFloat)offsetY
{
    CGFloat location = offsetY/NodeH;
    int index = (int)location;
    CGFloat sub = location - index;
    if (sub < 0.05 && sub > -0.05 && self.isUpRange)
    {
        index = (int)location;
        self.isNodeChanged = YES;
        self.isDownRange = NO;
    }
    if (location - ([self.nodeIndex intValue]) > 1)
    {
        self.isUpRange = YES;
        self.isDownRange = YES;
    }
    self.nodeIndex = [[NSNumber alloc]initWithInt:index];
}
- (void)downRange:(CGFloat)offsetY
{
    
    CGFloat location = offsetY/NodeH;
    int index = (int)location;
    CGFloat sub = location - index;

    if (sub > 0.9 && sub < 1.1 && self.isDownRange)
    {
        index++;
        self.isNodeChanged = YES;
        self.isUpRange = NO;
    }
    if (location - ([self.nodeIndex intValue])> 0.9 && location - ([self.nodeIndex intValue]) < 1.1)
    {
        self.isUpRange = YES;
        self.isDownRange = YES;
        self.nodeIndex = [[NSNumber alloc]initWithInt:([self.nodeIndex intValue])+1];
        self.isNodeChanged = YES;
        return;
    }
    self.nodeIndex = [[NSNumber alloc]initWithInt:index];

}
- (void)newNodeIndex:(CGFloat)offsetY
{
    [self upRange:offsetY];
    [self downRange:offsetY];
    if (([self.nodeIndex intValue]) >= self.planListRanged.count)
    {
        self.nodeIndex = [[NSNumber alloc]initWithInt:(int)self.planListRanged.count-1];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
