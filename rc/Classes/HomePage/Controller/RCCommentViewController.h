//
//  RCCommentViewViewController.h
//  rc
//
//  Created by 余笃 on 16/7/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "MBProgressHUD.h"

@interface RCCommentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) CommentList *commentList;
@property (nonatomic,strong) ActivityModel *acModel;
@property (nonatomic,strong) UITableView *commentTableView;
@property (nonatomic, strong) MBProgressHUD *HUD;

@end
