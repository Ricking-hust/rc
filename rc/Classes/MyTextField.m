//
//  MyTextField.m
//  rc
//
//  Created by 余笃 on 16/3/4.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField

-(void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetWidth(self.frame), 0.5));
}

@end
