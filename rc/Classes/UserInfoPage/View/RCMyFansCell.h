//
//  RCMyFocusCell.h
//  rc
//
//  Created by LittleMian on 16/6/20.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCMyFansModel;
@interface RCMyFansCell : UITableViewCell
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userSignLabel;
@property (nonatomic, strong) UIButton *focusButton;
@property (nonatomic, strong) UIView *segmentLineView;
@property (nonatomic, strong) UIView *view;//父控制器的View
@property (nonatomic, assign) BOOL isLastCell;
@property (nonatomic, strong) RCMyFansModel *model;
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
