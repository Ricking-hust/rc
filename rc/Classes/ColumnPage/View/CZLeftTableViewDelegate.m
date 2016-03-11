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

@implementation CZLeftTableViewDelegate
- (id)init
{
    if (self = [super init])
    {
        self.leftTableView = [[CZTableView alloc]init];
        self.rightTableView = [[CZTableView alloc]init];
        self.array = [[NSMutableArray alloc]init];
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

    CZColumnCell *cell = [[CZColumnCell alloc]init];
    NSString *str = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.textLabel.text = str;
    return cell;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.rightTableView setContentOffset:self.leftTableView.contentOffset];
}

@end
