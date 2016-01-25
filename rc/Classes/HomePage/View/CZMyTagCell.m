//
//  CZMyTagCell.m
//  rc
//
//  Created by AlanZhang on 16/1/22.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZMyTagCell.h"

@implementation CZMyTagCell

+ (instancetype)initWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"CZMyTagCell";//这里的cellID就是cell的xib对应的名称
    
    CZMyTagCell *cell = (CZMyTagCell *)[tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if(nil == cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    //设置行高
    cell.rowHeight = 200;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//禁用cell的点击事件

    return cell;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
