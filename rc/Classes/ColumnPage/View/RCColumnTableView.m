//
//  RCColumnTableView.m
//  rc
//
//  Created by AlanZhang on 16/3/20.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCColumnTableView.h"
#import "Masonry.h"
@implementation RCColumnTableView
- (id)init
{
    if (self = [super init])
    {
        self.leftTableView = [[UITableView alloc]init];
        self.leftTableView.tag = 100;
        self.rightTableView = [[UITableView alloc]init];
        self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.view = [[UIView alloc]init];
    }
    [self setSubView];
    return self;
}

- (UIViewController *)viewController
{
    UIResponder *responder = self.view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    return nil;
}
- (void)setSubView
{
    [self addSubview:self.leftTableView];
    [self addSubview:self.rightTableView];
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.leftTableView.showsVerticalScrollIndicator = NO;
    self.rightTableView.showsVerticalScrollIndicator = NO;
    self.leftTableView.backgroundColor = [UIColor clearColor];
    self.rightTableView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    self.leftTableView.tag = 11;
    self.rightTableView.tag = 12;

    [self.leftTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
    [self.rightTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_equalTo(kScreenWidth/2);
    }];
}
@end
