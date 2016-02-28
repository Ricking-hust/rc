//
//  CZMyTagCell.h
//  rc
//
//  Created by AlanZhang on 16/1/22.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZMyTagCell : UITableViewCell
@property (nonatomic, strong) NSMutableArray *myTagButton;
@property (nonatomic, strong) NSArray *myTags;

/**
 *  快速创建对象实例
 *
 *  @param tableView cell所在的tableView
 *
 *  @return 返回实例
 */
+ (instancetype)initWithTableView:(UITableView *)tableView;
@end
