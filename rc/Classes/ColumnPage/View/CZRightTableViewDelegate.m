//
//  CZRightTableViewDelegate.m
//  rc
//
//  Created by AlanZhang on 16/3/10.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZRightTableViewDelegate.h"
#import "CZTableView.h"
@implementation CZRightTableViewDelegate
- (id)init
{
    if (self = [super init])
    {
        self.leftTableView = [[CZTableView alloc]init];
        self.rightTableView = [[CZTableView alloc]init];
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    NSString *str = [NSString stringWithFormat:@"rigth %ld",indexPath.row];
    cell.textLabel.text = str;
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.leftTableView setContentOffset:self.rightTableView.contentOffset];
}

@end
