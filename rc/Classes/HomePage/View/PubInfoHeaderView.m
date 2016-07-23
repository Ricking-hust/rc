//
//  PubInfoHeaderView.m
//  rc
//
//  Created by 余笃 on 16/7/23.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "PubInfoHeaderView.h"
#import "Masonry.h"

@implementation PubInfoHeaderView

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        if (!_publisherPic) {
            _publisherPic = [[UIImageView alloc]init];
            _publisherPic.layer.masksToBounds = YES;
            _publisherPic.layer.cornerRadius = 28.5;
            [self addSubview:_publisherPic];
        }
        
        if (!_pubName) {
            _pubName = [[UILabel alloc]init];
            [_pubName setFont:[UIFont systemFontOfSize:15]];
            [_pubName setTextColor:[UIColor blackColor]];
            [self addSubview:_pubName];
        }
        
        if (!_pubSign) {
            _pubSign = [[UILabel alloc]init];
            [_pubSign setFont:[UIFont systemFontOfSize:12]];
            [_pubSign setTextColor:RGB(0x464646, 0.6)];
            [self addSubview:_pubSign];
        }
        
        if (!_follow) {
            _follow = [[UIButton alloc]init];
            [_follow setTitleColor:themeColor forState:UIControlStateNormal];
            [_follow.titleLabel setFont:[UIFont systemFontOfSize:11]];
            [self addSubview:_follow];
        }
        
        if (!_activityBy) {
            _activityBy = [[UIButton alloc]init];
            _activityBy.titleLabel.font = [UIFont systemFontOfSize:14];
            [_activityBy setTitleColor:[UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_activityBy setTitleColor:themeColor forState:UIControlStateSelected];
            _activityBy.tag = (NSInteger) (5);
            [_activityBy addTarget:self action:@selector(showActivityBy) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_activityBy];
        }
        
        if (!_activityTakeIn) {
            _activityTakeIn = [[UIButton alloc]init];
            _activityTakeIn.titleLabel.font = [UIFont systemFontOfSize:14];
            [_activityTakeIn setTitleColor:[UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_activityTakeIn setTitleColor:themeColor forState:UIControlStateSelected];
            _activityTakeIn.tag = (NSInteger) (6);
            [_activityTakeIn addTarget:self action:@selector(showActivityTakeIn) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_activityTakeIn];
        }
        
        if (!_followOf) {
            _followOf = [[UIButton alloc]init];
            _followOf.titleLabel.font = [UIFont systemFontOfSize:14];
            [_followOf setTitleColor:[UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [_followOf setTitleColor:themeColor forState:UIControlStateSelected];
            _followOf.tag = (NSInteger) (7);
            [_followOf addTarget:self action:@selector(showFollowOf) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_followOf];
        }
        
        self.horizonView = [[UIView alloc]init];
        self.horizonView.backgroundColor = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
        [self addSubview:self.horizonView];
        
        self.verticalViewLeft = [[UIView alloc]init];
        self.verticalViewLeft.backgroundColor = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
        [self addSubview:self.verticalViewLeft];
        
        self.verticalViewRight = [[UIView alloc]init];
        self.verticalViewRight.backgroundColor = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
        [self addSubview:self.verticalViewRight];
        
        self.horizonBottomView = [[UIView alloc]init];
        self.horizonBottomView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
        [self addSubview:self.horizonBottomView];
    }
    return self;
}

-(void)layoutSubviews{
    
    [self.publisherPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(25);
        make.size.mas_equalTo(CGSizeMake(57, 57));
    }];
    
    [self.pubSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pubName.mas_right);
        make.top.equalTo(self.pubName.mas_bottom).offset(10);
        make.left.equalTo(self.pubName.mas_left);
        make.height.mas_equalTo(50);
    }];
    
    [self.pubName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.publisherPic.mas_right).offset(16);
        make.right.equalTo(self.follow.mas_left).offset(-27);
        make.top.equalTo(self.publisherPic.mas_top);
        make.height.mas_equalTo(15);
    }];
    
    [self.follow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.mas_top).offset(25);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.activityBy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(kScreenWidth/6);
        make.top.equalTo(self.mas_top).offset(110);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.mas_equalTo(kScreenWidth/3-10);
    }];
    
    [self.activityTakeIn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(kScreenWidth/2);
        make.top.equalTo(self.mas_top).offset(110);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.mas_equalTo(kScreenWidth/3-10);
    }];
    
    [self.followOf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(kScreenWidth * 5/6);
        make.top.equalTo(self.mas_top).offset(110);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.width.mas_equalTo(kScreenWidth/3-10);
    }];
    
    [self.horizonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(100);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(1);
    }];
    
    [self.verticalViewLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(kScreenWidth/3);
        make.centerY.equalTo(self.activityBy.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, 24));
    }];
    
    [self.verticalViewRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).offset(kScreenWidth * 2/3);
        make.centerY.equalTo(self.activityBy.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(1, 24));
    }];
    
    [self.horizonBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(10);
    }];
}

-(void)setSubViewsValue{
    [self.publisherPic setImage:[UIImage imageNamed:@"Beijing_Icon"]];
    [self.pubName setText:@"嘟嘟"];
    [self.pubSign setText:@"常在河边走，哪有不日狗"];
    [self.follow setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
    [self.follow setTitle:@"+关注" forState:UIControlStateNormal];
    // the space between the image and text
    CGFloat spacing = 6.0;
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = self.follow.imageView.image.size;
    self.follow.titleEdgeInsets = UIEdgeInsetsMake(
                                              0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [self.follow.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.follow.titleLabel.font}];
    self.follow.imageEdgeInsets = UIEdgeInsetsMake(
                                              - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    
    // increase the content height to avoid clipping
    CGFloat edgeOffset = fabs(titleSize.height - imageSize.height) / 2.0;
    self.follow.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
    
    [self.activityBy setTitle:[NSString stringWithFormat:@"发布的活动\n%@",@"400"] forState:UIControlStateNormal];
    [self.activityTakeIn setTitle:[NSString stringWithFormat:@"参加的活动\n%@",@"100"] forState:UIControlStateNormal];
    [self.followOf setTitle:[NSString stringWithFormat:@"他的关注\n%@",@"36"] forState:UIControlStateNormal];
}

-(void)showActivityBy{
    self.activityBy.selected = YES;
    self.activityTakeIn.selected = NO;
    self.followOf.selected = NO;
    NSLog(@"showActivityBy");
}

-(void)showActivityTakeIn{
    self.activityBy.selected = NO;
    self.activityTakeIn.selected = YES;
    self.followOf.selected = NO;
    NSLog(@"showActivityTakeIn");
}

-(void)showFollowOf{
    self.activityBy.selected = NO;
    self.activityTakeIn.selected = NO;
    self.followOf.selected = YES;
    NSLog(@"showFollowOf");
}

@end
