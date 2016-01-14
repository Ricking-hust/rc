//
//  NSNumber+Message.m
//  日常
//
//  Created by 余笃 on 15/12/22.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import "NSNumber+Message.h"

@implementation NSNumber (Message)

-(NSString *)errorMessage{
    NSString *errorStr=@"";
    switch ([self integerValue]) {
        case -1:
            errorStr = @"用户不存在";
            break;
            
        default:
            break;
    }
    return errorStr;
}

@end
