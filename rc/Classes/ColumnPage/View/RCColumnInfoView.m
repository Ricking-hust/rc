//
//  RCColumnInfoView.m
//  rc
//
//  Created by AlanZhang on 16/3/14.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCColumnInfoView.h"
#import "Masonry.h"
#import "CZTableView.h"
@implementation RCColumnInfoView

- (id)init
{
    if (self = [super init])
    {
        self.leftTableView = [[CZTableView alloc]init];
        self.rightTableView = [[CZTableView alloc]init];
        self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    [self setConstraint];
    return self;
}
- (void)setConstraint
{
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.leftTableView.showsVerticalScrollIndicator = NO;
    self.rightTableView.showsVerticalScrollIndicator = NO;
    self.leftTableView.backgroundColor = [UIColor clearColor];
    self.rightTableView.backgroundColor = [UIColor clearColor];
    self.leftTableView.tag = 11;
    self.rightTableView.tag = 12;
    [self addSubview:self.leftTableView];
    [self addSubview:self.rightTableView];
    self.backgroundColor = [UIColor clearColor];
    self.hidden = YES;
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
}
@end
