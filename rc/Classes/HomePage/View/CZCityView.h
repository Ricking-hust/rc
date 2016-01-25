//
//  CZCityView.h
//  rc
//
//  Created by AlanZhang on 16/1/25.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZCityView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIImageView *locationImage;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

/**
 *  类方法,创建对象实例
 *
 *  @return 对象实例
 */
+ (instancetype)cityView;

@end
