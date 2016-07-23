//
//  RCChatListViewController.m
//  rc
//
//  Created by LittleMian on 16/6/23.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCChatListViewController.h"
#import "RCPrivateChatViewController.h"
#import "Masonry.h"
@interface RCChatListViewController ()

@end

@implementation RCChatListViewController
- (id)init
{
    if (self = [super init])
    {
        //设置需要显示哪些类型的会话
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                            @(ConversationType_DISCUSSION),
                                            @(ConversationType_CHATROOM),
                                            @(ConversationType_GROUP),
                                            @(ConversationType_APPSERVICE),
                                            @(ConversationType_SYSTEM)]];
        //设置需要将哪些类型的会话在会话列表中聚合显示
        [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                              @(ConversationType_GROUP)]];
        UIView *view = [[UIView alloc]init];
        UIImageView *imgeView = [[UIImageView alloc]init];
        imgeView.image = [UIImage imageNamed:@"heartbrokenIcon"];
        [view addSubview:imgeView];
        
        [imgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(view.mas_centerX);
            make.top.equalTo(view.mas_top);
            make.size.mas_equalTo(imgeView.image.size);
        }];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"暂时没有会话。";
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1.0];
        [view addSubview:label];
        CGSize labelSize = [self sizeWithText:label.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:14];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imgeView.mas_bottom).offset(10);
            make.centerX.equalTo(imgeView.mas_centerX).offset(10);
            make.width.mas_equalTo(labelSize.width+1);
            make.height.mas_equalTo(labelSize.height+1);
        }];

        CGFloat emptyViewHeight = imgeView.image.size.height+labelSize.height+1+10;
        CGFloat emptyViewWidth = imgeView.image.size.width>labelSize.width?imgeView.image.size.width:labelSize.width+1;
        view.frame = CGRectMake(kScreenWidth/2-emptyViewWidth/2 , kScreenHeight/2-emptyViewHeight/2, emptyViewWidth, emptyViewHeight);
        self.emptyConversationView = view;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setController];
    NSLog(@"%d",[[RCIMClient sharedRCIMClient]getTotalUnreadCount]);
}
#pragma mark - 设置导航栏
- (void)setController
{
    //设置导航栏
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
//     UIBarButtonItem *addChart = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"plus_icon2"] style:UIBarButtonItemStylePlain target:self action:@selector(addChart)];
//    [self.navigationItem setRightBarButtonItem:addChart];
    UIColor *color = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    self.conversationListTableView.backgroundColor = color;
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationItem.title = @"我的消息";

}
- (void)addChart
{
    
}
//- (void)rcConversationListTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}
//- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell isKindOfClass:[RCMessageCell class]])
//    {
//        RCMessageCell *messageCell = (RCMessageCell *)cell;
//        //messageCell.portraitImageView
//        UIImageView *portraitImageView= (UIImageView *)messageCell.portraitImageView;
//        portraitImageView.layer.cornerRadius = 10;
//    }else if ([cell isKindOfClass:[RCConversationCell class]])
//    {
//        NSLog(@"converstaion cell");
//        
//    }else if ([cell isKindOfClass:[RCTextMessageCell class]])
//    {
//        NSLog(@"textMessage cell");
//    }else if ([cell isKindOfClass:[RCImageMessageCell class]])
//    {
//        NSLog(@"imageMessage cell");
//    }else if ([cell isKindOfClass:[RCLocationMessageCell class]])
//    {
//        NSLog(@"locationMessage cell");
//    }else if ([cell isKindOfClass:[RCVoiceMessageCell class]])
//    {
//        NSLog(@"voiceMessage cell");
//    }else if ([cell isKindOfClass:[RCRichContentMessageCell class]])
//    {
//        NSLog(@"richContentMessage cell");
//    }else if ([cell isKindOfClass:[RCTipMessageCell class]])
//    {
//        NSLog(@"tipMessage cell");
//    }else
//    {
//        NSLog(@"baseMessage cell");
//    }
//    
//}
#pragma mark - 点击cell进入到聊天界面
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    RCConversationCell *cell = [self.conversationListTableView cellForRowAtIndexPath:indexPath];
    //新建一个聊天会话View Controller对象
    RCPrivateChatViewController *chat = [[RCPrivateChatViewController alloc]init];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chat.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    
    chat.targetId = cell.model.targetId;
    //设置聊天会话界面要显示的标题
    NSString *tittle = [NSString stringWithFormat:@"与%@聊天中",cell.model.conversationTitle];
    chat.title = tittle;
    //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];
}
- (void)backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  计算字体的长和宽
 *
 *  @param text 待计算大小的字符串
 *
 *  @param fontSize 指定绘制字符串所用的字体大小
 *
 *  @return 字符串的大小
 */
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
