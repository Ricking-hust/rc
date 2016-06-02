//
//  RCDirectView.h
//  rc
//
//  Created by 余笃 on 16/5/31.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RCDirectView : UIView

@property (nonatomic,strong) UIButton *hotBtn;
@property (nonatomic,strong) UIButton *univerBtn;
@property (nonatomic,strong) UIButton *besidesBtn;
@property (nonatomic,strong) UIButton *careChoiceBtn;
@property (nonatomic,strong) UILabel *hotLable;
@property (nonatomic,strong) UILabel *univerLable;
@property (nonatomic,strong) UILabel *besidesLable;
@property (nonatomic,strong) UILabel *careChoiceLable;

- (void)setSubView;

@end
