//
//  CZMoreTimeCell.h
//  rc
//
//  Created by AlanZhang on 16/2/13.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZMoreTimeCell : UITableViewCell
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) UIImageView *imgView;
+(instancetype)moreTimeCell;

@end
