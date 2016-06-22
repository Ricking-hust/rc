//
//  RCMyFocusCell.h
//  rc
//
//  Created by LittleMian on 16/6/21.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCMyFocusModel;
@interface RCMyFocusCell : UITableViewCell
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UIView *segmentView;
@property (nonatomic, assign) BOOL isLastCell;
@property (nonatomic, strong) RCMyFocusModel *model;
/**
 *  生成可复用的Cell
 *
 *  @param tableView cell所在的tableView
 *
 *  @return 返回生成的Cell
 */
+ (instancetype)cellWithTableView:(UITableView*)tableView;
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
