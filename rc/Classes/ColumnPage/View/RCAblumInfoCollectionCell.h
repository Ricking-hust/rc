//
//  RCAblumInfoCollection.h
//  rc
//
//  Created by LittleMian on 16/7/13.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCAblumActivityModel;
@interface RCAblumInfoCollectionCell : UICollectionViewCell
/**
 *  设置cell的数据模型
 *
 *  @param model 数据模型
 */
- (void)setModel:(RCAblumActivityModel *)model;
/**
 *  设置响应链
 *
 *  @param view 响应链上的View
 */
- (void)setResponder:(UIView *)view;
@end
