//
//  RCPubRecViewCell.m
//  rc
//
//  Created by 余笃 on 16/6/14.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCPubRecViewCell.h"
#import "Masonry.h"
#import "PublisherViewController.h"
#import "UIImageView+WebCache.h"

static const CGFloat pubPicRadius = 37.5;

@implementation RCPubRecViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!_publisherPic) {
            _publisherPic = [[UIImageView alloc]init];
            _publisherPic.layer.masksToBounds = YES;
            _publisherPic.layer.cornerRadius = pubPicRadius;
            _publisherPic.userInteractionEnabled = YES;
            //轻拍Tap
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(turnToPublisherView)];
            [_publisherPic addGestureRecognizer:tap];
            [self.contentView addSubview:_publisherPic];
        }
        
        if (!_pubSign) {
            _pubSign = [[UITextView alloc]init];
            _pubSign.textColor = RGB(0x939393, 0.6);
            _pubSign.font = [UIFont systemFontOfSize:12];
            [self.contentView addSubview:_pubSign];
        }
        
        if (!_pubNameLabel) {
            _pubNameLabel = [[UILabel alloc]init];
            _pubNameLabel.font = [UIFont systemFontOfSize:15];
            _pubNameLabel.textColor = [UIColor blackColor];
            [self.contentView addSubview:_pubNameLabel];
        }
        
        if (!_followBtn) {
            _followBtn = [[RcFollowedButon alloc]init];
            [_followBtn setTitleColor:themeColor forState:UIControlStateNormal];
            [_followBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
            [_followBtn setImage:[UIImage imageNamed:@"user"] forState:UIControlStateNormal];
            [self.contentView addSubview:_followBtn];
        }
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [_publisherPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    
    [_pubNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(23);
        make.left.equalTo(self.publisherPic.mas_right).offset(20);
        make.right.equalTo(self.followBtn.mas_left).offset(-10);
        make.bottom.equalTo(self.contentView.mas_top).offset(38);
    }];
    
    [_pubSign mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pubNameLabel.mas_bottom).offset(12);
        make.left.equalTo(self.self.pubNameLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.publisherPic.mas_bottom);
    }];
    
    [_followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(16);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.size.mas_equalTo(CGSizeMake(65, 25));
    }];
}

-(void)setSubViewValue{
    [_publisherPic sd_setImageWithURL:[NSURL URLWithString:self.pubModel.pubPic] placeholderImage:[UIImage imageNamed:@"Beijing_Icon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    _pubSign.text = self.pubModel.pubSign;
    _pubNameLabel.text = self.pubModel.pubName;
    [_followBtn setTitle:self.pubModel.followed forState:UIControlStateNormal];
}

-(void)turnToPublisherView{
    UIView* next = [self superview].superview.superview.superview.superview;
    
    UIResponder *nextResponder = [next nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        
    {
        UIViewController *fatherView =  (UIViewController *)nextResponder;
        PublisherViewController *publisherViewController = [[PublisherViewController alloc]init];
        [fatherView.navigationController pushViewController:publisherViewController animated:YES];
    }
}

@end
