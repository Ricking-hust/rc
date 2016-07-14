//
//  RCColumnScrollViewDelegate.h
//  rc
//
//  Created by AlanZhang on 16/4/1.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCColumnScrollViewDelegate : UIView<UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *toolButtonArray;
@property (nonatomic, strong) UIScrollView *toolScrollView;
@property (nonatomic, assign) CurrentDevice device;
@property (nonatomic, strong) UIView *line;
@end
