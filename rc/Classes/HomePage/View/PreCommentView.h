//
//  PreCommentView.h
//  rc
//
//  Created by 余笃 on 16/7/4.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreCommentView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIButton *showCommentBtn;
@property (nonatomic,strong) UIButton *collectTooBtn;
@property (nonatomic,strong) UIButton *checkMoreBtn;
@property (nonatomic,strong) UITableView *preCommentView;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,assign) CGFloat collectTooH;
@property (nonatomic,assign) CGFloat preCommentViewH;
@property (nonatomic,assign) CGFloat checkMoreBtnH;

-(void)setSubViewsValue;

@end
