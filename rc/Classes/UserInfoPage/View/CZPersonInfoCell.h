//
//  CZPersonInfoCell.h
//  rc
//
//  Created by AlanZhang on 16/2/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZPersonInfoCell : UITableViewCell
@property (nonatomic, strong) UILabel *tittle;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *personIcon;
@property (nonatomic, strong) UIImageView *indecatorImageView;

+ (instancetype)personInfoCellWithTableView:(UITableView *)tableView;
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@end
