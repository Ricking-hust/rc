//
//  DataParse.m
//  日常
//
//  Created by 余笃 on 15/12/21.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//
//test yu-1

#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "AFNetworking.h"

static NSString *const kUsername = @"username";
static NSString *const kUserid = @"userid";
static NSString *const kUserIsLogin = @"userIsLogin";

@interface DataManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation DataManager

-(instancetype)init{
    if (self = [super init]) {
        BOOL isLogin = [[[NSUserDefaults standardUserDefaults] objectForKey:kUserIsLogin] boolValue];
        if (isLogin) {
            UserModel *user = [[UserModel alloc] init];
            user.login = YES;
            user.userId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserid];
            user.userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUsername];
            _user = user;
        }
    }
    return self;
}

- (void)setPreferHttps:(BOOL)preferHttps {
    _preferHttps = preferHttps;
    
    NSURL *baseUrl;
    
    if (preferHttps) {
        baseUrl = [NSURL URLWithString:@"https://www.v2ex.com"];
    } else {
        baseUrl = [NSURL URLWithString:@"http://www.v2ex.com"];
    }
    
    self.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl];
    AFHTTPRequestSerializer* serializer = [AFHTTPRequestSerializer serializer];
    self.manager.requestSerializer = serializer;
    
}

+(instancetype)manager{
    static DataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        manager = [[DataManager alloc] init];
    });
    return manager;
}

-(NSURLSessionDataTask*) requestWithURLString:(nonnull NSString *)URLString
                                   parameters:(NSDictionary *)parameters
                                      success:(void (^)(NSURLSessionDataTask *task,id responseObject))success
                                      failure:(void (^) (NSError *error))failure{
    //stateBar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //Handle Common Mission, Cache, Data Reading & etc.
    void (^responseHandleBlock) (NSURLSessionDataTask *task,id responseObject) = ^
    (NSURLSessionDataTask *task,id reponseObject){
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        success(task,reponseObject);
    };
    
    // Create HTTPSession
    NSURLSessionDataTask *task = nil;
    
    [self.manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"User-Agent"];
    NSLog(@"%@",self.manager.requestSerializer.HTTPRequestHeaders);
    
    
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        self.manager.responseSerializer = responseSerializer;
        task = [self.manager POST:URLString parameters:parameters
        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            responseHandleBlock(task,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            NSLog(@"Error:%@",error);
            failure(error);
        }];
    
    return task;
}


#pragma mark - Public Request Methods - Post
-(NSURLSessionDataTask *) getCityListSuccess:(void (^)(NSDictionary *cityList))success
                                     failure:(void (^)(NSError *error))failure{

    return [self requestWithURLString:@"/api/nodes/all.json" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *cityList = [[NSDictionary alloc] initWithDictionary:responseObject];
        success(cityList);
    } failure:^(NSError *error) {
        failure(error);
    }];
};

-(NSURLSessionDataTask *) setCityWithUserId:(NSString *)userid
                                     cityId:(NSString *)cityid
                                    success:(void (^)(NSString *))success
                                    failure:(void (^)(NSError *))failure{
    NSString *urlString = [NSString stringWithFormat:@"/Home/PersonalInfoController/SetCity/%@?cityid=%@",userid,cityid];
    return [self requestWithURLString:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(@"setsuccess");
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(NSURLSessionDataTask *) getAllTagsSuccess:(void (^)(NSDictionary *Tags))success
                                    failure:(void (^)(NSError *error))failure{
    
    return [self requestWithURLString:@"" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *tags = [[NSDictionary alloc] initWithDictionary:responseObject];
        success(tags);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(NSURLSessionDataTask *) setTagsWithUserId:(NSString *)userid
                                    success:(void (^)(NSString *))success
                                    failure:(void (^)(NSError *))failure{
    NSString *urlString = [NSString stringWithFormat:@"/Home/PersonalInfoController/setTags?userid=%@",userid];
    return [self requestWithURLString:urlString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(@"setTagssuccess");
    } failure:^(NSError *error) {
        failure(error);
    }];
}

-(NSURLSessionDataTask *) getPopularSearchSuccess:(void (^)(NSDictionary *PopularTags))success
                                          failure:(void (^)(NSError *error))failure{
    return [self requestWithURLString:@"/Home/ActivityController/getPopularSearchs" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *popularTags = [[NSDictionary alloc] initWithDictionary:responseObject];
        success(popularTags);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark - Public Request Methods - Login & Profile

-(NSURLSessionDataTask *)UserLoginWithUsername:(NSString *)username
                                      password:(NSString *)password
                                        optype:(NSString *)optype
                                       success:(void (^)(NSString *message))success
                                       failure:(void (^)(NSError *error))failure{
    NSDictionary *parameters = @{
        @"p":password,
        @"u":username,
        @"o":optype,
    };
    
    [self requestWithURLString:@"Home/Person/login" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([str rangeOfString:@"200"].location != NSNotFound) {
            success(username);
        }else{
            NSError *error = [[NSError alloc] initWithDomain:self.manager.baseURL.absoluteString code:ErrorTypeLoginFailure userInfo:nil];
            failure(error);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
    
    return nil;
}

/*URLConnection方法
-(void) startRequest{
    
    NSString *strURL = @"https://maps.googleapis.com/maps/api/geocode";
    strURL = [strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL *url = [NSURL URLWithString:strURL];
    
    NSString *post;
    if (action == QUERY) {
        //查询处理
        post = [NSString stringWithFormat:@"userid=%@&type=%@&action=%@",@"userid",@"JSON",@"query"];
    }else if (action == REMOVE){
        //删除处理
        NSMutableDictionary* dict = self.objects[deleteID];
        post = [NSString stringWithFormat:@"userid=%@&type=%@&action=%@",@"userid",@"JSON",@"remove"];
        [dict objectForKey:@"ID"];
    }
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
        self.datas = [NSMutableData new];
    }
    
}

#pragma mark- NSURLConnection回调方法
-(void) connection:(NSURLConnection*)connection didReceiveData:(nonnull NSData *)data{
    [self.datas appendData:data];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(nonnull NSError *)error{
    NSLog(@"%@",[error localizedDescription]);
}

-(void) connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSLog(@"请求完成。。。");
    
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:self.datas options:NSJSONReadingAllowFragments error:nil];
    
    if (action == QUERY) {
        //查询处理
        UserModel *user = [[UserModel alloc] init];
        user.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"use_id"];
        NSArray* arrayResult =[dict objectForKey:@"results"];
        NSDictionary* resultDic = [arrayResult objectAtIndex:0];
        NSDictionary* geometryDic = [resultDic objectForKey:@"geometry"];
        NSLog(@"geometryDic: %@,  resultDic:%@",geometryDic,resultDic);
    }else if (action == REMOVE){
        //删除处理
        NSString *message = @"操作成功";
        
        NSNumber *resultCodeObj = [dict objectForKey:@"ResultCode"];
        
        if ([resultCodeObj integerValue] < 0) {
            message = [resultCodeObj errorMessage];
        }
    }
    
    //重新查询
    action = QUERY;
    [self startRequest];
}
*/

@end