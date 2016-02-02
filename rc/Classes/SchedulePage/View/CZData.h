//
//  CZData.h
//  rc
//
//  Created by AlanZhang on 16/2/2.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CZData : NSObject

@property (nonatomic, strong) NSString *imgStr;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) NSString *tagStr;
@property (nonatomic, strong) NSString *contentStr;
@property (nonatomic, strong) NSString *bgimgStr;

+ (instancetype)data;
@end
