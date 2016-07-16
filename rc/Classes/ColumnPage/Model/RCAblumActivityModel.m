//
//  RCAblumActivityModel.m
//  rc
//
//  Created by LittleMian on 16/7/13.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCAblumActivityModel.h"

@implementation RCAblumActivityModel

- (id)initWithModel:(RCAblumActivityModel *)model
{
    if (self = [super init])
    {
        self.ac_id = model.ac_id;
        self.ac_img = model.ac_img;
        self.ac_title = model.ac_title;
        self.ac_time = model.ac_time;
        self.ac_place = model.ac_place;
        self.ac_des = model.ac_des;
        self.height = model.height;
        self.tittleSize = model.tittleSize;
        self.timeSize = model.timeSize;
        self.desSize = model.desSize;
        self.placeSize = model.placeSize;
    }
    return self;
}
@end
