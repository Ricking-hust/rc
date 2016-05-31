//
//  RCBarButtonView.h
//  rc
//
//  Created by AlanZhang on 16/3/28.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCBarButton;
@interface RCBarButtonView : UIView
@property (nonatomic, strong) RCBarButton *button;
@property (nonatomic, strong) UILabel *label;
- (void)setSubView;
@end
