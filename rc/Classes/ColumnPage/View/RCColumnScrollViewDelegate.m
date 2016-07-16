//
//  RCColumnScrollViewDelegate.m
//  rc
//
//  Created by AlanZhang on 16/4/1.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCColumnScrollViewDelegate.h"
#import "Masonry.h"
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

    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.index = (scrollView.contentOffset.x + scrollView.frame.size.width / 2)/ scrollView.frame.size.width;
    if (self.toolButtonArray.count != 0)
    {
        UIButton *button = self.toolButtonArray[self.index];
        [self isToolButtonSelected:button];
        //to do here -----------------------------------
        CGFloat x = scrollView.contentOffsetX * 42 / kScreenWidth + 10 + self.index * 26;
        [self.line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.toolScrollView).offset(x);
        }];
        if (self.index > self.toolButtonArray.count / 2)
        {
            [UIView animateWithDuration:0.7 animations:^{
                [self.toolScrollView setContentOffsetX:self.toolScrollView.contentSize.width/2];
            }];
            
        }else
        {
            [UIView animateWithDuration:0.7 animations:^{
                [self.toolScrollView setContentOffsetX:0];
            }];

        }
    }
}
- (void)isToolButtonSelected:(UIButton *)btn
{
    for (int i = 0; i < self.toolButtonArray.count; ++i)
    {
        UIButton *button = self.toolButtonArray[i];
        button.selected = NO;
    }
    btn.selected = YES;

}
@end
