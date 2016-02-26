//
//  CZNavigationViewController.m
//  rc
//
//  Created by AlanZhang on 16/1/15.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZNavigationViewController.h"
#import "UINavigationBar+Awesome.h"
#import "CZActivityInfoViewController.h"

@interface CZNavigationViewController ()

@end

@implementation CZNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%s",__func__);
    
    //    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    
}

#pragma mark 类第一次使用的时候被调用
+(void)initialize{
    NSLog(@"%s",__func__);
    
    
    
    // 设置主题
    
    /**设置导航条的背景图片注意点
     * 1.在ios7以上，背景图片的高度一定要64(点)
     * 2.背景图片的宽度无限制，1点，自动会拉伸
     * 3.如果是通过导航控制器获取的导航条来设置背景，它是局部
     *   self.navigationController.navigationBar
     * 4.如果想设置一次导航栏的背景，这个导航条的对象，通过导航条的一个类方法获取的就可以 [UINavigationBar appearance]
     
     */
    // 设置当前导航控制器的背景
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    
#warning 一般设置导航条背景，不会在导航控制器的子控制器里设置
    // 1.设置导航条的背题图片 --- 设置全局
    UINavigationBar *navBar = [UINavigationBar appearance];
    //[navBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    
    [navBar lt_setBackgroundColor:[UIColor whiteColor]];
    [navBar setShadowImage:[UIImage new]];
    // 2.UIApplication设置状态栏的样式
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // 3.设置导航条标题的字体和颜色
    NSDictionary *titleAttr = @{
                                NSForegroundColorAttributeName:[UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:13.0/255.0 alpha:1.0],
                                NSFontAttributeName:[UIFont systemFontOfSize:18]
                                };
    [navBar setTitleTextAttributes:titleAttr];
    
    //设置返回按钮的样式
    //tintColor是用于导航条的所有Item
    navBar.tintColor = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:13.0/255.0 alpha:1.0];
    
    UIBarButtonItem *navItem = [UIBarButtonItem appearance];
    //
    //    //是改变整个按钮背影
    [navItem setBackButtonBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    //设置Item的字体大小
    [navItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    
}

#pragma mark 设置状态栏的样式
//如果有导航控制器的，状态栏的样式要在导航控制器里设置，不能在子控制器里设置
//这只方式只能针对局部的控制器
//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}



#pragma mark 导航控制器的子控制器被pop[移除]的时候会调用
-(UIViewController *)popViewControllerAnimated:(BOOL)animated{
    NSLog(@"%s",__func__);
    return [super popViewControllerAnimated:animated];
}

#pragma mark 导航控制器的子控制器被push 的时候会调用
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    NSLog(@"%s",__func__);
    
    //设置 push 新控制器的时候 隐藏Tabbar
    viewController.hidesBottomBarWhenPushed = YES;
    return [super pushViewController:viewController animated:animated];
    
}
@end

