//
//  RCPubRecViewCell.m
//  rc
//
//  Created by 余笃 on 16/6/14.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCPubRecViewCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

static const CGFloat pubPicRadius = 75;

@implementation RCPubRecViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        if (!_publisherBtn) {
            _publisherBtn = [[UIButton alloc]init];
            [_publisherBtn.imageView sd_setImageWithURL:[NSURL URLWithString:self.pubModel.pubPic] placeholderImage:[UIImage imageNamed:@"Beijing_Icon"]];
            [_publisherBtn.layer setMasksToBounds:YES];
            [_publisherBtn.layer setCornerRadius:pubPicRadius];
            [_publisherBtn addTarget:self action:@selector(turnToPublisherView) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:_publisherBtn];
        }
        
        if (!_pubSignLabel) {
            _pubSignLabel = [[UILabel alloc]init];
            _pubSignLabel.text = self.pubModel.pubSign;
            _pubSignLabel.textColor = RGB(0x939393, 0.6);
            _pubSignLabel.font = [UIFont systemFontOfSize:12];
            [self.contentView addSubview:_pubSignLabel];
        }
        
        if (!_pubNameLabel) {
            _pubNameLabel = [[UILabel alloc]init];
            _pubNameLabel.text = self.pubModel.pubName;
            _pubNameLabel.font = [UIFont systemFontOfSize:15];
            _pubNameLabel.textColor = [UIColor blackColor];
            [self.contentView addSubview:_pubNameLabel];
        }
        
        if (!_followBtn) {
            _followBtn = [[RcFollowedButon alloc]init];
            _followBtn.titleLabel.text = self.pubModel.followed;
            [_followBtn setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
            [self.contentView addSubview:_followBtn];
        }
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [_publisherBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    
    [_pubNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(23);
        make.left.equalTo(self.publisherBtn.mas_right).offset(20);
        make.right.equalTo(self.followBtn.mas_left).offset(-10);
        make.bottom.equalTo(self.contentView.mas_top).offset(38);
    }];
    
    [_pubSignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pubNameLabel.mas_bottom).offset(12);
        make.left.equalTo(self.self.pubNameLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.publisherBtn.mas_bottom);
    }];
    
    [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(65, 25));
    }];
}

-(void)turnToPublisherView{
    NSLog(@"turnToPublisherView");
}

@end
