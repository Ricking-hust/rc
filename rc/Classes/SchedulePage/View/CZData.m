//
//  CZData.m
//  rc
//
//  Created by AlanZhang on 16/2/2.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZData.h"

@implementation CZData
//
//@property (nonatomic, strong) NSString *imgStr;
//@property (nonatomic, strong) NSString *timeStr;
//@property (nonatomic, strong) NSString *tagStr;
//@property (nonatomic, strong) NSString *contentStr;
//@property (nonatomic, strong) NSString *bgimgStr;
+ (instancetype)data
{
    CZData *data = [[CZData alloc]init];
    data.imgStr = @"currentPoint";
    data.timeStr = @"08:20";
    data.tagStr = @"sportIcon";
    data.contentStr = @"老夫聊发少年狂,治肾亏,不含糖.";
    data.bgimgStr = @"bg_background1";
    return data;
}
@end
