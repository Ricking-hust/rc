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

//@property (nonatomic,strong) UIImageView *publisherPic;
//@property (nonatomic,strong) UILabel *pubName;
//@property (nonatomic,strong) UILabel *pubSign;
//@property (nonatomic,strong) UIButton *follow;
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
}


@end
