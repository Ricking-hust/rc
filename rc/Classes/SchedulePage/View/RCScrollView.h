//
//  RCScrollView.h
//  rc
//
//  Created by AlanZhang on 16/3/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RCScrollView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, strong) PlanList *planList;
@property (nonatomic, strong) NSMutableArray *planListRanged;
@property (nonatomic, strong) NSNumber *nodeIndex;
@property (nonatomic, assign) CGFloat currentOffsetY;
@property (nonatomic, assign) BOOL isUp;
@property (nonatomic, strong) UIView *upLine;
@property (nonatomic, strong) UIView *downLine;
@property (nonatomic, strong) UIView *point;
@end
