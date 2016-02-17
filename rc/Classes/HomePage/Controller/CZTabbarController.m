//
//  CZTabbarController.m
//  rc
//
//  Created by AlanZhang on 16/1/15.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZTabbarController.h"

@interface CZTabbarController ()

@end

@implementation CZTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%s",__func__);
    
    // 拿到 TabBar 在拿到想应的item
    UITabBar *tabBar = self.tabBar;
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:3];
    // 对item设置相应地图片
    item0.selectedImage = [[UIImage imageNamed:@"RCIconSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    item0.image = [[UIImage imageNamed:@"RCIconNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item1.selectedImage = [[UIImage imageNamed:@"ColumnIconSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    item1.image = [[UIImage imageNamed:@"ColumnIconNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item2.selectedImage = [[UIImage imageNamed:@"ScheduleIconSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"ScheduleIconNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item3.selectedImage = [[UIImage imageNamed:@"MyIconSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    item3.image = [[UIImage imageNamed:@"MyIconNormal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置item字体颜色
    self.tabBar.tintColor = [UIColor colorWithRed:255.0/255.0 green:129.0/255.0 blue:3.0/255.0 alpha:1.0];
}
/*
 *自定义控件
 1.在initWithFrame初始化的方法，添加子控件
 2.layoutSubviews 布局子控件frm
 */

/*
 //调用控件的init方法【[[UIView alloc] init]】 的时候被调用  接着还会调用initWithFrame
 //-(instancetype)init
 
 
 //调用控件的init方法【[[UIView alloc] initWithFrame]】 的时候被调用
 //-(instancetype)initWithFrame:(CGRect)frame
 
 
 //调用控件的创建从xib/storybaord 的时候被调用
 -(id)initWithCoder:(NSCoder *)aDecoder
 */

//-(instancetype)initWithFrame:(CGRect)frame{
//    if (self = [super initWithFrame:frame]) {
//        //初始化按钮
//        [self setupBtns];
//    }
//
//    return self;
//}


//#pragma mark 初始化按钮
//-(void)setupBtns{
//
//    //自定义的tabbar添加5个按钮
//    for (NSInteger i = 0; i < 4; i++) {
////        // 获取普通状态的图片名称
////        NSString *normalImg = [NSString stringWithFormat:@"TabBar%ld", i+1];
////
////        // 获取选中的图片
////        NSString *selImg = [NSString stringWithFormat:@"TabBar%ldSel", i + 1];
//
//        // 获取普通状态的图片名称
//        NSString *normalImg = [NSString stringWithFormat:@"shopping"];
//
//        // 获取选中的图片
//        NSString *selImg = [NSString stringWithFormat:@"shopping"];
//
//
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setBackgroundImage:[UIImage imageNamed:normalImg] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:selImg] forState:UIControlStateSelected];
//
//
//        //监听事件
//        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        //绑定tag
//        btn.tag = i;
//        [self addSubview:btn];
//
//        //默认选中第一个按钮为选中
//        if (i == 0) {
//            btn.selected = YES;
//            self.selectedBtn = btn;
//        }
//
//    }
//
//
//}
//
//-(void)layoutSubviews{
//    [super layoutSubviews];
//
//    //布局子控件
//    //按钮宽度与高度
////    CGFloat btnW = self.bounds.size.width / 4;
////    CGFloat btnH = self.bounds.size.height;
//    CGFloat btnW = 30;
//    CGFloat btnH = 30;
//
//    //自定义的tabbar添加5个按钮
//    for (NSInteger i = 0; i < 4; i++) {
//
//        //获取btn
//        UIButton *btn = self.subviews[i];
//
//        //设置按钮的frm
//        btn.frame = CGRectMake(btnW * i, 0, btnW, btnH);
//
//    }
//
//}
//
//-(void)btnClick:(UIButton *)btn{
//
//    //一点击通知代理
//    if ([self.delegate respondsToSelector:@selector(tabbar:didSelectedFrom:to:)]) {
//        [self.delegate tabbar:self didSelectedFrom:self.selectedBtn.tag to:btn.tag];
//    }
//
//#warning 开发过程，首先针对64位开发，苹果开发的应用上架，必需支持64位
//    NSLog(@"%ld",btn.tag);
//
//    //取消之前选中
//    self.selectedBtn.selected = NO;
//
//    //设置当前选中
//    btn.selected = YES;
//    self.selectedBtn = btn;
//
//
//}


@end
