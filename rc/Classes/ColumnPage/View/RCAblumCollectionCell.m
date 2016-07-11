//
//  CSAblumCollectionCell.m
//  rc
//
//  Created by LittleMian on 16/7/11.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCAblumCollectionCell.h"
#import "RCAblumInfoCollectionViewController.h"
#import "Masonry.h"
@interface RCAblumCollectionCell()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITapGestureRecognizer *clickImageView;
@property (nonatomic, weak) UIView *superView;
@end
@implementation RCAblumCollectionCell
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 150)];
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, kScreenWidth, 40)];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        line.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
        [self.contentView addSubview:line];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.label];
        
        self.imageView.userInteractionEnabled = YES;
        self.clickImageView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickImageView:)];
        [self.imageView addGestureRecognizer:self.clickImageView];
    }
    self.backgroundColor = [UIColor whiteColor];
    return self;
}
- (void)setResponder:(UIView *)view
{
    self.superView = view;
}
- (void)setPicture:(UIImage *)image
{
    self.imageView.image = image;
}
- (void)setTittle:(NSString *)tittle
{
    self.label.text = tittle;
    self.label.font = [UIFont systemFontOfSize:15];
}
/**
 *  跳转到精选详情页
 *
 *  @param gesture 单击
 */
- (void)didClickImageView:(UITapGestureRecognizer *)gesture
{
    RCAblumInfoCollectionViewController *vc = [[RCAblumInfoCollectionViewController alloc]init];
    [[self viewController].navigationController pushViewController:vc animated:YES];
}
- (UIResponder *)nextResponder
{
    [super nextResponder];
    return self.superView;
}
-(UIViewController *)viewController {
    /// Finds the view's view controller.
    
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    return nil;
}
@end
