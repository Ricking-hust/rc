//
//  CZCityButton.m
//  rc
//
//  Created by AlanZhang on 16/1/26.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZCityButton.h"
#define ImageW 15//图片的宽度

@implementation CZCityButton


//控件从xib/storyboard中创建时调用
-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        //设置图片的显示样式
        self.imageView.contentMode = UIViewContentModeCenter;
        self.themeColor = [UIColor colorWithRed:255.0/255.0 green:129.0/255.0 blue:3.0/255.0 alpha:1.0];
        [self setTitleColor:_themeColor forState:UIControlStateNormal];
    }

    return self;

}

//设置标题的位置
-(CGRect)titleRectForContentRect:(CGRect)contentRect{

    CGFloat titleW = contentRect.size.width - ImageW;
    CGFloat titleH = contentRect.size.height;
    return CGRectMake(0, 0, titleW, titleH);
}

//设置图片的位置
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat imageW = ImageW;
    CGFloat imageH = contentRect.size.height;
    CGFloat imageX = contentRect.size.width - ImageW;
    //self.imageView.contentMode = UIViewContentModeCenter;
#warning 在此方法，UIButton的子控件都是空，不能在此地设置图片的显示样式

    //NSLog(@"%@",self.imageView);
    return CGRectMake(imageX, 0, imageW, imageH);

}

//#pragma mark 去除按钮的高亮状态
//-(void)setHighlighted:(BOOL)highlighted
//{
//    NSLog(@"highligthed");
//}
//- (void) setSelected:(BOOL)selected
//{
//    NSLog(@"setSelected");
//}


@end
