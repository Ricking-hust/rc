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
            _collectTooH = 0;
            UIButton *collectToo = [[UIButton alloc]init];
            [collectToo.titleLabel setFont:[UIFont systemFontOfSize:12]];
            [collectToo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            collectToo.backgroundColor = [UIColor whiteColor];
            _collectTooBtn = collectToo;
            [self addSubview:_collectTooBtn];
        }
        if (!_checkMoreBtn) {
            _checkMoreBtnH = 0;
            UIButton *checkMore = [[UIButton alloc]init];
            _checkMoreBtn = checkMore;
            [self addSubview:_checkMoreBtn];
        }
        _preCommentView = ({
            _preCommentViewH = 0;
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
        if (!_backView) {
            _backView = [[UIView alloc]init];
            _backView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
            [self addSubview:_backView];
        }
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
        make.height.mas_equalTo(self.collectTooH);
    }];
    
    [self.preCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectTooBtn.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.mas_equalTo(200);
    }];
}

-(void)setSubViewsValue{
    [self.collectTooBtn setTitle:@"大家都收藏了" forState:UIControlStateNormal];
    [self.collectTooBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.collectTooBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 30)];
    [self.checkMoreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
}

#pragma mark - TableView 数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RCCommentcell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CommentCell forIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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
