//
//  ThemeModel.m
//  日常
//
//  Created by 余笃 on 16/1/28.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "ThemeModel.h"

@implementation ThemeModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self =[super initWithDictionary:dict] ) {
        self.themeId            = [dict objectForKey:@"theme_id"];
        self.themeName          = [dict objectForKey:@"theme_name"];
    }
    return self;
}

@end
