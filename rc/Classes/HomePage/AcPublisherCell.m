//
//  publisherCell.m
//  rc
//
//  Created by 余笃 on 16/6/22.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "AcPublisherCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

#define PADDING  10 //活动详情cell 中子控件之间的垂直间距

@implementation AcPublisherCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!_publisher) {
            _publisher = [[UIImageView alloc]init];
            _publisher.layer.masksToBounds = YES;
            _publisher.layer.cornerRadius = 22.5;
            _publisher.userInteractionEnabled = YES;
            [self.contentView addSubview:_publisher];
        }
        
        if (!_pubName) {
            _pubName = [[UILabel alloc] init];
            [_pubName setFont:[UIFont systemFontOfSize:14]];
            [self.contentView addSubview:_pubName];
        }
        
        if (!_follow) {
            _follow = [[UIButton alloc]init];
            [_follow.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [_follow setTitleColor:themeColor forState:UIControlStateNormal];
            [self.contentView addSubview:_follow];
        }
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [_publisher mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.size.mas_offset(CGSizeMake(45, 45));
    }];
    
    [_follow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(45);
    }];
    
    [_pubName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.publisher.mas_right).offset(15);
        make.right.equalTo(self.follow.mas_left).offset(15);
    }];
}

-(void)setSubviewsValueWithImage:(NSString *)imageStr PubName:(NSString *)pubName isFollowed:(NSString *)followed{
    [_publisher sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"user2"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

    }];
    
    if ([followed isEqualToString:@"0"]) {
        [_follow setTitle:@"+ 关注" forState:UIControlStateNormal];
    } else {
        [_follow setTitle:@"已关注" forState:UIControlStateNormal];
    }
    
    [_pubName setText:pubName];
}

@end
