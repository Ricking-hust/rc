//
//  CZTagWithLabelView.h
//  rc
//
//  Created by AlanZhang on 16/2/13.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZTagWithLabelView : UIView
@property (nonatomic, strong) UIButton *tagButton;
@property (nonatomic, strong) UILabel *label;

+ (instancetype)tagWithLabel;
- (id)initWithImage:(UIImage *)img andTittle:(NSString *)tittle;
@end
