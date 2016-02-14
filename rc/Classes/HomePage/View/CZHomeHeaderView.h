//
//  CZHomeHeaderView.h
//  日常
//
//  Created by AlanZhang on 16/1/5.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZHomeHeaderView : UIView

@property(nonatomic, weak)UIScrollView *scrollView;
@property(nonatomic, weak)UIPageControl *pageControl;
@property(nonatomic, weak)UILabel *label;
@property(nonatomic, weak)UIView *segmentation;

/**
 *	类方法
 *
 *	@return	返回实例对象
 */
+ (instancetype) headerView;

/**
 *	对象方法
 *
 *	设置对象的属性
 */
- (void)setView;

@end
