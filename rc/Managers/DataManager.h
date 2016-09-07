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
#import "FlashActivityModel.h"
#import "IndustryModel.h"
#import "planModel.h"
#import "TagModel.h"
#import "CommentModel.h"

typedef NS_ENUM(NSInteger,RcErrorType) {
    RcErrorTypeLoginFailure           = 701,
    RcErrorTypeRequestFailure         = 702,
};

@interface DataManager : NSObject

+(instancetype)manager;

@property(nonatomic,strong) UserModel *user;

#pragma mark - Public Request Methods - HomePage

/**
 *  获取城市列表
 *  @param status       用户的 timeline 信息
 *  @return 标签个数
 */
-(NSURLSessionDataTask *)getCityListSuccess:(void (^)(CityList *ctList))success
                                    failure:(void (^)(NSError *error))failure;


-(NSURLSessionDataTask *) setCityWithUserId:(NSString *)userId
                                     cityId:(NSString *)cityId
                                    success:(void (^)(NSString *))success
                                    failure:(void (^)(NSError *))failure;

/**
 *  获取首页幻灯片
 *
 *  @param success Json转化为FlashList
 *  @param failure 返回NSError
 *
 *  @return 网络请求任务
 */
-(NSURLSessionDataTask *) getFlashWithSuccess:(void (^)(FlashList *flashList))success
                                      failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) getAllTagsSuccess:(void (^)(TagsList *tagList))success
                                    failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) setTagsWithUserId:(NSString *)userId
                                   tagsList:(NSString *)tagIds
                                    success:(void (^)(NSString *msg))success
                                    failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) getUsrTagsWithUserId:(NSString *)userId
                                       success:(void (^)(TagsList *tagsList))success
                                       failure:(void (^)(NSError *error))failure;

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
                                               failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) setPubFollwedWithUserID:(NSString *)userId
                                      publisherId:(NSString *)publisherId
                                           opType:(NSString *)opType
                                          success:(void (^)(NSString *msg))success
                                          failure:(void (^)(NSError *error))failure;

/**
 *  获取活动所有评论
 *
 *  @param acId    活动编号
 *  @param startId 起始评论id（ 0 表示第一次获取）
 *  @param success 评论List处理
 *  @param failure 返回NSError
 *
 *  @return 网络请求任务
 */
-(NSURLSessionDataTask *) getAllCommentsWithacID:(NSString *)acId
                                          userId:(NSString *)userId
                                         startID:(NSString *)startId
                                         success:(void (^)(CommentList *comList))success
                                         failure:(void (^)(NSError *))failure;

/**
 *  获取热门评论
 *
 *  @param acId    活动编号
 *  @param usrId   用户编号
 *  @param success 评论model处理
 *  @param failure 返回NSError
 *
 *  @return 网络请求任务
 */
-(NSURLSessionDataTask *) getPopularCommentsWithAcID:(NSString *)acId
                                               usrID:(NSString *)usrId
                                             success:(void (^)(CommentList *comList))success
                                             failure:(void (^)(NSError *error))failure;

/**
 *  用户发布评论
 *
 *  @param usrId           用户编号
 *  @param acId            活动编号
 *  @param fatherCommentId 父评论编号
 *  @param commentContent  评论内容
 *  @param success code 200操作成功，210操作失败
 *  @param failure 返回NSError
 *
 *  @return 网络请求任务
 */
-(NSURLSessionDataTask *) publishCommentWithUsrID:(NSString *)usrId
                                             acID:(NSString *)acId
                                  fatherCommentID:(NSString *)fatherCommentId
                                   commentContent:(NSString *)commentContent
                                          success:(void (^)(NSString *msg))success
                                          failure:(void (^)(NSError *error))failure;

/**
 *  用户删除评论
 *
 *  @param usrId     用户编号
 *  @param commentId 评论编号
 *  @param success code 200操作成功，210操作失败
 *  @param failure 返回NSError
 *
 *  @return 网络请求任务
 */
-(NSURLSessionDataTask *) deleteCommentWithUsrID:(NSString *)usrId
                                       commentID:(NSString *)commentId
                                         success:(void (^)(NSString *msg))success
                                         failure:(void (^)(NSError *error))failure;

/**
 *  评论点赞与取消赞
 *
 *  @param usrId     用户编号
 *  @param commentId 评论编号
 *  @param opType    操作类型，1是点赞，2是取消点赞
 *  @param success   code 200操作成功，210操作失败,220点赞失败，230取赞失败
 *  @param failure 返回NSError
 *
 *  @return 网络请求任务
 */
-(NSURLSessionDataTask *) praiseCommentWithUsrId:(NSString *)usrId
                                       commentId:(NSString *)commentId
                                          opType:(NSString *)opType
                                         success:(void (^)(NSString *msg))success
                                         failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) joinTripWithUserId:(NSString *)userId
                                        acId:(NSString *)acId
                                      opType:(NSString *)opType
                                     success:(void (^)(NSString *planId))success
                                     failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) getMoreActivityWithAcId:(NSString *)acId
                                          success:(void (^)(ActivityList *acList))success
                                          failure:(void (^)(NSError *))failure;

#pragma mark - Public Request Methods - Industry

-(NSURLSessionDataTask *) getAllIndustriesWithSuccess:(void (^)(IndustryList *indList))success
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
                                    success:(void (^)(PlanList *plList))success
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
                                    success:(void (^)(NSString *replanId))success
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

-(NSURLSessionDataTask *) getUserActivityWithUserId:(NSString *)userId
                                             opType:(NSString *)opType
                                            success:(void (^)(ActivityList *acList))success
                                            failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) getUserPlanWithUserId:(NSString *)userId
                                        success:(void (^)(PlanList *plList))success
                                        failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) putFeedBackWithUserId:(NSString *)userId
                                         fbMail:(NSString *)fbMail
                                        fbPhone:(NSString *)fbPhone
                                      fbContent:(NSString *)fbContent
                                        success:(void (^)(NSString *msg))success
                                        failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *) getVersionWithSuccess:(void (^)(NSString *msg))success
                                        failure:(void (^)(NSError *error))failure;

- (void)uploadImgWithImage:(UIImage *)image
                fileName:(NSString *)fileName
                 success:(void (^)(id responseObject))success
                    fail:(void (^)(NSError *error))failure;

#pragma mark - Login & Profile

-(NSURLSessionDataTask *)UserLoginOrRegisteWithUserphone:(NSString *)userphone
                                                password:(NSString *)password
                                                 op_type:(NSString *)op_type
                                                 success:(void (^)(UserModel *user))success
                                                 failure:(void (^)(NSError *error))failure;
- (void)UserLogout;

-(NSURLSessionDataTask *)resetPwdWithMobile:(NSString *)mobile
                                     passwd:(NSString *)passwd
                                    success:(void (^)(NSString *msg))success
                                    failure:(void (^)(NSError *error))failure;

-(NSURLSessionDataTask *)sendMobileMsgWithMobile:(NSString *)mobile
                                            type:(NSString *)type
                                             msg:(NSString *)msg
                                           token:(NSString *)token
                                         success:(void (^)(NSString *code))success
                                         failure:(void (^)(NSError *error))failure;

@end