//
//  PublisherViewController.h
//  rc
//
//  Created by 余笃 on 16/7/23.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublisherModel.h"

@interface PublisherViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *pubInfoView;
@property (nonatomic,strong) PublisherModel *pubModel;

@end
