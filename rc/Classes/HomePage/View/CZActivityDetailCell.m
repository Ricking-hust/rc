//
//  CZActivityDetailCell.m
//  rc
//
//  Created by AlanZhang on 16/1/17.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZActivityDetailCell.h"
#import "ActivityIntroduction.h"

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
        //创建子控件
        UIWebView *webView = [[UIWebView alloc]init];
        self.webView = webView;
        [self.contentView addSubview:self.webView];
    }
    return self;
}
- (void)setAcIntroduction:(ActivityIntroduction *)acIntroduction
{
    _acIntroduction = acIntroduction;
    [self setSubViewsContent];
    [self setSubViewsConstraint];
    
}
- (void)setSubViewsContent
{

}
- (void)setSubViewsConstraint
{
    //添加约束

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
