//
//  RCUsrRecomnendView.m
//  rc
//
//  Created by 余笃 on 16/6/13.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCPubRecommendView.h"
#import "RCPubRecViewCell.h"
#import "Masonry.h"

@interface RCPubRecommendView ()

@property (nonatomic, strong) UITableView *pubRecTableView;

@end

@implementation RCPubRecommendView

-(id)init{
    if (self = [super init]) {
        self.pubList = [[PublisherList alloc]init];
        _pubRecTableView = ({
            UITableView *tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor clearColor];
            tableView.delegate = self;
            tableView.dataSource = self;
            [tableView registerClass:[RCPubRecViewCell class] forCellReuseIdentifier:kCellIdentifier_PubRecommendCell];
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self addSubview:tableView];
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            tableView;
        });
    }
    return self;
}

#pragma mark - TableView 数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
    //return _pubList.list.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RCPubRecViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PubRecommendCell forIndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
