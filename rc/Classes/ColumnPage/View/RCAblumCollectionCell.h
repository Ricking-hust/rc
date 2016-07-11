//
//  CSAblumCollectionCell.h
//  rc
//
//  Created by LittleMian on 16/7/11.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCAblumCollectionCell : UICollectionViewCell
/**
 *  设置图片
 *
 *  @param image 图片
 */
- (void)setPicture:(UIImage *)image;
/**
 *  设置标题
 *
 *  @param tittle 标题
 */
- (void)setTittle:(NSString *)tittle;
/**
 *  设置响应链
 *
 *  @param view 响应链上的View
 */
- (void)setResponder:(UIView *)view;
@end
