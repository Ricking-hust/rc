//
//  CZTagSelectView.h
//  rc
//
//  Created by AlanZhang on 16/2/13.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CZTagWithLabelView;
@interface CZTagSelectView : UIView
@property (nonatomic, strong) CZTagWithLabelView *meetingTag;
@property (nonatomic, strong) CZTagWithLabelView *appointmentTag;
@property (nonatomic, strong) CZTagWithLabelView *businessTag;
@property (nonatomic, strong) CZTagWithLabelView *sportTag;
@property (nonatomic, strong) CZTagWithLabelView *shoppingTag;
@property (nonatomic, strong) CZTagWithLabelView *entertainmentTag;
@property (nonatomic, strong) CZTagWithLabelView *partTag;
@property (nonatomic, strong) CZTagWithLabelView *otherTag;
+ (instancetype)tagSelectView;
@end
