//
//  LewPopupBackgroundView.m
//  LewPopupViewController
//
//  Created by deng on 15/3/5.
//  Copyright (c) 2015年 pljhonglu. All rights reserved.
//

#import "LewPopupBackgroundView.h"

@implementation LewPopupBackgroundView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect
{

    CGContextRef context = UIGraphicsGetCurrentContext();
    size_t locationsCount = 2;
    CGFloat locations[2] = {1.0f, 1.0f};
    CGFloat colors[8] = {0.0f,0.0f,0.0f,0.5f //渐变的起始颜色RGB(r,g,b, apla)
                        ,0.0f,0.0f,0.0f,0.5f};//渐变的结束颜色(r,g,b, apla)
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //创造一个CGGradientRef,颜色是黑,黑,location分别是1,1
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
    CGColorSpaceRelease(colorSpace);

    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float radius = MIN(self.bounds.size.width , self.bounds.size.height) ;
    CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
}

@end
