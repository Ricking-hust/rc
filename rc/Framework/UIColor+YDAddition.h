//
//  UIColor+YDAddition.h
//  rc
//
//  Created by 余笃 on 16/4/14.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (YDAddition)

/**
 *  获取图片颜色 -- 图片主颜色
 *
 *  @param image 目标图片
 *
 *  @return 图片主颜色
 */
+(UIColor *)getImageColor:(UIImage *)image;

@end
