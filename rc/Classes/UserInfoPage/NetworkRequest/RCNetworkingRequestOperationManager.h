//
//  RCNetworkingRequestOperationManager.h
//  rc
//
//  Created by AlanZhang on 16/5/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completeBlock_t)(NSData *data);
typedef void(^errorBlock_t) (NSError *error);
@interface RCNetworkingRequestOperationManager : NSObject<NSURLSessionDataDelegate,NSURLSessionTaskDelegate>
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, copy) completeBlock_t completeBlock;
@property (nonatomic, copy) errorBlock_t  errorBlock;
+ (id)request:(NSString *)requestUrl requestType:(NetWorkingRequestType)type parameters:(NSDictionary *)dict completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;
- (id)initWithRequest:(NSString *)requestUrl requestType:(NetWorkingRequestType)type parameters:(NSDictionary *)dict completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;
+(id)uploadTask:(NSString *)requestUrl requestType:(NetWorkingRequestType)type parameters:(NSDictionary *)dict completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;
- (id)initWithUploadTask:(NSString *)requestUrl requestType:(NetWorkingRequestType)type parameters:(NSDictionary *)dict completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;
@end
