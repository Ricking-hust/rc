//
//  CZColumnViewController.h
//  日常
//
//  Created by AlanZhang on 15/12/17.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCColumnInfoView;
@interface CZColumnViewController : UIViewController
@property (nonatomic, strong) RCColumnInfoView *other;
@property (nonatomic, strong) RCColumnInfoView *internet;
@property (nonatomic, strong) RCColumnInfoView *media;
@property (nonatomic, strong) RCColumnInfoView *university;
@property (nonatomic, strong) RCColumnInfoView *businessStartups;
@property (nonatomic, strong) RCColumnInfoView *finance;
@end