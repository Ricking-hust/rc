//
//  MyRelease.h
//  日常
//
//  Created by AlanZhang on 15/12/26.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRelease : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *activityImage;
@property (weak, nonatomic) IBOutlet UILabel *activityName;
@property (weak, nonatomic) IBOutlet UILabel *activityTime;
@property (weak, nonatomic) IBOutlet UILabel *activityPlace;
@property (weak, nonatomic) IBOutlet UILabel *activityIcon;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@end
