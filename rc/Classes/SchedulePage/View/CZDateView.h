//
//  CZDateView.h
//  rc
//
//  Created by AlanZhang on 16/3/5.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZDateView : UIView
@property (nonatomic, strong) UILabel *month;
@property (nonatomic, strong) UILabel *week;
- (void)addSubViewConstraint;
@end
