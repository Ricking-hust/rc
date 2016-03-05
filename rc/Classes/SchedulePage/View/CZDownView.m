//
//  CZDownView.m
//  rc
//
//  Created by AlanZhang on 16/3/2.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZDownView.h"

@implementation CZDownView

- (id)init
{
    if (self = [super init])
    {
        self.contextView = [[UIView alloc]init];
        self.contextView.backgroundColor = [UIColor whiteColor];
        self.textView = [[UITextView alloc]init];
        UILabel *label = [[UILabel alloc]init];
        self.limitedLabel = label;
        
        self.timeView = [[UIView alloc]init];
        self.timeView.backgroundColor = [UIColor whiteColor];
        UILabel *timeLabel = [[UILabel alloc]init];
        self.timelabel = timeLabel;
        self.timeInfoLabel = [[UILabel alloc]init];
        self.timeInfoLabel.font = [UIFont systemFontOfSize:14];
        self.moreTimeImg = [[UIImageView alloc]init];
        
        self.remindView = [[UIView alloc]init];
        self.remindView.backgroundColor = [UIColor whiteColor];
        UILabel *remindLabel = [[UILabel alloc]init];
        self.remindLabel = remindLabel;
        self.remindTimeLabel = [[UILabel alloc]init];
        self.remindTimeLabel.font = [UIFont systemFontOfSize:14];
        self.moreRemindImg = [[UIImageView alloc]init];
        self.moreRemindImg.image = [UIImage imageNamed:@"nextIcon"];
        
        [self addSubview:self.contextView];
        [self.contextView addSubview:self.textView];
        [self.contextView addSubview:self.limitedLabel];
        
        [self addSubview:self.timeView];
        [self.timeView addSubview:self.timelabel];
        [self.timeView addSubview:self.timeInfoLabel];
        [self.timeView addSubview:self.moreTimeImg];
        
        [self addSubview:self.remindView];
        [self.remindView addSubview:self.remindLabel];
        [self.remindView addSubview:self.remindTimeLabel];
        [self.remindView addSubview:self.moreRemindImg];
    }
    self.backgroundColor = [UIColor clearColor];
    return self;
}
- (void)setLimitedLabel:(UILabel *)limitedLabel
{
    _limitedLabel = limitedLabel;
    _limitedLabel.text = @"40字";
    _limitedLabel.alpha = 0.5;
    _limitedLabel.font = [UIFont systemFontOfSize:14];
}
- (void)setTimelabel:(UILabel *)timelabel
{
    _timelabel = timelabel;
    _timelabel.text = @"行程时间";
    _timelabel.alpha = 0.8;
    _timelabel.font = [UIFont systemFontOfSize:14];
}
- (void)setRemindLabel:(UILabel *)remindLabel
{
    _remindLabel = remindLabel;
    _remindLabel.text = @"需要提醒";
    _remindLabel.alpha = 0.8;
    _remindLabel.font = [UIFont systemFontOfSize:14];
}
@end
