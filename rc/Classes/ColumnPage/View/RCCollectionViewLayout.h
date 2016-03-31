//
//  RCCollectionViewLayout.h
//  rc
//
//  Created by AlanZhang on 16/3/31.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RCCollectionViewLayout;
@class RCCollectionView;
@protocol CustomCollectionViewLayoutDelegate <NSObject>
@required
/*通过代理获得每个cell的高度(之所以用代理取得高度的值，就是为了解耦，这里定义的LFWaterFlowLayout不依赖与任务模型数据)*/
- (CGFloat)collectionView:(RCCollectionView *)collectionView waterFlowLayout:(RCCollectionViewLayout *)waterFlowLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPath;

@end

@interface RCCollectionViewLayout : UICollectionViewFlowLayout
/*cell的列间距*/
@property (nonatomic,assign) CGFloat columnMargin;
/*cell的行间距*/
@property (nonatomic,assign) CGFloat rowMargin;
/*cell的top,right,bottom,left间距*/
@property (nonatomic,assign) UIEdgeInsets insets;
/*显示多少列*/
@property (nonatomic,assign) NSInteger count;

@property(assign, nonatomic) id<CustomCollectionViewLayoutDelegate> layoutDelegate;

@end
