//
//  RCNetworking.h
//  rc
//
//  Created by AlanZhang on 16/5/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completeBlock_t)(NSData *data);
typedef void(^errorBlock_t) (NSError *error);
@interface RCNetworking : NSObject<NSURLSessionDataDelegate>
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, copy) completeBlock_t completeBlock;
@property (nonatomic, copy) errorBlock_t  errorBlock;
@end
