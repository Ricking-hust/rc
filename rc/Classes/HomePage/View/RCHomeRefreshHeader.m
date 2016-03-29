//
//  RCHomeRefreshHeader.m
//  rc
//
//  Created by AlanZhang on 16/3/24.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCHomeRefreshHeader.h"
#import "Masonry.h"
#import "UIImage+GIF.h"
#import "UIImageView+WebCache.h"
@interface RCHomeRefreshHeader()

@end
@implementation RCHomeRefreshHeader
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    // 添加label
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    label.textColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
    self.label = label;
    
    // logo
    UIImageView *logo = [[UIImageView alloc]init];
    logo.image = [UIImage imageNamed:@"50%loading.gif"];
    [self addSubview:logo];
    self.logo = logo;
    
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    [self.label mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
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

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
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

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    

}
@end
