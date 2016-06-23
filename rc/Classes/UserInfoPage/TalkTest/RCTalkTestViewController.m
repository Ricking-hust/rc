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
#import "Masonry.h"
@interface RCTalkTestViewController()<UITextFieldDelegate>
@property(nonatomic, strong) UITextField *textField ;
@property(nonatomic, assign) CGFloat height ;
@end
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
    
    self.textField = [[UITextField alloc]init];
    self.textField.delegate = self;
    self.textField.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    self.height = keyboardRect.size.height;
    
    //设置动画的名字
    [UIView beginAnimations:@"Animation" context:nil];
    //设置动画的间隔时间
    [UIView setAnimationDuration:0.60];
    //⭐️使用当前正在运行的状态开始下一段动画
    [UIView setAnimationBeginsFromCurrentState: YES];
    //设置视图移动的位移
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - self.height, self.view.frame.size.width, self.view.frame.size.height);
    //设置动画结束
    [UIView commitAnimations];
   // NSLog(@"%f",self.height);
//    CGFloat x = self.view.bounds.origin.x;
//    CGFloat y = self.view.bounds.origin.y;
//    CGFloat width = self.view.bounds.size.width;
//    CGFloat height1 = self.view.bounds.size.height;
//    CGFloat newY = 20 + height1 + height;
//    [self.view setBounds:CGRectMake(x, newY, width, height1)];
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    
}
//***更改frame的值***//
//在UITextField 编辑之前调用方法
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    //设置动画的名字
//    [UIView beginAnimations:@"Animation" context:nil];
//    //设置动画的间隔时间
//    [UIView setAnimationDuration:0.20];
//    //⭐️使用当前正在运行的状态开始下一段动画
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    //设置视图移动的位移
//    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 258, self.view.frame.size.width, self.view.frame.size.height);
//    //设置动画结束
//    [UIView commitAnimations];
}
//在UITextField 编辑完成调用方法
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //设置动画的名字
    [UIView beginAnimations:@"Animation" context:nil];
    //设置动画的间隔时间
    [UIView setAnimationDuration:0.60];
    //⭐️使用当前正在运行的状态开始下一段动画
    [UIView setAnimationBeginsFromCurrentState: YES];
    //设置视图移动的位移
    NSLog(@"%f",self.height);
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + self.height, self.view.frame.size.width, self.view.frame.size.height);
    //设置动画结束
    [UIView commitAnimations];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textField resignFirstResponder];
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
//    NSNumber *conersation = [[NSNumber alloc]initWithInt:ConversationType_PRIVATE];
//    NSNumber *conersation1 = [[NSNumber alloc]initWithInt:ConversationType_PRIVATE];
//    
//    RCConversation *talk = [[RCConversation alloc]init];
//    talk.targetId = @"15";
//    talk.conversationTitle = @"与21号聊天";
//    
//    RCConversationModel *model = [[RCConversationModel alloc]init:RC_CONVERSATION_MODEL_TYPE_COLLECTION conversation:talk extend:nil];
//    
//    RCConversationListViewController *vc = [[RCConversationListViewController alloc]initWithDisplayConversationTypes:@[conersation] collectionConversationType:@[conersation,conersation1]];
//    
//    NSMutableArray *talkList = [[NSMutableArray alloc]init];
//    [talkList addObject:model];
//    vc.conversationListDataSource = talkList;
//    [vc didTapCellPortrait:model];
    //新建一个聊天会话View Controller对象
    RCConversationViewController *chat = [[RCConversationViewController alloc]init];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chat.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chat.targetId = @"15";
    //设置聊天会话界面要显示的标题
    chat.title = @"与15号聊天";
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
    
    //[self.navigationController pushViewController:vc animated:YES];
//    NSString *urlStr = @"http://appv2.myrichang.com/Home/Message/getToken";
//    NetWorkingRequestType type = GET;
//    NSString *usr_id = [userDefaults objectForKey:@"userId"];
//    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:usr_id,@"usr_id",nil];
//    [RCNetworkingRequestOperationManager request:urlStr requestType:type parameters:parameters completeBlock:^(NSData *data) {
//        id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//        NSString *token = [dict valueForKey:@"token"];
//    
//        static dispatch_once_t pred;
//        dispatch_once(&pred, ^{
//           
//            [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
//                NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
//            } error:^(RCConnectErrorCode status) {
//                
//            } tokenIncorrect:^{
//                
//            }];
//        });
//        
////        RCConversationViewController *vc = [[RCConversationViewController alloc]initWithConversationType:ConversationType_PRIVATE targetId:@"21"];
////        [self.navigationController pushViewController:vc animated:YES];
//
//        NSNumber *conersation = [[NSNumber alloc]initWithInt:ConversationType_PRIVATE];
//        NSNumber *conersation1 = [[NSNumber alloc]initWithInt:ConversationType_PRIVATE];
//        
//        RCConversation *talk = [[RCConversation alloc]init];
//        talk.targetId = @"21";
//        talk.conversationTitle = @"与21号聊天";
//        
//        RCConversationModel *model = [[RCConversationModel alloc]init:RC_CONVERSATION_MODEL_TYPE_COLLECTION conversation:talk extend:nil];
//        
//        RCConversationListViewController *vc = [[RCConversationListViewController alloc]initWithDisplayConversationTypes:@[conersation] collectionConversationType:@[conersation,conersation1]];
//        
//        NSMutableArray *talkList = [[NSMutableArray alloc]init];
//        [talkList addObject:model];
//        vc.conversationListDataSource = talkList;
//        [vc didTapCellPortrait:model];
//        [self.navigationController pushViewController:vc animated:YES];
//        
//    } errorBlock:^(NSError *error) {
//        NSLog(@"请求失败:%@",error);
//    }];
//
    


}
@end
