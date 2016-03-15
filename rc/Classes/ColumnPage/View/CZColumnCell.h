//
//  CZColumnCell.h
//  rc
//
//  Created by AlanZhang on 16/3/10.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZColumnCell : UITableViewCell
@property (nonatomic, strong) UIImageView *acImageView;
@property (nonatomic, strong) UILabel *acNameLabel;
@property (nonatomic, strong) UILabel *acTimeLabel;
@property (nonatomic, strong) UILabel *acPlaceLabel;
@property (nonatomic, strong) UIImageView *tagImageView;
@property (nonatomic, strong) UILabel *acTagLabel;
@property (nonatomic, assign) CurrentDevice device;
@property (nonatomic, assign) BOOL isLeft;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) UIView *bgView;
/**
 *  对cell的子控件进行布局
 *
 */
- (void)setSubviewConstraint;
@end
