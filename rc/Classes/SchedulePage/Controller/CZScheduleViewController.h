//
//  CZScheduleViewController.h
//  rc
//
//  Created by AlanZhang on 16/3/5.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CZScheduleInfoView;
@interface CZScheduleViewController : UIViewController<UIScrollViewDelegate>
@property (nonatomic, strong) CZScheduleInfoView *scInfoView;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) UIImageView *timeLine;
@property (nonatomic, strong) UIScrollView *leftScrollView;
@property (nonatomic, strong) UIScrollView *rigthScrollView;
@property (nonatomic, strong) NSArray *array;
@end
