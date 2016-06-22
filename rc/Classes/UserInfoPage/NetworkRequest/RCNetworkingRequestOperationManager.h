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
/**
 *  类方法生成并启动网络请求
 *
 *  @param requestUrl    URL字符串
 *  @param type          网络请求类型：GET or POST
 *  @param dict          参数字典
 *  @param completeBlock 网络请求成功回调
 *  @param errorBlock    网络请求错误回调
 *
 *  @return 生成的网络请求管理对象
 */
+ (id)request:(NSString *)requestUrl requestType:(NetWorkingRequestType)type parameters:(NSDictionary *)dict completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;
/**
 *  实例方法，启动网络请求，不需要用户手动调用，程序将会自动调用
 *
 *  @param task 需要启动的会话
 */
- (void)resume:(NSURLSessionDataTask *)task;
/**
 *  类方法生成并启动网络请求
 *
 *  @param requestUrl    URL字符串
 *  @param type          网络请求类型：GET or POST
 *  @param dict          参数字典
 *  @param completeBlock 网络请求成功回调
 *  @param errorBlock    网络请求错误回调
 *
 *  @return 生成的网络请求管理对象
 */
- (id)initWithRequest:(NSString *)requestUrl requestType:(NetWorkingRequestType)type parameters:(NSDictionary *)dict completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;
+(id)uploadTask:(NSString *)requestUrl requestType:(NetWorkingRequestType)type parameters:(NSDictionary *)dict completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;
- (id)initWithUploadTask:(NSString *)requestUrl requestType:(NetWorkingRequestType)type parameters:(NSDictionary *)dict completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock;
@end
