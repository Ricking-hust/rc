//
//  DataParse.h
//  日常
//
//  Created by 余笃 on 15/12/21.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//
#import "NSNumber+Message.h"
#import "UserModel.h"

typedef NS_ENUM(NSInteger,ErrorType) {
    ErrorTypeLoginFailure           = 701,
};

@interface DataManager : NSObject

+(instancetype)manager;

@property(nonatomic,strong) UserModel *user;
@property (nonatomic, assign) BOOL preferHttps;

#pragma mark

-(NSURLSessionDataTask *)getCityListSuccess:(void (^)(NSDictionary *cityList))success
                                    failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *)setCityWithUserId:(NSString *)userid
                                    cityId:(NSString *)cityid
                                   success:(void (^)(NSString *message))success
                                   failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *)getAllTagsSuccess:(void (^)(NSDictionary *Tags))success
                                   failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) setTagsWithUserId:(NSString *)userid
                                    success:(void (^)(NSString *))success
                                    failure:(void (^)(NSError *))failure;

-(NSURLSessionDataTask *) getPopularSearchSuccess:(void (^)(NSDictionary *PopularTags))success
                                          failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) getActivitySearchWithKeywords:(NSString *)keywords
                                                startId:(NSString *)startid
                                                success:(void (^)(NSDictionary *activityList))success
                                                failure:(void (^)(NSError *error))failure;

#pragma mark - Public Request Methods - Login & Profile

-(NSURLSessionDataTask *)UserLoginWithUsername:(NSString *)username
                                      password:(NSString *)password
                                        optype:(NSString *)optype
                                       success:(void (^)(NSString *message))success
                                       failure:(void (^)(NSError *error))failure;

@end