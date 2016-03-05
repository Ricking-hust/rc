//
//  CZRemindView.h
//  rc
//
//  Created by AlanZhang on 16/3/5.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZRemindView : UIView
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UIView *segline;
@property (nonatomic, assign) BOOL isSelected;
@end
