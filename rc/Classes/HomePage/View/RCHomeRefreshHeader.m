//
//  RCHomeRefreshHeader.m
//  rc
//
//  Created by AlanZhang on 16/3/24.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCHomeRefreshHeader.h"
#import "Masonry.h"
@interface RCHomeRefreshHeader()
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIImageView *logo;
@property (weak, nonatomic) UIActivityIndicatorView *loading;
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
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addIcon"]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
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
    
//    self.label.frame = self.bounds;
//    
//    self.logo.bounds = CGRectMake(0, 0, self.bounds.size.width, 100);
//    self.logo.center = CGPointMake(self.mj_w * 0.5, - self.logo.mj_h + 20);
//    
////    self.loading.center = CGPointMake(self.mj_w - 30, self.mj_h * 0.5);
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
    [self.logo mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.label.mas_left).offset(-5);
        make.centerY.equalTo(self.label.mas_centerY);
        make.size.mas_equalTo(self.logo.image.size);
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
            [self.loading stopAnimating];
            self.logo.hidden = NO;
            self.logo.image = [UIImage imageNamed:@"nextIcon"];
            self.label.text = @"下拉刷新";
            break;
        case MJRefreshStatePulling:
            [self.loading stopAnimating];
            self.logo.hidden = NO;
            self.label.text = @"松开更新";
            self.logo.image = [UIImage imageNamed:@"backIcon"];

            break;
        case MJRefreshStateRefreshing:
            self.logo.hidden = YES;
            self.label.text = @"加载数据中……";
            [self.loading startAnimating];
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
//    // 1.0 0.5 0.0
//    // 0.5 0.0 0.5
//    CGFloat red = 1.0 - pullingPercent * 0.5;
//    CGFloat green = 0.5 - 0.5 * pullingPercent;
//    CGFloat blue = 0.5 * pullingPercent;
//    self.label.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}
@end
