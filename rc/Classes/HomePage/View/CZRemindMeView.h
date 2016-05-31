//
//  CZRemindMeView.h
//  rc
//
//  Created by AlanZhang on 16/1/27.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZRemindMeView : UIView
@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIButton *notRemind;
@property (nonatomic, strong) UIButton *remindBeforeOneHour;
@property (nonatomic, strong) UIButton *remindBeforeTwoDay;
@property (nonatomic, strong) UIButton *remindBeforeThreeDay;

@property (nonatomic, strong) UIView *topSegmentView;
@property (nonatomic, strong) UIView *bottomSegmentView;
@property (nonatomic, strong) UIButton *OKbtn;

@property (nonatomic, weak) UIViewController *parentVC;

/**
 *  类方法，创建自定义的弹出视图
 *
 *  @return 返回对象实例
 */
+ (instancetype)remindMeView;

/**
 *  对象方法， 设置子控件
 *
 *
 */
- (void)setSubView;
@end
