//
//  PreCommentView.m
//  rc
//
//  Created by 余笃 on 16/7/4.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "PreCommentView.h"
#import "RCCommentcell.h"
#import "Masonry.h"

@interface PreCommentView ()

@end

@implementation PreCommentView

-(id)initWithFrame:(CGRect)frame{
    if(self =[super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
        if (!_showCommentBtn) {
            UIButton *showComBtn = [[UIButton alloc]init];
            [showComBtn setImage:[UIImage imageNamed:@"moreCom_icon"] forState:UIControlStateNormal];
            showComBtn.backgroundColor = [UIColor whiteColor];
            _showCommentBtn = showComBtn;
            [self addSubview:_showCommentBtn];
        }
        
        if (!_collectTooBtn) {
            UIButton *collectToo = [[UIButton alloc]init];
            [collectToo.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [collectToo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            collectToo.backgroundColor = [UIColor whiteColor];
            _collectTooBtn = collectToo;
            [self addSubview:_collectTooBtn];
        }
        if (!_checkMoreBtn) {
            UIButton *checkMore = [[UIButton alloc]init];
            [checkMore.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [checkMore setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            _checkMoreBtn = checkMore;
            [self addSubview:_checkMoreBtn];
        }
        _preCommentView = ({
            UITableView *tableView = [[UITableView alloc]init];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.delegate = self;
            tableView.dataSource = self;
            //tableView.estimatedRowHeight = 80;
            [tableView registerClass:[RCCommentcell class] forCellReuseIdentifier:kCellIdentifier_CommentCell];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self addSubview:tableView];
            tableView;
        });
        
    }
    return self;
}

-(void)layoutSubviews{
    [self.showCommentBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(35);
    }];
    
    [self.collectTooBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.showCommentBtn.mas_bottom).offset(10);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    [self.preCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectTooBtn.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(210);
    }];
    
    [self.checkMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.preCommentView.mas_bottom).offset(8);
        make.right.equalTo(self.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(65, 20));
    }];
}

-(void)setSubViewsValue{
    [self.collectTooBtn setTitle:@"大家都收藏了" forState:UIControlStateNormal];
    [self.collectTooBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.collectTooBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 30)];
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"查看更多"]];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    [self.checkMoreBtn setAttributedTitle:content forState:UIControlStateNormal];
}

-(void)showOrDissMissCommentWith:(BOOL)isShow{
    if (isShow) {
        self.collectTooBtn.hidden = NO;
        self.checkMoreBtn.hidden = NO;
        self.preCommentView.hidden = NO;
    } else {
        self.collectTooBtn.hidden = YES;
        self.checkMoreBtn.hidden = YES;
        self.preCommentView.hidden = YES;
    }
}

#pragma mark - TableView 数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

//-(void)testGet{
//    NSDictionary *dic1 = @{
//                           @"comment_id":@"1",
//                           @"usr_id":@"6",
//                           @"usr_name":@"逃跑计划",
//                           @"usr_pic":@"http://img.myrichang.com/img/src/logo.png",
//                           @"father_comment_id":@"0",
//                           @"comment_time":@"2015年7月20日 15：32",
//                           @"comment_content":@"再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见",
//                           @"comment_praise_num":@"7",
//                           @"father_comment_usr_id":@"0",
//                           @"father_comment_usr_name":@"0",
//                           @"father_comment_content":@"0",
//                           @"praised":@"1"
//                           };
//    
//    NSDictionary *dic2 = @{
//                           @"comment_id":@"2",
//                           @"usr_id":@"5",
//                           @"usr_name":@"水木年华",
//                           @"usr_pic":@"http://img.myrichang.com/upload/14637245657abe0d0a55a8cefc5270d29c90a6157a.png",
//                           @"father_comment_id":@"1",
//                           @"comment_time":@"2015年7月20日 22：13",
//                           @"comment_content":@"启程",
//                           @"comment_praise_num":@"89",
//                           @"father_comment_usr_id":@"6",
//                           @"father_comment_usr_name":@"逃跑计划",
//                           @"father_comment_content":@"再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见再见",
//                           @"praised":@"0"
//                           };
//    
//    NSArray *commentAry = [NSArray arrayWithObjects:dic1,dic2, nil];
//    
//    self.commentList = [[CommentList alloc]initWithArray:commentAry];;
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RCCommentcell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CommentCell forIndexPath:indexPath];
    cell.isPreComment = YES;
    cell.commentModel = self.commentList.list[indexPath.section];
    [cell layoutSubviews];
    [cell setSubViewValue];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 3)];
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
