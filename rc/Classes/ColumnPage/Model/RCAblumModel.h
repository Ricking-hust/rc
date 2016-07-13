//
//  RCAblumActivityModel.h
//  rc
//
//  Created by LittleMian on 16/7/12.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCAblumModel : NSObject
@property (nonatomic, strong) NSString *album_id;   //专辑编号
@property (nonatomic, strong) NSString *album_name; //专辑名称
@property (nonatomic, strong) NSString *album_img;  //专辑图片
@property (nonatomic, strong) NSString *album_time; //专辑开始时间
@property (nonatomic, strong) NSString *read_num;   //专辑阅读数
@property (nonatomic, strong) NSString *album_desc; //专辑介绍
@end
