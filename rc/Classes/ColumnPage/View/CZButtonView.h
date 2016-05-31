//
//  CZButtonView.h
//  rc
//
//  Created by AlanZhang on 16/2/14.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CZButtonView : UIView
@property (nonatomic, strong) UIButton *tagButton;
@property (nonatomic, strong) UIView *line;

+(instancetype) buttonView;
- (id)initWithTittle:(NSString *)tittle;
@end
