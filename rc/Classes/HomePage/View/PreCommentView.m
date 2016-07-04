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
        if (!_collectTooLab) {
            UILabel *collectToo = [[UILabel alloc]init];
            _collectTooLab = collectToo;
            [self addSubview:_collectTooLab];
        }
        if (!_checkMoreBtn) {
            UIButton *checMore = [[UIButton alloc]init];
            _checkMoreBtn = checMore;
            [self addSubview:_checkMoreBtn];
        }
        _preCommentView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.delegate = self;
            tableView.dataSource = self;
            [tableView registerClass:[RCCommentcell class] forCellReuseIdentifier:kCellIdentifier_CommentCell];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self addSubview:tableView];
            tableView;
        });

    }
    return self;
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
    return 100;
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 3)];
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];;
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
