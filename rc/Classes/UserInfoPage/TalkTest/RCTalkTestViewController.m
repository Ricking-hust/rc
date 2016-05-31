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
#import "RCNetworkingRequestOperationManager.h"
@implementation RCTalkTestViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 20)];
    button.backgroundColor = [UIColor blackColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *upButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 150, 100, 20)];
    [upButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.view addSubview:upButton];
    [upButton addTarget:self action:@selector(up:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)up:(UIButton *)button
{
    NSString *urlStr = @"http://app.myrichang.com/home/Person/modifyAccount";
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"21",@"usr_id",@"2",@"op_type",@"冬阳",@"usr_name",nil];
    [RCNetworkingRequestOperationManager uploadTask:urlStr requestType:POST parameters:dic completeBlock:^(NSData *data) {
        //解析数据
        id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        NSLog(@"%@",[dict valueForKey:@"msg"]);
    } errorBlock:^(NSError *error) {
        NSLog(@"error");
    }];
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
