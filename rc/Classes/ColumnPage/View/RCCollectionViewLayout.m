//
//  RCCollectionViewLayout.m
//  rc
//
//  Created by AlanZhang on 16/3/31.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCCollectionViewLayout.h"
#import "RCCollectionView.h"
#include <sys/sysctl.h>
@interface RCCollectionViewLayout ()

/* Key: 第几列; Value: 保存每列的cell的底部y值 */
@property (nonatomic,strong) NSMutableDictionary *cellInfo;
@end
@implementation RCCollectionViewLayout

#pragma mark - 初始化属性
- (instancetype)init {
    self = [super init];
    if (self) {
        self.columnMargin = 10;
        self.rowMargin = 10;
//        UIEdgeInsetsMake(<#CGFloat top#>, <#CGFloat left#>, <#CGFloat bottom#>, <#CGFloat right#>)
//        if ([self currentDeviceSize] == IPhone5)
//        {
//            self.insets = UIEdgeInsetsMake(0, 15, 15, 15);
//        }else if ([self currentDeviceSize] == IPhone6)
//        {
//            self.insets = UIEdgeInsetsMake(0, 15, 10, 7.5);
//        }else
//        {
//            self.insets = UIEdgeInsetsMake(0, 15, 15, 15);
//        }
        self.insets = UIEdgeInsetsMake(15, 15, 15, 15);
        self.count = 2;
    }
    return self;
}

- (NSMutableDictionary *)cellInfo {
    if (!_cellInfo) {
        _cellInfo = [NSMutableDictionary dictionary];
    }
    return _cellInfo;
}

#pragma mark - 重写父类的方法，实现瀑布流布局
#pragma mark - 当尺寸有所变化时，重新刷新
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    // 可以在每次旋转屏幕的时候，重新计算
    for (int i=0; i<self.count; i++) {
        NSString *index = [NSString stringWithFormat:@"%d",i];
        self.cellInfo[index] = @(self.insets.top);
    }
}

#pragma mark - 处理所有的Item的layoutAttributes
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    // 每次重新布局之前，先清除掉以前的数据(因为屏幕滚动的时候也会调用)
    __weak typeof (self) wSelf = self;
    [self.cellInfo enumerateKeysAndObjectsUsingBlock:^(NSString *columnIndex, NSNumber *minY, BOOL *stop) {
        wSelf.cellInfo[columnIndex] = @(wSelf.insets.top);
    }];
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (int i=0; i<count; i++) {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [array addObject:attrs];
    }
    
    return array;
}

#pragma mark - 处理单个的Item的layoutAttributes
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 获取cell底部Y值最小的列
    __block NSString *minYForColumn = @"0";
    __weak typeof (self) wSelf = self;
    [self.cellInfo enumerateKeysAndObjectsUsingBlock:^(NSString *columnIndex, NSNumber *minY, BOOL *stop) {
        if ([minY floatValue] < [wSelf.cellInfo[minYForColumn] floatValue]) {
            minYForColumn = columnIndex;
        }
    }];
    CGFloat width = (self.collectionView.frame.size.width - self.insets.left - self.insets.right - self.columnMargin * (self.count - 1)) / self.count;

    CGFloat height = [self.layoutDelegate collectionView:(RCCollectionView*)self.collectionView waterFlowLayout:self heightForWidth:width atIndexPath:indexPath];
    CGFloat x = self.insets.left + (width + self.columnMargin) * [minYForColumn integerValue];
    CGFloat y = self.rowMargin + [self.cellInfo[minYForColumn] floatValue];
    
    self.cellInfo[minYForColumn] = @(y + height);
    
    // 创建属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y-20, width, height);
    return attrs;
}

#pragma mark - CollectionView的滚动范围
- (CGSize)collectionViewContentSize {
    CGFloat width = self.collectionView.frame.size.width;
    
    __block CGFloat maxY = 0;
    [self.cellInfo enumerateKeysAndObjectsUsingBlock:^(NSString *columnIndex, NSNumber *itemMaxY, BOOL *stop)
    {
        if ([itemMaxY floatValue] > maxY)
        {
            maxY = [itemMaxY floatValue];
        }
    }];
    
    return CGSizeMake(width, maxY + self.insets.bottom);
}
- (CGFloat)getWidthByDevice
{
    if ([self currentDeviceSize] == IPhone5)
    {
        return 142;
        
    }else if ([self currentDeviceSize]   == IPhone6)
    {
        return 165;

    }else
    {
        return 177;
    }

}
#pragma mark - 获取机型用于适配
- (CurrentDevice)currentDeviceSize
{
    if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 4"] ||
        [[self getCurrentDeviceModel] isEqualToString:@"iPhone 5"])
    {
        return IPhone5;
        
    }else if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 6"] ||
              [[self getCurrentDeviceModel] isEqualToString:@"iPhone Simulator"])
    {
        return IPhone6;
    }else
    {
        return Iphone6Plus;
    }
}
//获得设备型号
- (NSString *)getCurrentDeviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}
@end
