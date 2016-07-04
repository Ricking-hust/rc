//
//  PreCommentView.h
//  rc
//
//  Created by 余笃 on 16/7/4.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kCellIdentifier_CommentCell @"kCellIdentifier_CommentCell"

@interface PreCommentView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UILabel *collectTooLab;
@property (nonatomic,strong) UIButton *checkMoreBtn;
@property (nonatomic,strong) UITableView *preCommentView;

@end
