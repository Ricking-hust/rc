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




-(void)setpubList{
    if (!_pubList) {
        NSDictionary *pubDic1 = @{
                                  @"publisher_id":@"1",
                                  @"publisher_pic":@"http://img.myrichang.com/img/city/1.png",
                                  @"publisher_name":@"北京市",
                                  @"publisher_sign":@"我是一号",
                                  @"follewed":@"100+"
                                  };
        
        NSDictionary *pubDic2 = @{
                                  @"publisher_id":@"2",
                                  @"publisher_pic":@"http://img.myrichang.com/img/city/2.png",
                                  @"publisher_name":@"上海市",
                                  @"publisher_sign":@"楼上我不服,楼上我不服,楼上我不服,楼上我不服,楼上我不服,楼上我不服,楼上我不服,楼上我不服,楼上我不服,楼上我不服,楼上我不服,楼上我不服,楼上我不服,楼上我不服,楼上我不服,楼上我不服,楼上我不服,",
                                  @"follewed":@"150+"
                                  };
        
        NSArray *pubAry = [NSArray arrayWithObjects:pubDic1,pubDic2, nil];
        
        _pubList = [[PublisherList alloc]initWithArray:pubAry];;
    }
    
    [self.pubRecTableView reloadData];
}

#pragma mark - TableView 数据源
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _pubList.list.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RCPubRecViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier_PubRecommendCell forIndexPath:indexPath];
    cell.pubModel = _pubList.list[indexPath.section];
    [cell setSubViewValue];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

//section头部间距
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 6)];
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];;
    return view;
}

////section底部间距
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 5;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 5)];
//    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];;
//    return view;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



@end
