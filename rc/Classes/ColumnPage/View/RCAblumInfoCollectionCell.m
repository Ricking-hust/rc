//
//  RCAblumInfoCollection.m
//  rc
//
//  Created by LittleMian on 16/7/13.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCAblumInfoCollectionCell.h"
#import "Masonry.h"
#import "RCAblumActivityModel.h"
@interface RCAblumInfoCollectionCell()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *tittleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *placeLabel;
@property (nonatomic, strong) UIButton *infoButton;
@end
@implementation RCAblumInfoCollectionCell
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageView = [[UIImageView alloc]init];
        self.tittleLabel = [[UILabel alloc]init];
        self.timeLabel = [[UILabel alloc]init];
        self.desLabel = [[UILabel alloc]init];
        self.placeLabel = [[UILabel alloc]init];
        self.infoButton = [[UIButton alloc]init];
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.tittleLabel];
        [self.contentView addSubview:self.desLabel];
        [self.contentView addSubview:self.placeLabel];
    }
    self.backgroundColor = [UIColor whiteColor];
    return self;
}
- (void)setModel:(RCAblumActivityModel *)model
{
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_model.ac_img] placeholderImage:[UIImage imageNamed:@"img_1"]];
    self.tittleLabel.text = _model.ac_title;
    self.timeLabel.text = [NSString stringWithFormat:@"时间：%@", _model.ac_time];
    self.desLabel.text = [NSString stringWithFormat:@"主讲人：%@", _model.ac_des];
    self.placeLabel.text = [NSString stringWithFormat:@"地点：%@", _model.ac_place];
    
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.top.equalTo(self.contentView);
    }];
}

@end
