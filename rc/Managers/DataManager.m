//
//  DataManager.m
//  日常
//
//  Created by 余笃 on 15/12/21.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//


#import "DataManager.h"

typedef NS_ENUM(NSInteger,RcRequestMethod){
    RcRequestMethodJSONGET    = 1,
    RcRequestMethodHTTPPOST   = 2,
    RcRequestMethodHTTPGET    = 3
};

@interface DataManager ()

@end

@implementation DataManager

-(instancetype)init{
    if (self = [super init]) {
        BOOL isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userIsLogin"] boolValue];
        if (isLogin) {
            UserModel *user = [[UserModel alloc] init];
            user.login = YES;
            _user = user;
        }
    }
    return self;
}


- (void) setUser:(UserModel *)user{
    _user = user;
    
    if (user) {
        self.user.login = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:user.userName forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] setObject:user.userId forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] setObject:user.userPhone forKey:@"userPhone"];
        [[NSUserDefaults standardUserDefaults] setObject:user.userSign forKey:@"userSign"];
        [[NSUserDefaults standardUserDefaults] setObject:user.userPic forKey:@"userPic"];
        [[NSUserDefaults standardUserDefaults] setObject:user.userSex forKey:@"userSex"];
        [[NSUserDefaults standardUserDefaults] setObject:user.userMail forKey:@"userMail"];
        [[NSUserDefaults standardUserDefaults] setObject:user.cityId forKey:@"cityId"];
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"userIsLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPhone"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userSign"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPic"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userSex"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userMail"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userIsLogin"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"cityId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+(instancetype)manager{
    static DataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        manager = [[DataManager alloc] init];
    });
    return manager;
}

-(NSURLSessionDataTask*) requestWithMethod:(RcRequestMethod)method
                                 URLString:(NSString *)URLString
                                parameters:(NSDictionary *)parameters
                                   success:(void (^)(NSURLSessionDataTask *task,id responseObject))success
                                   failure:(void (^) (NSError *error))failure{
    //stateBar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //Handle Common Mission, Cache, Data Reading & etc.
    void (^responseHandleBlock)(NSURLSessionDataTask *task,id responseObject) = ^(NSURLSessionDataTask *task,id responseObject){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"URL:\n%@", [task.currentRequest URL].absoluteString);
        success(task,responseObject);
    };
    
    // Create HTTPSession
    NSURLSessionDataTask *task = nil;
    
    if (method == RcRequestMethodJSONGET) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSURL *URL = [NSURL URLWithString:URLString];
        AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer = responseSerializer;
        manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObject:@"text/html"];
        task = [manager GET:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            responseHandleBlock(task,responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"Error:\n%@",[error description]);
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error);
        }];
    }
    
    if (method == RcRequestMethodHTTPGET) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSURL *URL = [NSURL URLWithString:URLString];
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer = responseSerializer;
        manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObject:@"text/html"];
        task = [manager GET:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            responseHandleBlock(task,responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            failure(error);
        }];
    }
    
    if (method == RcRequestMethodHTTPPOST) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSURL *URL = [NSURL URLWithString:URLString];
        AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer = responseSerializer;
        manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObject:@"text/html"];
        task = [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            responseHandleBlock(task,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            NSLog(@"Error:%@",error);
        }];
        
    }
    
    return task;
}


#pragma mark - Public Request Methods - HomePage
-(NSURLSessionDataTask *) getCityListSuccess:(void (^)(CityList *ctList))success
                                     failure:(void (^)(NSError *error))failure{
    
    return [self requestWithMethod:RcRequestMethodJSONGET URLString:@"http://app.myrichang.com/Home/PersonalInfo/getCityList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        CityList *ctList = [[CityList alloc] initWithArray:[responseObject objectForKey:@"data"]];
        success(ctList);
    } failure:^(NSError *error) {
        failure(error);
    }];
};

-(NSURLSessionDataTask *) setCityWithUserId:(NSString *)userId
                                     cityId:(NSString *)cityId
                                    success:(void (^)(NSString *))success
                                    failure:(void (^)(NSError *))failure{
    NSString *urlString = [NSString stringWithFormat:@"http://app.myrichang.com/Home/PersonalInfo/SetCity"];
    NSDictionary *parameters = @{
                                 @"usr_id":userId,
                                 @"ct_id":cityId,
                                 };
    return [self requestWithMethod:RcRequestMethodHTTPPOST URLString:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *msg = [[NSString alloc] initWithString:[responseObject objectForKey:@"msg"]];
        success(msg);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(NSURLSessionDataTask *) getFlashWithSuccess:(void (^)(FlashList *flashList))success
                                      failure:(void (^)(NSError *))failure{
    return [self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/Activity/getFlash" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        FlashList *flashList = [[FlashList alloc] initWithArray:[responseObject objectForKey:@"data"]];
        success(flashList);
    } failure:^(NSError *error) {
        NSLog(@"Error:%@",error);
    }];
}

-(NSURLSessionDataTask *) getAllTagsSuccess:(void (^)(TagsList *tagList))success
                                    failure:(void (^)(NSError *error))failure{
    
    return [self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/PersonalInfo/getAllTags" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        TagsList *tagsList = [[TagsList alloc] initWithArray:[responseObject objectForKey:@"data"]];
        success(tagsList);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(NSURLSessionDataTask *) setTagsWithUserId:(NSString *)userId
                                   tagsList:(NSString *)tagIds
                                    success:(void (^)(NSString *msg))success
                                    failure:(void (^)(NSError *error))failure{
    NSString *urlString = [NSString stringWithFormat:@"http://app.myrichang.com/Home/PersonalInfo/setTags"];
    NSDictionary *parameters = @{
                                 @"usr_id":userId,
                                 @"tags[]":tagIds,
                                 };
    return [self requestWithMethod:RcRequestMethodHTTPPOST URLString:urlString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *msg = [[NSString alloc] initWithString:[responseObject objectForKey:@"msg"]];
        success(msg);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(NSURLSessionDataTask *) getUsrTagsWithUserId:(NSString *)userId
                                       success:(void (^)(TagsList *tagsList))success
                                       failure:(void (^)(NSError *error))failure{
    NSDictionary *parameters = @{
                                 @"usr_id":userId,
                                 };
    return [self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/PersonalInfo/getUsrTags" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *code = [[NSString alloc] initWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            TagsList *tagsList = [[TagsList alloc] initWithArray:[responseObject objectForKey:@"data"]];
            success(tagsList);
        } else if ([code isEqualToString:@"210"]){
            TagsList *tagsList =[[TagsList alloc]init];
            success(tagsList);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(NSURLSessionDataTask *) getPopularSearchSuccess:(void (^)(NSMutableArray *popSearchList))success
                                          failure:(void (^)(NSError *error))failure{
    return [self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/Activity/getPopularSearch" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSMutableArray *popSearchList = [[NSMutableArray alloc] init];
        for (NSDictionary *popDic in [responseObject objectForKey:@"data"]) {
            NSString *popSearch = [popDic objectForKey:@"keywords"];
            [popSearchList addObject:popSearch];
        }
        success(popSearchList);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(NSURLSessionDataTask *) getActivitySearchWithKeywords:(NSString *)keywords
                                                startId:(NSString *)startId
                                                    num:(NSString *)num
                                                 cityId:(NSString *)cityId
                                                success:(void (^)(ActivityList *acList))success
                                                failure:(void (^)(NSError *error))failure{
    NSDictionary *parameters = @{
                                 @"keywords":keywords,
                                 @"start_id":startId,
                                 @"num":num,
                                 @"ct_id":cityId,
                                 };
    return [self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/Activity/getActivitySearch" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        ActivityList *acList = [[ActivityList alloc] initWithArray:[responseObject objectForKey:@"data"]];
        success(acList);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(NSURLSessionDataTask *) getActivityRecommendWithCityId:(NSString *)cityId
                                                 startId:(NSString *)startId
                                                     num:(NSString *)num
                                                  userId:(NSString *)userId
                                                 success:(void (^)(ActivityList *acList))success
                                                 failure:(void (^)(NSError *))failure{
    NSDictionary *parameters = @{
                                 @"ct_id":cityId,
                                 @"start_id":startId,
                                 @"num":num,
                                 @"usr_id":userId,
                                 };
    return [self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/Activity/getActivityRecommend" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *returnMessage = [[NSDictionary alloc]initWithDictionary:responseObject];
        NSNumber *code = [returnMessage objectForKey:@"code"];
        NSNumber *successcode = [NSNumber numberWithLong:200];
        if ([code isEqualToNumber:successcode]) {
            ActivityList *acList = [[ActivityList alloc] initWithArray:[responseObject objectForKey:@"data"]];
            success(acList);
        } else {
            ActivityList *acList = nil;
            success(acList);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(NSURLSessionDataTask *) getActivityContentWithAcId:(NSString *)acId
                                              userId:(NSString *)userId
                                             success:(void (^)(ActivityModel *activity))success
                                             failure:(void (^)(NSError *error))failure{
    NSDictionary *parameters = @{
                                 @"ac_id":acId,
                                 @"usr_id":userId,
                                 };
    return [self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/Activity/getActivityContent" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        ActivityModel *activity = [[ActivityModel alloc] initWithDictionary:[responseObject objectForKey:@"data"]];
        success(activity);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(NSURLSessionDataTask *) setActivityCollectWithUserID:(NSString *)userId
                                                  acId:(NSString *)acId
                                                opType:(NSString *)opType
                                               success:(void (^)(NSString *msg))success
                                               failure:(void (^)(NSError *error))failure{
    NSDictionary *parameters = @{
                                 @"usr_id":userId,
                                 @"ac_id":acId,
                                 @"op_type":opType,
                                 };
    return [self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/Activity/setActivityCollect" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *msg = [[NSString alloc] initWithString:[responseObject objectForKey:@"msg"]];
        success(msg);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(NSURLSessionDataTask *) joinTripWithUserId:(NSString *)userId
                                        acId:(NSString *)acId
                                      opType:(NSString *)opType
                                     success:(void (^)(NSString *planId))success
                                     failure:(void (^)(NSError *error))failure{
    NSDictionary *parameters = @{
                                 @"usr_id":userId,
                                 @"ac_id":acId,
                                 @"op_type":opType
                                 };
    return [ self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/Activity/joinTrip" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *code = [[NSString alloc] initWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        if ([code isEqualToString:@"200"]) {
            NSString *planId = [[NSString alloc] initWithString:[responseObject objectForKey:@"pl_id"]];
            success(planId);
        } else if ([code isEqualToString:@"210"]){
            NSString *planId = @"joined";
            success(planId);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(NSURLSessionDataTask *) getMoreActivityWithAcId:(NSString *)acId
                                          success:(void (^)(ActivityList *acList))success
                                          failure:(void (^)(NSError *error))failure{
    NSDictionary *parameters = @{
                                 @"ac_id":acId,
                                 };
    return [self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/Activity/getMoreActivity" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        ActivityList *acList = [[ActivityList alloc] initWithArray:[responseObject objectForKey:@"data"]];
        success(acList);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Public Request Methods - Industry
-(NSURLSessionDataTask *) getAllIndustriesWithSuccess:(void (^)(IndustryList *indList))success
                                              failure:(void (^)(NSError *error))failure{
    return [self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/Industry/getAllIndustries" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        IndustryList *indList = [[IndustryList alloc] initWithArray:[responseObject objectForKey:@"data"]];
        success(indList);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(NSURLSessionDataTask *) checkIndustryWithCityId:(NSString *)cityId
                                       industryId:(NSString *)industryId
                                          startId:(NSString *)startId
                                          success:(void (^)(ActivityList *acList))success
                                          failure:(void (^)(NSError *error))failure{
    NSDictionary *parameters = @{
                                 @"ct_id":cityId,
                                 @"ind_id":industryId,
                                 @"start_id":startId,
                                 };
    return [self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/Industry/checkIndustry" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        ActivityList *acList = [[ActivityList alloc] initWithArray:[responseObject objectForKey:@"data"]];
        success(acList);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Public Request Methods - plan

-(NSURLSessionDataTask *) getPlanWithUserId:(NSString *)userId
                                  beginDate:(NSString *)beginDate
                                    endDate:(NSString *)endDate
                                    success:(void (^)(PlanList *plList))success
                                    failure:(void (^)(NSError *error))failure{
    NSDictionary *parameters = @{
                                 @"usr_id":userId,
                                 @"begin_date":beginDate,
                                 @"end_date":endDate,
                                 };
    return [self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/Plan/getPlan" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *returnMessage = [[NSDictionary alloc]initWithDictionary:responseObject];
        NSNumber *code = [returnMessage objectForKey:@"code"];
        NSNumber *successcode = [NSNumber numberWithLong:200];
        if ([code isEqualToNumber:successcode]) {
            PlanList *plList = [[PlanList alloc] initWithArray:[responseObject objectForKey:@"data"]];
            success(plList);
        } else {
            PlanList *plList = nil;
            success(plList);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

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
                                    failure:(void (^)(NSError *error))failure{
    NSDictionary *parameters = @{
                                 @"op_type":opType,
                                 @"pl_id":planId,
                                 @"usr_id":userId,
                                 @"theme_id":themeId,
                                 @"pl_time":planTime,
                                 @"pl_alarm_one":plAlarmOne,
                                 @"pl_alarm_two":plAlarmTwo,
                                 @"pl_alarm_three":plAlarmThree,
                                 @"pl_content":planContent,
                                 @"ac_place":acPlace,
                                 };
    return [self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/Plan/addPlan" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *msg = [[NSString alloc] initWithString:[responseObject objectForKey:@"msg"]];
        success(msg);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(NSURLSessionDataTask *) delPlanWithUserId:(NSString *)userId
                                     planId:(NSString *)planId
                                    success:(void (^)(NSString *msg))success
                                    failure:(void (^)(NSError *error))failure{
    NSDictionary *parameters = @{
                                 @"usr_id":userId,
                                 @"pl_id":planId,
                                 };
    return [self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/Plan/delPlan" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *msg = [[NSString alloc] initWithString:[responseObject objectForKey:@"msg"]];
        success(msg);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


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
                                          failure:(void (^)(NSError *error))failure{
    NSDictionary *parameters = @{
                                 @"usr_id":userId,
                                 @"op_type":opType,
                                 @"usr_passwd_old":userPwdO,
                                 @"usr_passwd_new":userPwdN,
                                 @"usr_name":userName,
                                 @"usr_sign":userSign,
                                 @"usr_pic":userPic,
                                 @"usr_sex":userSex,
                                 @"usr_mail":userMail,
                                 @"ct_id":cityID,
                                 };
    return [self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/Person/modifyAccount" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *msg = [[NSString alloc] initWithString:[responseObject objectForKey:@"msg"]];
        success(msg);
    } failure:^(NSError *error) {
        failure(error);
    }];
}


-(NSURLSessionDataTask *) getUserActivityWithUserId:(NSString *)userId
                                             opType:(NSString *)opType
                                            success:(void (^)(ActivityList *acList))success
                                            failure:(void (^)(NSError *error))failure{
    NSDictionary *parameters = @{
                                 @"usr_id":userId,
                                 @"op_type":opType,
                                 };
    return [self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/Person/getUserActivity" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"responseObject:%@",responseObject);
        ActivityList *acList = [[ActivityList alloc] initWithArray:[responseObject objectForKey:@"data"]];
        success(acList);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(NSURLSessionDataTask *) getUserPlanWithUserId:(NSString *)userId
                                        success:(void (^)(PlanList *plList))success
                                        failure:(void (^)(NSError *error))failure{
    NSDictionary *parameters = @{
                                 @"usr_id":userId,
                                 };
    return [self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/Person/getUserPlan" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        PlanList *plList = [[PlanList alloc] initWithArray:[responseObject objectForKey:@"data"]];
        success(plList);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(NSURLSessionDataTask *)putFeedBackWithUserId:(NSString *)userId
                                        fbMail:(NSString *)fbMail
                                       fbPhone:(NSString *)fbPhone
                                     fbContent:(NSString *)fbContent
                                       success:(void (^)(NSString *))success
                                       failure:(void (^)(NSError *))failure{
    NSDictionary *parameters = @{
                                 @"usr_id":userId,
                                 @"fb_mail":fbMail,
                                 @"fb_phone":fbPhone,
                                 @"fb_content":fbContent
                                 };
    return [self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/Person/putFeedback" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *msg = [[NSString alloc] initWithString:[responseObject objectForKey:@"msg"]];
        success(msg);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(NSURLSessionDataTask *)getVersionWithSuccess:(void (^)(NSString *msg))success failure:(void (^)(NSError *))failure{
    return [self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/Person/getVersion" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *msg = [[NSString alloc] initWithString:[responseObject objectForKey:@"data"]];
        success(msg);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(void)uploadImgWithImage:(UIImage *)image
               fileName:(NSString *)fileName
                success:(void (^)(id))success
                   fail:(void (^)(NSError *))failure{
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://myrichang.com/Publish/Public/Uploads/android/upload_android.php" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"uploadfile" fileName:fileName mimeType:@"multipart/form-data"];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.responseSerializer = responseSerializer;
    NSURLSessionDataTask *uploadTask;
    uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error:%@",error);
            failure(error);
        } else {
            success(responseObject);
        }
    }];
    
    [uploadTask resume];
}

#pragma mark - Login & Profile

-(NSURLSessionDataTask *)UserLoginOrRegisteWithUserphone:(NSString *)userphone
                                                password:(NSString *)password
                                                 op_type:(NSString *)op_type
                                                 success:(void (^)(UserModel *user))success
                                                 failure:(void (^)(NSError *error))failure{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
    NSDictionary *parameters = @{
                                 @"op_type":op_type,
                                 @"usr_phone":userphone,
                                 @"act_passwd":password,
                                 };
    [self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/Person/login" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *loginMessage = [[NSDictionary alloc]initWithDictionary:responseObject];
        NSNumber *code = [loginMessage objectForKey:@"code"];
        NSNumber *successcode = [NSNumber numberWithLong:200];
        if ([code isEqualToNumber:successcode]) {
            UserModel *user = [[UserModel alloc] initWithDictionary:[responseObject objectForKey:@"data"]];
            success(user);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:@"com.app.richang.com" code:RcErrorTypeLoginFailure userInfo:nil];
            failure(error);
            NSLog(@"Error:%@",error);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    
    return nil;
}

- (void)UserLogout {
    
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    
    self.user = nil;
}

-(NSURLSessionDataTask *)resetPwdWithMobile:(NSString *)mobile
                                     passwd:(NSString *)passwd
                                    success:(void (^)(NSString *code))success
                                    failure:(void (^)(NSError *error))failure{
    NSDictionary *parameters = @{
                                 @"mobile":mobile,
                                 @"passwd":passwd
                                 };
    return [[DataManager manager] requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/Person/reset" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *code = [[NSString alloc] initWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        success(code);
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}

-(NSURLSessionDataTask *) sendMobileMsgWithMobile:(NSString *)mobile
                                             type:(NSString *)type
                                              msg:(NSString *)msg
                                            token:(NSString *)token
                                          success:(void (^)(NSString *code))success
                                          failure:(void (^)(NSError *error))failure{
    NSDictionary *parameters = @{
                                 @"mobile":mobile,
                                 @"type":type,
                                 @"msg":msg,
                                 @"token":token
                                 };
    [self requestWithMethod:RcRequestMethodHTTPPOST URLString:@"http://app.myrichang.com/Home/Person/sendMobileMsg" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *code = [[NSString alloc] initWithFormat:@"%@",[responseObject objectForKey:@"code"]];
        success(code);
    } failure:^(NSError *error) {
        NSLog(@"Error:%@",error);
    }];
    return nil;
}

@end