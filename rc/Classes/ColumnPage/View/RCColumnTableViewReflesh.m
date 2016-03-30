//
//  RCColumnTableViewReflesh.m
//  rc
//
//  Created by AlanZhang on 16/3/29.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCColumnTableViewReflesh.h"
#import "Masonry.h"
#import "RCColumnTableView.h"
@implementation RCColumnTableViewReflesh

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX).offset(kScreenWidth/4);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    [self.loading mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.label.mas_left).offset(-5);
        make.centerY.equalTo(self.label.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    UIImage *img = [UIImage imageNamed:@"50%loading.gif"];
    [self.logo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.label.mas_left).offset(15);
        make.centerY.equalTo(self.label.mas_centerY);
        make.width.mas_equalTo(img.size.width);
        make.height.mas_equalTo(img.size.height);
    }];
}
#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    switch (state) {
        case MJRefreshStateIdle:
        {
            self.logo.hidden = NO;
            UIImage *img = [UIImage imageNamed:@"50%loading.gif"];
            self.logo.image = img;
            self.label.text = @"下拉刷新";
            RCColumnTableView *rc = (RCColumnTableView *)((UITableView *)self.superview).superview;
            NSLog(@"%@",rc.a);
        }
            break;
            
        case MJRefreshStatePulling:
        {
            self.logo.hidden = NO;
            self.label.text = @"释放更新";
            UIImage *img = [UIImage imageNamed:@"50%loading.gif"];
            self.logo.image = img;
        }
            break;
        case MJRefreshStateRefreshing:
        {
            self.logo.hidden = NO;
            self.label.text = @"加载中……";
            [self.logo sd_setImageWithURL:[[NSBundle mainBundle] URLForResource:@"50%loading.gif" withExtension:nil]];
        }
            break;
        default:
            break;
    }
}

@end
