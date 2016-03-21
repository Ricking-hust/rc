//
//  CZActivityDetailCell.m
//  rc
//
//  Created by AlanZhang on 16/1/17.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZActivityDetailCell.h"
#import "Masonry.h"
#import "ActivityModel.h"
@implementation CZActivityDetailCell

+ (instancetype)detailCellWithTableView:(UITableView*)tableView
{
    static NSString *reuseId = @"activityInfoCell";
    CZActivityDetailCell * cell = (CZActivityDetailCell*)[tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//禁用cell的点击事件
    
    return cell;
}
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        self.webView = webView;
        [self.contentView addSubview:self.webView];
    }
    return self;
}
- (void)setModel:(ActivityModel *)model
{
    _model = model;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:_model.acHtml]];
    [self.webView loadRequest:request];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = webView.frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
    
}
- (void)setSubViewsConstraint
{

    //添加约束
    [self.webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.width.mas_equalTo(kScreenWidth);
        make.height.equalTo(@10);
    }];

}

@end
