//
//  CZTimeSelectView.h
//  rc
//
//  Created by AlanZhang on 16/2/11.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZTimeSelectView : UIView
@property (nonatomic, strong) UIPickerView *pickView;
@property (nonatomic, strong) UIButton *OKbtn;
+ (instancetype)selectView;
@end
