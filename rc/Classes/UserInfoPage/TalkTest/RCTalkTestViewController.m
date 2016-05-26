//
//  RCTalkTestViewController.m
//  rc
//
//  Created by AlanZhang on 16/5/25.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCTalkTestViewController.h"
#import <RongIMKit/RongIMKit.h>
#import <RongIMLib/RongIMLib.h>
@implementation RCTalkTestViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 20)];
    button.backgroundColor = [UIColor blackColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)click:(id)button
{
    [[RCIM sharedRCIM]connectWithToken:@"cz72QbPiNJkDNukiWv7iRqQ7HNppyUlZZb+Bu0BEgHrCripXhQ1uh9fl2b9osuXygIv91DzL6pPukxXeOHu0sg==" success:^(NSString *userId) {
        
        NSLog(@"%@",userId);
        dispatch_async(dispatch_get_main_queue(), ^{
            RCConversationViewController *vc = [[RCConversationViewController alloc]initWithConversationType:ConversationType_PRIVATE targetId:@"test2"];
            [self.navigationController pushViewController:vc animated:YES];
            
        });
    } error:^(RCConnectErrorCode status) {
        
    } tokenIncorrect:^{
        
    }];
    
    

}
@end
