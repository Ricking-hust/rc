//
//  PreCommentView.h
//  rc
//
//  Created by 余笃 on 16/7/4.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface PreCommentView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIButton *showCommentBtn;
@property (nonatomic,strong) UIButton *collectTooBtn;
@property (nonatomic,strong) UIButton *checkMoreBtn;
@property (nonatomic,strong) UITableView *preCommentView;

@property (nonatomic,strong) CommentList *commentList;

-(void)setSubViewsValue;
-(void)showOrDissMissCommentWith:(BOOL)isShow;

@end
