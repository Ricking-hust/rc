//
//  CZRightTableViewDelegate.m
//  rc
//
//  Created by AlanZhang on 16/3/10.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZRightTableViewDelegate.h"
#import "CZTableView.h"
#import "CZColumnCell.h"
@implementation CZRightTableViewDelegate
- (id)init
{
    if (self = [super init])
    {
        self.leftTableView = [[CZTableView alloc]init];
        self.rightTableView = [[CZTableView alloc]init];
        self.array = [[NSArray alloc]init];
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
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    NSString *str = [NSString stringWithFormat:@"right %ld",indexPath.row];
    cell.textLabel.text = str;
    return cell;
//    //1 创建可重用的自定义cell
//    static NSString *reuseId = @"columnCell";
//    CZColumnCell * cell = (CZColumnCell*)[tableView dequeueReusableCellWithIdentifier:reuseId];
//    if (!cell)
//    {
//        cell = [[CZColumnCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //清除cell的点击状态
//    cell.isLeft = NO;
//    //对cell内的控件进行赋值
//    
//    
//    //对cell内的控件进行布局
//    [cell setSubviewConstraint];
//    
//    //2 返回cell
//    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.array.count-1 == indexPath.row &&self.subHeight != 0)
    {
        return self.subHeight;
    }
    return 100;
    //return 100;
//    CZColumnCell *cell = (CZColumnCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return cell.cellHeight;
}
//给单元格进行赋值
- (void) setCellValue:(CZColumnCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.leftTableView setContentOffset:self.rightTableView.contentOffset];
}

@end
