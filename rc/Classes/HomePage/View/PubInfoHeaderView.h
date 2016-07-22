//
//  PubInfoHeaderView.h
//  rc
//
//  Created by 余笃 on 16/7/23.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PubInfoHeaderView : UIView

@property (nonatomic,strong) UIImageView *publisherPic;
@property (nonatomic,strong) UILabel *pubName;
@property (nonatomic,strong) UILabel *pubSign;
@property (nonatomic,strong) UIButton *follow;

- (void)setSubViewsValue;

@end
