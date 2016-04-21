//
//  RCSearchModel.h
//  rc
//
//  Created by 余笃 on 16/4/19.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCSearchModel : NSObject

+ (NSArray *)getSearchHistory;
+ (void)addSearchHistory:(NSString *)searchString;
+(void)deleteSearchHistoryWithI:(int)i;
+ (void)cleanAllSearchHistory;

@end
