//
//  CZTabbarController.m
//  rc
//
//  Created by AlanZhang on 16/1/15.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZTabbarController.h"
#import "CZTabbar.h"

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
    item0.selectedImage = [[UIImage imageNamed:@"shopping"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    item0.image = [[UIImage imageNamed:@"shopping"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item1.selectedImage = [[UIImage imageNamed:@"shopping"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    item1.image = [[UIImage imageNamed:@"shopping"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item2.selectedImage = [[UIImage imageNamed:@"shopping"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"shopping"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    item3.selectedImage = [[UIImage imageNamed:@"shopping"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    item3.image = [[UIImage imageNamed:@"shopping"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //设置item字体颜色
    self.tabBar.tintColor = [UIColor colorWithRed:255.0/255.0 green:129.0/255.0 blue:3.0/255.0 alpha:1.0];

//#warning 系统的tabbarbutton 里面小图片 30x30
//    //自己写一个tabbar 替换 系统Tabbar
//    //自定义一个tabbar
//    CZTabbar *mTabbar = [[CZTabbar alloc] initWithFrame:self.tabBar.bounds];
//    //mTabbar.backgroundColor = [UIColor redColor];
//    
//    
//    //设置代理
//    mTabbar.delegate = self;
//    
//    //把自定义的tabbar添加到 系统的tabbar上
//    [self.tabBar addSubview:mTabbar];
//    
//    UIButton *btn = [[UIButton alloc]init];
    
    
}

#pragma mark 自定义Tabbar的代理
-(void)tabbar:(CZTabbar *)tabbar didSelectedFrom:(NSInteger)from to:(NSInteger)to{
    //切换tabbar控制器的子控件器
    self.selectedIndex = to;
    
}




@end
