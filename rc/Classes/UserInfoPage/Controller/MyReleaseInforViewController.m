//
//  MyReleaseInforViewController.m
//  日常
//
//  Created by AlanZhang on 15/12/26.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import "MyReleaseInforViewController.h"
#import "MyRelease.h"

@interface MyReleaseInforViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *checkedBtn;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *willCheckBtn;
@property (weak, nonatomic) IBOutlet UIToolbar *myActivityToolBar;



@end

@implementation MyReleaseInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //工具栏按钮颜色的设置
    self.myActivityToolBar.tintColor = [UIColor redColor];
    //工具栏的背影色
//    self.myActivityToolBar.barTintColor = [UIColor blackColor];
    //工具栏背景图的设置
//    UIImage *img = [UIImage imageNamed:@"activityImage.png"];
//    [self.myActivityToolBar setBackgroundImage:img forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    
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
    
    
    static NSString *cellIndentifier = @"MyRelease";//这里的cellID就是cell的xib对应的名称
    
    MyRelease *cell = (MyRelease *)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    
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
    cell.activityLabel.text = @"油条";
    self.tableView.rowHeight = cell.frame.size.height;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
