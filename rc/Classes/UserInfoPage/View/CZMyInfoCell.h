//
//  CZMyInfoCell.h
//  rc
//
//  Created by AlanZhang on 16/2/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZMyInfoCell : UITableViewCell
@property (nonatomic, strong) UIImageView *imgIcon;
@property (nonatomic, strong) UILabel *contentLable;
@property (nonatomic, strong) UIImageView *indicatorImageView;
@property (nonatomic, strong) UIView *separator;

+ (instancetype) myInfoCellWithTableView :(UITableView *)tableView;
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
