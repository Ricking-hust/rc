//
//  RCHomeRefreshHeader.h
//  rc
//
//  Created by AlanZhang on 16/3/24.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "MJRefreshHeader.h"

@interface RCHomeRefreshHeader : MJRefreshHeader
@property (weak, nonatomic) UILabel *label;
@property (weak, nonatomic) UIImageView *logo;
@property (weak, nonatomic) UIActivityIndicatorView *loading;
@end
