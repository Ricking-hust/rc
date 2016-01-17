//
//  MyActivitiesViewController.m
//  日常
//
//  Created by AlanZhang on 15/12/23.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import "MyActivitiesInfoViewController.h"
#import "ActivitiesInfo.h"

@interface MyActivitiesInfoViewController ()

@end

@implementation MyActivitiesInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellIndentifier = @"ActivitiesInfo";//这里的cellID就是cell的xib对应的名称
    
    ActivitiesInfo *cell = (ActivitiesInfo *)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
    if(nil == cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIndentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    //configuring the cell ......
    cell.activityImage.image = [UIImage imageNamed:@"activityImage.png"];
    cell.activityName.text = @"相亲大会";
    cell.activityTime.text = @"时间：2015.11.11";
    cell.activityPlace.text = @"地点：光谷体育馆";
//    cell.activityIcon
    self.tableView.rowHeight = cell.frame.size.height;
    cell.activityLabel.text = @"油条";
    
    
    return cell;
}


@end
