//
//  RCCollectionView.m
//  rc
//
//  Created by AlanZhang on 16/3/31.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCCollectionView.h"

@implementation RCCollectionView

- (id)init
{
    if (self = [super init])
    {
        self.indModel = [[IndustryModel alloc]init];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    if (self = [super initWithFrame:frame collectionViewLayout:layout])
    {
        self.indModel = [[IndustryModel alloc]init];

    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
