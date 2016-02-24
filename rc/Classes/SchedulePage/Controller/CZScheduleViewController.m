//
//  CZScheduleViewController.m
//  日常
//
//  Created by AlanZhang on 15/12/22.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import "CZScheduleViewController.h"
#import "Masonry.h"
#import "CZTimeCourseCell.h"
#import "CZData.h"
#import "CZScheduleInfoViewController.h"
#import "CZAddScheduleViewController.h"

@interface CZScheduleViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *moreImg;
@property (nonatomic, assign) BOOL isShowDeleteButton;
@property (nonatomic, assign) long int cellIndex;

@end

@implementation CZScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isShowDeleteButton = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    [self.moreImg setImage:[UIImage imageNamed:@"more"]];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    NSDate *senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"MM月dd日"];
    
    NSString *locationString=[dateformatter stringFromDate:senddate];
    
    self.navigationItem.title = locationString;
    
    
 
}
- (void)viewWillAppear:(BOOL)animated
{
    self.isShowDeleteButton = NO;
    [self.tableView reloadData];
}
//添加行程
- (IBAction)toAddSchedule:(id)sender
{
    
    CZAddScheduleViewController *addScheduleViewController = [[CZAddScheduleViewController alloc]init];
    
    addScheduleViewController.title = @"添加行程";
    
    [self.navigationController pushViewController:addScheduleViewController animated:YES];
}

#pragma mark - 懒加载

- (NSMutableArray *)datas
{
    if (!_datas)
    {
        _datas = [[NSMutableArray alloc]init];
        for (int i = 0; i< 10; i++)
        {
            CZData *data = [CZData data];
            data.contentStr = [NSString stringWithFormat:@"%d老夫聊发少年狂,治肾亏,不含糖.",i];
            [_datas addObject:data];
        }
    }
    return _datas;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = [UIColor clearColor];
        CGRect rect = [[UIScreen mainScreen]bounds];
        [self.view addSubview:_tableView];
        CGSize size = CGSizeMake(rect.size.width, rect.size.height - 64 - self.moreImg.image.size.height);
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.top.equalTo(self.moreImg.mas_bottom);
            make.size.mas_equalTo(size);
        }];
        
    }
    return _tableView;
}
- (UIImageView *)moreImg
{
    if (!_moreImg) {
        UIView *moreView = [[UIView alloc]init];
        moreView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:moreView];
        _moreImg = [[UIImageView alloc]init];
        _moreImg.image = [UIImage imageNamed:@"more"];
        [moreView addSubview:_moreImg];
        CGRect rect = [[UIScreen mainScreen]bounds];
        CGFloat leftPadding = rect.size.width * 0.21 - _moreImg.image.size.width / 2;
        [moreView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([[UIScreen mainScreen]bounds].size.width);
            make.top.equalTo(self.view.mas_top).with.offset(64);
            make.left.equalTo(self.view.mas_left);
            make.height.mas_equalTo(_moreImg.image.size.height);
        }];
        [_moreImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(moreView.mas_left).with.offset(leftPadding);
            make.top.equalTo(moreView.mas_top).with.offset(0);
            make.size.mas_equalTo(_moreImg.image.size);
        }];
    }
    return _moreImg;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.datas.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //添加单击手势
    UITapGestureRecognizer *clickGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelecteCellGesture:)];

    //添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressView:)];
    //长按响应时间
    longPress.minimumPressDuration = 1;
    longPress.delegate = self;

    if (indexPath.row == self.datas.count - 1)
    {//当前的cell
        CZTimeCourseCell *cell = [CZTimeCourseCell cellWithTableView:tableView];

        cell.isLastCell = YES;
        cell.data = self.datas[indexPath.row];
        
        [cell.bgImage addGestureRecognizer:longPress];
        
        [cell.bgImage addGestureRecognizer:clickGesture];
        
        cell.tag = indexPath.row;
        
        [cell.deleteButton addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
        cell.contentView.tag = indexPath.row;
        

        if (self.isShowDeleteButton)
        {
            if (indexPath.row == self.cellIndex)
            {
                CABasicAnimation *animation = (CABasicAnimation *)[cell.deleteButton.layer animationForKey:@"rotation"];
                if (animation == nil)
                {
                    //[self shakeImage];
                    //创建动画对象,绕Z轴旋转
                    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                    
                    //设置属性，周期时长
                    [animation setDuration:0.08];
                    
                    //抖动角度
                    animation.fromValue = @(-M_1_PI/2);
                    animation.toValue = @(M_1_PI/2);
                    //重复次数，无限大
                    animation.repeatCount = HUGE_VAL;
                    //恢复原样
                    animation.autoreverses = YES;
                    //锚点设置为图片中心，绕中心抖动
                    
                    cell.deleteButton.layer.anchorPoint = CGPointMake(0.5, 0.5);
                    
                    [cell.deleteButton.layer addAnimation:animation forKey:@"rotation"];
                }else
                {
                    [self resume];
                }
                cell.deleteButton.hidden = NO;
                [cell.bgImage removeGestureRecognizer:clickGesture];
            }
        }
        return cell;
    }else if (indexPath.row == self.datas.count)
    {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.backgroundColor = [UIColor clearColor];
        return cell;

    }else
    {
        CZTimeCourseCell *cell = [CZTimeCourseCell cellWithTableView:tableView];
        cell.data = self.datas[indexPath.row];

        [cell.bgImage addGestureRecognizer:longPress];
        [cell.bgImage addGestureRecognizer:clickGesture];
        cell.tag = indexPath.row;
        
        [cell.deleteButton addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
        cell.contentView.tag = indexPath.row;
        
        if (self.isShowDeleteButton)
        {
            if (indexPath.row == self.cellIndex)
            {
                CABasicAnimation *animation = (CABasicAnimation *)[cell.deleteButton.layer animationForKey:@"rotation"];
                if (animation == nil)
                {
                    //[self shakeImage];
                    //创建动画对象,绕Z轴旋转
                    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                    
                    //设置属性，周期时长
                    [animation setDuration:0.08];
                    
                    //抖动角度
                    animation.fromValue = @(-M_1_PI/2);
                    animation.toValue = @(M_1_PI/2);
                    //重复次数，无限大
                    animation.repeatCount = HUGE_VAL;
                    //恢复原样
                    animation.autoreverses = YES;
                    //锚点设置为图片中心，绕中心抖动

                    cell.deleteButton.layer.anchorPoint = CGPointMake(0.5, 0.5);
                    
                    [cell.deleteButton.layer addAnimation:animation forKey:@"rotation"];


                }else
                {
                    [self resume];
                }
                cell.deleteButton.hidden = NO;
                [cell.bgImage removeGestureRecognizer:clickGesture];
            }
        }
        return cell;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.datas.count)
    {
        return 100;
    }else
    {
        CZTimeCourseCell *cell = (CZTimeCourseCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        if (cell.cellSize.height < 100)
        {
            return 100;
        }else
        {
            return cell.cellSize.height;
        }
    }

}
////插入单元格
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

- (void)deleteCell:(UIButton *)btn
{
    self.isShowDeleteButton = NO;
    
    UIView *contentView = btn.superview;
    [self.datas removeObjectAtIndex:contentView.tag];

    [self.tableView reloadData];
}

#pragma mark - 手势代理,允许多个手势同时发生
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (void)didSelecteCellGesture:(UITapGestureRecognizer *)gesture
{
//    UIView *view = gesture.view;
//    UIView *contentView = view.superview;
//    CZTimeCourseCell *cell = contentView.superview;
//    long int indexOfCell = cell.tag;
    //------------
    CZScheduleInfoViewController *scheduleInfoViewController = [[CZScheduleInfoViewController alloc]init];
    [self.navigationController pushViewController:scheduleInfoViewController animated:YES];
}
- (void)longPressView:(UILongPressGestureRecognizer *)longPressGest{
    self.isShowDeleteButton = YES;
    
    if (longPressGest.state == UIGestureRecognizerStateBegan)
    {
         NSLog(@"长按手势开始");
        UIView *view = longPressGest.view;
        UIGestureRecognizer *gesture = view.gestureRecognizers[1];
        [view removeGestureRecognizer:gesture];
        
        UIView *contentView = view.superview;

        CZTimeCourseCell *cell = (CZTimeCourseCell *)contentView.superview;
        cell.isShowDeleteButton = YES;
        cell.deleteButton.hidden = NO;
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cell.tag inSection:1];
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.cellIndex = contentView.tag;
        [self.tableView reloadData];
//        CABasicAnimation *animation = (CABasicAnimation *)[cell.deleteButton.layer animationForKey:@"rotation"];
//        if (animation == nil)
//        {
////            [self shakeImage];
//            //创建动画对象,绕Z轴旋转
//            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//            
//            //设置属性，周期时长
//            [animation setDuration:0.08];
//            
//            //抖动角度
//            animation.fromValue = @(-M_1_PI/2);
//            animation.toValue = @(M_1_PI/2);
//            //重复次数，无限大
//            animation.repeatCount = HUGE_VAL;
//            //恢复原样
//            animation.autoreverses = YES;
//            //锚点设置为图片中心，绕中心抖动
//        
//            cell.deleteButton.layer.anchorPoint = CGPointMake(0.5, 0.5);
//            
//            [cell.deleteButton.layer addAnimation:animation forKey:@"rotation"];
//
//
//        }else
//        {
//            [self resume];
//        }
    }else
    {
        NSLog(@"长按手势结束");

    }
}
- (void)pause
{
    for (int i = 0; i < self.tableView.visibleCells.count; ++i)
    {
        CZTimeCourseCell *cell = self.tableView.visibleCells[i];
        cell.deleteButton.layer.speed = 0.0;
    }

}

- (void)resume
{
    for (int i = 0; i < self.tableView.visibleCells.count; i++)
    {
        CZTimeCourseCell *cell = self.tableView.visibleCells[i];
        cell.deleteButton.layer.speed = 1.0;
        
    }
}

- (void)shakeImage
{
    //创建动画对象,绕Z轴旋转
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //设置属性，周期时长
    [animation setDuration:0.08];
    
    //抖动角度
    animation.fromValue = @(-M_1_PI/2);
    animation.toValue = @(M_1_PI/2);
    //重复次数，无限大
    animation.repeatCount = HUGE_VAL;
    //恢复原样
    animation.autoreverses = YES;
    //锚点设置为图片中心，绕中心抖动

    for (int i = 0; i < self.tableView.visibleCells.count; i++)
    {
        CZTimeCourseCell *cell = self.tableView.visibleCells[i];
        cell.deleteButton.layer.anchorPoint = CGPointMake(0.5, 0.5);
        
        [cell.deleteButton.layer addAnimation:animation forKey:@"rotation"];
    }



}//如果点击图标外区域，停止抖动
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    //转换坐标系，判断touch点是否在imageView内，在的话，仍然抖动，否则停止抖动

    for (int i = 0; i < self.tableView.visibleCells.count; ++i)
    {
        CZTimeCourseCell *cell = self.tableView.visibleCells[i];
        CGPoint p = [self.view convertPoint:point toView:cell.deleteButton];
        if (![cell.deleteButton pointInside:p withEvent:event])
        {
            cell.deleteButton.hidden = YES;
            [self pause];
        }
    }
    self.isShowDeleteButton = NO;
    [self.tableView reloadData];

}
@end
