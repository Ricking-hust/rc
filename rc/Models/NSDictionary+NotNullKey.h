//
//  NSDictionary+NotNullKey.h
//  rc
//
//  Created by 余笃 on 16/3/7.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define NILORSLASH(obj) (obj != nil) ? obj : @"/"
#define NILORDASH(obj)  (obj != nil) ? obj : @"-"

@interface NSDictionary (NotNullKey)
+(NSDictionary *) dictionaryWithPropertiesOfObject:(id) obj;
- (id)objectForSafeKey:(id)key;

@end
