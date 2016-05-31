//
//  CZCityView.h
//  rc
//
//  Created by AlanZhang on 16/1/25.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZCityView : UIView

@property (strong, nonatomic)  UIButton *cityBtn;
@property (strong, nonatomic)  UIImageView *locationImage;
@property (strong, nonatomic)  UILabel *cityNameLabel;
- (id)initName:(NSString *)cityName WithImageString:(NSString *)imageString;
//根据设备设置约束
- (void)setConstraints;
@end
