//
//  RCAblumActivityModel.m
//  rc
//
//  Created by LittleMian on 16/7/12.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCAblumModel.h"

@implementation RCAblumModel
- (id)init
{
    if (self = [super init])
    {
        self.album_time = @"";
        self.album_name = @"";
        self.album_img  = @"";
        self.album_id   = @"";
        self.album_desc = @"";
        self.read_num   = @"";
    }
    return self;
}
@end
