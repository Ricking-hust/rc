//
//  RCBarButton.m
//  rc
//
//  Created by AlanZhang on 16/3/26.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCBarButton.h"
#define ImageW 30//图片的宽度

@implementation RCBarButton

- (id)init
{
    if (self = [super init])
    {
        //设置图片的显示样式
//        self.imageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}
//设置标题的位置
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    NSLog(@"%f",contentRect.size.width);
    UIImage *image = [UIImage imageNamed:@"backIcon_white"];
    CGFloat titleW = contentRect.size.width - image.size.width;
    CGFloat titleH = contentRect.size.height;
    CGFloat titleX = image.size.width + 5;
    return CGRectMake(titleX, 0, titleW, titleH);
}

//设置图片的位置
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    UIImage *image = [UIImage imageNamed:@"backIcon_white"];
    CGFloat imageW = image.size.width;
    CGFloat imageH = image.size.height;
#warning 在此方法，UIButton的子控件都是空，不能在此地设置图片的显示样式
    
    return CGRectMake(0, (contentRect.size.height - image.size.height)/2, imageW, imageH);
    
}

#pragma mark 去除按钮的高亮状态
//-(void)setHighlighted:(BOOL)highlighted{}



@end
