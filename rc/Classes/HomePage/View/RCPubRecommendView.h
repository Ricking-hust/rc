//
//  RCUsrRecomnendView.h
//  rc
//
//  Created by 余笃 on 16/6/13.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublisherModel.h"

@interface RCPubRecommendView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) PublisherList *pubList;

@end
