//
//  publisherCell.h
//  rc
//
//  Created by 余笃 on 16/6/22.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublisherCell : UITableViewCell

@property (nonatomic,strong) UIImageView *publisher;
@property (nonatomic,strong) UILabel *pubName;
@property (nonatomic,strong) UIButton *follow;


-(void)setSubviewsValueWithImage:(NSString *)imageStr PubName:(NSString *)pubName;

@end
