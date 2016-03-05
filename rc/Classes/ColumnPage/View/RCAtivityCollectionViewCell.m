//
//  activityCollectionViewCell.m
//  rc
//
//  Created by 余笃 on 16/3/5.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCActivityCollectionViewCell.h"
#import "CZAcitivityModelOfColumn.h"
#import "Masonry.h"
#include <sys/sysctl.h>

#define TITTLE_FONTSIZE 14  //标题字体大小
#define TIME_FONTSIZE   10  //时间字体大小
#define PLACE_FONTSIZE  10  //地点字体大小
#define TAG_FONTSIZE    10  //标签字体大小

@implementation RCActivityCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureViews];
    }
    return self;
}

-(void)configureViews{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.goodNameLabel = [[UILabel alloc] initWithFrame:(CGRect){self.contentView.width/2-7,self.contentView.height-5,14,5}];
    self.goodNameLabel.backgroundColor = [UIColor whiteColor];
    self.goodNameLabel.textColor =[UIColor blackColor];
    self.goodNameLabel.font = [UIFont systemFontOfSize:4];
    [self.contentView addSubview:self.goodNameLabel];
    
    self.goodImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.goodImageView];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
}

@end
