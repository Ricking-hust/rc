//
//  CZDownView.h
//  rc
//
//  Created by AlanZhang on 16/3/2.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZDownView : UIView
@property (nonatomic, strong) UIView *contextView;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UILabel *limitedLabel;
@property (nonatomic, strong) UIView *timeView;
@property (strong, nonatomic) UILabel *timelabel;
@property (strong, nonatomic) UILabel *timeInfoLabel;
@property (strong, nonatomic) UIImageView *moreTimeImg;
@property (nonatomic, strong) UIView *remindView;
@property (strong, nonatomic) UILabel *remindLabel;
@property (strong, nonatomic) UILabel *remindTimeLabel;
@property (strong, nonatomic) UIImageView *moreRemindImg;

@end
