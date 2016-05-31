//
//  RCNetworkingRequestOperationManager.m
//  rc
//
//  Created by AlanZhang on 16/5/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCNetworkingRequestOperationManager.h"

@implementation RCNetworkingRequestOperationManager
+ (id)request:(NSString *)requestUrl requestType:(NetWorkingRequestType)type parameters:(NSDictionary *)dict completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock
{
    
    return [[self alloc]initWithRequest:requestUrl requestType:type parameters:dict completeBlock:completeBlock errorBlock:errorBlock];
}
- (id)initWithRequest:(NSString *)requestUrl requestType:(NetWorkingRequestType)type parameters:(NSDictionary *)dict completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock
{
    
    if (self = [super init])
    {
        self.data = [[NSMutableData alloc]init];
        self.completeBlock = [completeBlock copy];
        self.errorBlock = [errorBlock copy];
    }
    NSMutableURLRequest *request = [self requestBySerializingRequest:requestUrl requestType:type Parameters:dict];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request];
    [dataTask resume];
    return self;
    
}
+(id)uploadTask:(NSString *)requestUrl requestType:(NetWorkingRequestType)type parameters:(NSDictionary *)dict completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock
{
    return [[self alloc]initWithUploadTask:requestUrl requestType:type parameters:dict completeBlock:completeBlock errorBlock:errorBlock];
}

- (id)initWithUploadTask:(NSString *)requestUrl requestType:(NetWorkingRequestType)type parameters:(NSDictionary *)dict completeBlock:(completeBlock_t)completeBlock errorBlock:(errorBlock_t)errorBlock
{
    if (self = [super init])
    {
        self.data = [[NSMutableData alloc]init];
        self.completeBlock = [completeBlock copy];
        self.errorBlock = [errorBlock copy];
    }
    NSMutableURLRequest *request = [self requestBySerializingRequest:requestUrl requestType:type Parameters:dict];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:nil completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"suessce");
    }];
    [uploadTask resume];
    return self;
    
}
- (NSMutableURLRequest *)requestBySerializingRequest:(NSString *)requestUrl requestType:(NetWorkingRequestType)type Parameters:(NSDictionary *)parameters
{
    NSString __block *para = @"";
    //提取参数
    if ([parameters count] == 0)
    {
        para = @"";
    }else
    {
        [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *temp = [NSString stringWithFormat:@"%@=%@&",key, obj];
            para = [NSString stringWithFormat:@"%@%@",para,temp];
        }];
        para = [para substringWithRange:NSMakeRange(0, [para length] - 1)];
        
    }
    //设置请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    if (type == GET)
    {
        requestUrl = [NSString stringWithFormat:@"%@?%@",requestUrl,para];
        request.HTTPMethod = @"GET";
    }else
    {
        request.HTTPMethod = @"POST";
        request.HTTPBody = [para dataUsingEncoding:NSUTF8StringEncoding];
    }
    request.URL = [NSURL URLWithString:requestUrl];
    request.timeoutInterval = 15;
    request.cachePolicy = 1;
    
    return request;
}
#pragma mark - NSURLSessionDataDelegate
//接收到服务器返回数据的时候会调用该方法，如果数据较大那么该方法可能会调用多次
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}
//当请求完成(成功|失败)的时候会调用该方法，如果请求失败，则error有值
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (!error)
    {
        //        //解析数据
        //        id dict = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:nil];
        //        NSLog(@"%@",dict);
        self.completeBlock(self.data);
    }else
    {
        self.errorBlock(error);
    }
}
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    NSLog(@"upload delegate");
}

@end
