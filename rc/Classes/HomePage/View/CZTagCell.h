//
//  CZTagCell.h
//  rc
//
//  Created by AlanZhang on 16/1/22.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZTagCell : UITableViewCell
@property (nonatomic, assign)CGFloat rowHeight;               //行高

/**
 *  快速创建对象实例
 *  
 *  @param tableView cell所在的tableView
 * 
 *  @return 返回实例
 */
+ (instancetype)initWithTableView:(UITableView *)tableView;

/**
 *  实例方法 重写构造方法，初始化（创建自定义cell内部的子控件）
 *
 *  @param style cell的类型
 *
 *  @param reuseIdentifier 可重用的标识
 *
 *  @return 返回实例对象本身
 */
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
