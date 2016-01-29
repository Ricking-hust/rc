//
//  CZColumnViewController.h
//  日常
//
//  Created by AlanZhang on 15/12/17.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CZToolButton;
@interface CZColumnViewController : UIViewController

//界面顶部的工具栏
@property (strong, nonatomic) CZToolButton *all;
@property (strong, nonatomic) CZToolButton *finance;
@property (strong, nonatomic) CZToolButton *media;
@property (strong, nonatomic) CZToolButton *bStarup;
@property (strong, nonatomic) CZToolButton *net;
@property (strong, nonatomic) CZToolButton *design;
@property (strong, nonatomic) CZToolButton *more;

@end

