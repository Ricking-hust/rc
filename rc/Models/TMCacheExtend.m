//
//  TMCacheExtend.m
//  IBY
//
//  Created by panshiyu on 15/5/8.
//  Copyright (c) 2015年 com.biyao. All rights reserved.
//

#import "TMCacheExtend.h"

#define kTemporaryCache @"com.rc.cache.temporary"

@implementation TMCache (Extension)

+ (instancetype)TemporaryCache{
    return [[TMCache sharedCache] initWithName:kTemporaryCache];
}
@end
