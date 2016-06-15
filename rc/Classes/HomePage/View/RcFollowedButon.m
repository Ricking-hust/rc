//
//  RcFollowedButon.m
//  rc
//
//  Created by 余笃 on 16/6/15.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RcFollowedButon.h"
#import "Masonry.h"

@implementation RcFollowedButon

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:3.0];
        self.layer.borderWidth = 0.7;
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorRef = CGColorCreate(colorSpace,(CGFloat[]){ 255.0/255.0, 129.0/255.0, 3.0/255.0, 1 });
        self.layer.borderColor = colorRef;
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:themeColor forState:UIControlStateNormal];
    }
    return self;
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleW = contentRect.size.width - contentRect.size.height;
    CGFloat titleH = contentRect.size.height;
    CGFloat titleX = contentRect.size.width + 7;
    return CGRectMake(titleX, 0, titleW, titleH);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = contentRect.size.height;
    CGFloat imageH = contentRect.size.height;
    
    return CGRectMake(0, 0, imageW, imageH);
    
}

@end
