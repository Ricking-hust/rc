//
//  RCSearchModel.m
//  rc
//
//  Created by 余笃 on 16/4/19.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCSearchModel.h"
#import "TMCacheExtend.h"
#define kSearchHistory @"com.rc.search.history"

@implementation RCSearchModel

+ (NSArray *)getSearchHistory {
    
    if(![[TMCache TemporaryCache] objectForKey:kSearchHistory]) {
        
        NSMutableArray *history = [[NSMutableArray alloc] initWithCapacity:3];
        [[TMCache TemporaryCache] setObject:history forKey:kSearchHistory];
    }
    
    return [[TMCache TemporaryCache] objectForKey:kSearchHistory];
}

+ (void)addSearchHistory:(NSString *)searchString {
    
    NSMutableArray *history = [NSMutableArray arrayWithArray:[RCSearchModel getSearchHistory]];
    if(![history containsObject:searchString]) {
        if(history.count >= 8)
            [history removeLastObject];
        [history insertObject:searchString atIndex:0];
        [[TMCache TemporaryCache] setObject:history forKey:kSearchHistory];
    }
}

+(void)deleteSearchHistoryWithI:(int)i{
    NSMutableArray *history = [NSMutableArray arrayWithArray:[RCSearchModel getSearchHistory]];
    [history removeObjectAtIndex:i];
    [[TMCache TemporaryCache] setObject:history forKey:kSearchHistory];
}

+ (void)cleanAllSearchHistory {
    
    NSMutableArray *history = [NSMutableArray arrayWithArray:[RCSearchModel getSearchHistory]];
    [history removeAllObjects];
    [[TMCache TemporaryCache] setObject:history forKey:kSearchHistory];
}

@end
