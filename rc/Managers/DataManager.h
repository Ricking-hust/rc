//
//  DataManager.h
//  日常
//
//  Created by 余笃 on 15/12/21.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "NSNumber+Message.h"
#import "UserModel.h"
#import "CityModel.h"
#import "ActivityModel.h"
#import "IndustryModel.h"
#import "planModel.h"
#import "TagModel.h"

typedef NS_ENUM(NSInteger,RcErrorType) {
    RcErrorTypeLoginFailure           = 701,
    RcErrorTypeRequestFailure         = 702,
};

@interface DataManager : NSObject

+(instancetype)manager;

@property(nonatomic,strong) UserModel *user;

#pragma mark - Public Request Methods - HomePage

-(NSURLSessionDataTask *)getCityListSuccess:(void (^)(CityList *ctList))success
                                    failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) setCityWithUserId:(NSString *)userId
                                     cityId:(NSString *)cityId
                                    success:(void (^)(NSString *))success
                                    failure:(void (^)(NSError *))failure;

-(NSURLSessionDataTask *) getAllTagsSuccess:(void (^)(TagsList *tagList))success
                                    failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) setTagsWithUserId:(NSString *)userId
                                   tagsList:(NSArray *)tagsList
                                    success:(void (^)(NSString *))success
                                    failure:(void (^)(NSError *))failure;

-(NSURLSessionDataTask *) getUsrTagsWithUserId:(NSString *)userId
                                       success:(void (^)(TagsList *tagsList,NSString *msg))success
                                       failure:(void (^)(NSError *))failure;

-(NSURLSessionDataTask *) getPopularSearchSuccess:(void (^)(NSMutableArray *popSearchList))success
                                          failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) getActivitySearchWithKeywords:(NSString *)keywords
                                                startId:(NSString *)startId
                                                    num:(NSString *)num
                                                 cityId:(NSString *)cityId
                                                success:(void (^)(ActivityList *acList))success
                                                failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) getActivityRecommendWithCityId:(NSString *)cityId
                                                 startId:(NSString *)startId
                                                     num:(NSString *)num
                                                  userId:(NSString *)userId
                                                 success:(void (^)(ActivityList *acList))success
                                                 failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) getActivityContentWithAcId:(NSString *)acId
                                              userId:(NSString *)userId
                                             success:(void (^)(ActivityModel *activity))success
                                             failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) setActivityCollectWithUserID:(NSString *)userId
                                                  acId:(NSString *)acId
                                                opType:(NSString *)opType
                                               success:(void (^)(NSString *msg))success
                                               failure:(void (^)(NSError *))failure;

-(NSURLSessionDataTask *) joinTripWithUserId:(NSString *)userId
                                        acId:(NSString *)acId
                                      opType:(NSString *)opType
                                     success:(void (^)(NSString *))success
                                     failure:(void (^)(NSError *))failure;

-(NSURLSessionDataTask *) getMoreActivityWithAcId:(NSString *)acId
                                          success:(void (^)(ActivityList *acList))success
                                          failure:(void (^)(NSError *))failure;

#pragma mark - Public Request Methods - Industry

-(NSURLSessionDataTask *) getAllIndustriesWithSuccess:(void (^)(industryList *indList))success
                                              failure:(void (^)(NSError *))failure;

-(NSURLSessionDataTask *) checkIndustryWithCityId:(NSString *)cityId
                                       industryId:(NSString *)industryId
                                          startId:(NSString *)startId
                                          success:(void (^)(ActivityList *acList))success
                                          failure:(void (^)(NSError *))failure;

#pragma mark - Public Request Methods - plan

-(NSURLSessionDataTask *) getPlanWithUserId:(NSString *)userId
                                  beginDate:(NSString *)beginDate
                                    endDate:(NSString *)endDate
                                    success:(void (^)(planList *plList))success
                                    failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) addPlanWithOpType:(NSString *)opType
                                     planId:(NSString *)planId
                                     userId:(NSString *)userId
                                    themeId:(NSString *)themeId
                                   planTime:(NSString *)planTime
                                 plAlarmOne:(NSString *)plAlarmOne
                                 plAlarmTwo:(NSString *)plAlarmTwo
                               plAlarmThree:(NSString *)plAlarmThree
                                planContent:(NSString *)planContent
                                    acPlace:(NSString *)acPlace
                                    success:(void (^)(NSString *msg))success
                                    failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) delPlanWithUserId:(NSString *)userId
                                     planId:(NSString *)planId
                                    success:(void (^)(NSString *msg))success
                                    failure:(void (^)(NSError *error))failure;


#pragma mark - Public Request Methods - Account

-(NSURLSessionDataTask *) modifyAccountWithUserId:(NSString *)userId
                                           opType:(NSString *)opType
                                         userPwdO:(NSString *)userPwdO
                                         userPwdN:(NSString *)userPwdN
                                         username:(NSString *)userName
                                         userSign:(NSString *)userSign
                                          userPic:(NSString *)userPic
                                          userSex:(NSString *)userSex
                                         userMail:(NSString *)userMail
                                           cityId:(NSString *)cityID
                                          success:(void (^)(NSString *msg))success
                                          failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) submitImgWithPhoto:(NSArray *)photo
                                      userId:(NSString *)userId
                                     success:(void (^)(NSDictionary *data))success
                                     failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) getUserActivityWithUserId:(NSString *)userId
                                             opType:(NSString *)opType
                                            success:(void (^)(ActivityList *acList))success
                                            failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) getUserPlanWithUserId:(NSString *)userId
                                        success:(void (^)(planList *plList))success
                                        failure:(void (^)(NSError *error))failure;

#pragma mark - Login & Profile

-(NSURLSessionDataTask *)UserLoginOrRegisteWithUserphone:(NSString *)userphone
                                                password:(NSString *)password
                                                 op_type:(NSString *)op_type
                                                 success:(void (^)(UserModel *user))success
                                                 failure:(void (^)(NSError *error))failure;
- (void)UserLogout;

@end