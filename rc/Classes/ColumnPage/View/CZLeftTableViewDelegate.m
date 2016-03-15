//
//  CZLeftTableViewDelegate.m
//  rc
//
//  Created by AlanZhang on 16/3/10.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZLeftTableViewDelegate.h"
#import "CZTableView.h"
#import "CZColumnCell.h"
#import "ActivityModel.h"
#import "CZActivityInfoViewController.h"
@implementation CZLeftTableViewDelegate
- (id)init
{
    if (self = [super init])
    {
        self.leftTableView = [[CZTableView alloc]init];
        self.rightTableView = [[CZTableView alloc]init];
        self.array = [[NSArray alloc]init];
        self.view  = [[UIView alloc]init];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    //1 创建可重用的自定义cell
//    static NSString *reuseId = @"columnCell";
//    CZColumnCell * cell = (CZColumnCell*)[tableView dequeueReusableCellWithIdentifier:reuseId];
//    if (!cell)
//    {
//        cell = [[CZColumnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
//    }
    CZColumnCell *cell = [[CZColumnCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //清除cell的点击状态
    cell.isLeft = YES;
    cell.backgroundColor = [UIColor clearColor];
    //对cell内的控件进行赋值
    [self setCellValue:cell AtIndexPath:indexPath];
    
    //对cell内的控件进行布局
    [cell setSubviewConstraint];
    
    //2 返回cell
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.array.count-1 == indexPath.row && self.subHeight != 0)
    {
        return self.subHeight;
    }else
    {
        CZColumnCell *cell = (CZColumnCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.cellHeight;
    }
}

//给单元格进行赋值
- (void) setCellValue:(CZColumnCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    cell.bgView.tag = indexPath.row;
    ActivityModel *model = self.array[indexPath.row];
    [cell.acImageView sd_setImageWithURL:[NSURL URLWithString:model.acPoster] placeholderImage:[UIImage imageNamed:@"20160102.png"]];
    cell.acNameLabel.text = model.acTitle;
    cell.acTimeLabel.text = model.acTime;
    cell.acTagLabel.text = model.acTime;
    //添加手势
    UITapGestureRecognizer *clickGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayInfo:)];
    [cell.bgView addGestureRecognizer:clickGesture];
}
- (void)displayInfo:(UITapGestureRecognizer *)gesture
{
    UIView *view = gesture.view;
    CZActivityInfoViewController *info = [[CZActivityInfoViewController alloc]init];
    info.title = @"活动介绍";
    info.activityModelPre = self.array[view.tag];

    [[self viewController].navigationController pushViewController:info animated:YES];
}
- (UIViewController *)viewController
{
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    return nil;
}

- (UIResponder *)nextResponder
{
    [super nextResponder];
    return self.view;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.rightTableView setContentOffset:self.leftTableView.contentOffset];
}

@end
