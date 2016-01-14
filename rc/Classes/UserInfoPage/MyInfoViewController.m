//
//  MyInfoViewController.m
//  日常
//
//  Created by AlanZhang on 15/12/19.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import "MyInfoViewController.h"
#import "UserInfoCell.h"
#import "ShowUserInfoViewController.h"
#import "MyActivitiesInfoViewController.h"
#import "MyReleaseInforViewController.h"
#import "MyCollectInfoViewController.h"
#import "AboutUsInfoViewController.h"
#import "FeedbackViewController.h"
#import "SettingViewController.h"


@interface MyInfoViewController ()

@property UINib *cellNib;

@end

@implementation MyInfoViewController

- (void)viewWillAppear:(BOOL)animated{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.dataSource = self;
    
    
}
//单元格的点击事件
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    long int section = [indexPath section];

    switch (section) {
        case 0:{
            
            //从故事板中初始化控制界面
            UIStoryboard *showUserInfo = [UIStoryboard storyboardWithName:@"ShowUserInfo" bundle:nil];
            
            ShowUserInfoViewController *showUserInfoViewController = [showUserInfo instantiateViewControllerWithIdentifier:@"ShowUserInfo"];
            
            //设置界面的标题
            showUserInfoViewController.title = @"个人资料";
            
            //跳转到二级视图时隐藏tablebar的选项
            //self.hidesBottomBarWhenPushed = YES;
            //定义二级视图的导航栏返回按钮
            self.hidesBottomBarWhenPushed = YES;
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(showBar)];
        
            [self.navigationItem setBackBarButtonItem:backItem];
            [self.navigationController pushViewController:showUserInfoViewController animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            
        }
            break;
            
        case 1:{
            if (indexPath.row == 0) {
                UIStoryboard *myActivitiesInfo = [UIStoryboard storyboardWithName:@"ShowUserInfo"bundle:nil];
                MyActivitiesInfoViewController *myActivitiesInfoViewController = [myActivitiesInfo instantiateViewControllerWithIdentifier:@"ActivitiesInfo"];
                myActivitiesInfoViewController.title = @"我的活动";
                
                self.hidesBottomBarWhenPushed = YES;
                UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:nil action:"showBar"];
                
                [self.navigationItem setBackBarButtonItem:backItem];
                [self.navigationController pushViewController:myActivitiesInfoViewController animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }else if (indexPath.row == 1){
                UIStoryboard *myRelease = [UIStoryboard storyboardWithName:@"ShowUserInfo"bundle:nil];
                MyReleaseInforViewController *myReleaseInforViewController = [myRelease instantiateViewControllerWithIdentifier:@"MyReleaseInfo"];
                myReleaseInforViewController.title = @"我的发布";
                
                self.hidesBottomBarWhenPushed = YES;
                UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:nil action:"showBar"];
                
                [self.navigationItem setBackBarButtonItem:backItem];
                [self.navigationController pushViewController:myReleaseInforViewController animated:YES];
                self.hidesBottomBarWhenPushed = NO;
            }else{
                UIStoryboard *myCollection = [UIStoryboard storyboardWithName:@"ShowUserInfo"bundle:nil];
                MyCollectInfoViewController *myCollectInfoViewController = [myCollection instantiateViewControllerWithIdentifier:@"MyCollectInfo"];
                myCollectInfoViewController.title = @"我的收藏";
                
                self.hidesBottomBarWhenPushed = YES;
                UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:nil action:"showBar"];
                
                [self.navigationItem setBackBarButtonItem:backItem];
                [self.navigationController pushViewController:myCollectInfoViewController animated:YES];
                self.hidesBottomBarWhenPushed = NO;

            }
            
        }
            break;
            
        case 2:
            if (indexPath.row == 0) {
                UIStoryboard *aboutUs = [UIStoryboard storyboardWithName:@"ShowUserInfo"bundle:nil];
                
                AboutUsInfoViewController *aboutUsInfoViewController = [aboutUs instantiateViewControllerWithIdentifier:@"AboutUsViewController"];
                aboutUsInfoViewController.title = @"关于我们";
                
                self.hidesBottomBarWhenPushed = YES;
                UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:nil action:"showBar"];
                
                [self.navigationItem setBackBarButtonItem:backItem];
                [self.navigationController pushViewController:aboutUsInfoViewController animated:YES];
                self.hidesBottomBarWhenPushed = NO;

            }else{
                UIStoryboard *feedBack = [UIStoryboard storyboardWithName:@"ShowUserInfo"bundle:nil];
                
                FeedbackViewController *feedbackViewController = [feedBack instantiateViewControllerWithIdentifier:@"Feedback"];
                feedbackViewController.view.backgroundColor = [UIColor whiteColor];
                feedbackViewController.title = @"关于我们";

                
                self.hidesBottomBarWhenPushed = YES;
                UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:nil action:"showBar"];
                
                [self.navigationItem setBackBarButtonItem:backItem];
                [self.navigationController pushViewController:feedbackViewController animated:YES];
                self.hidesBottomBarWhenPushed = NO;
                
            }
            break;
        default:
            NSLog(@"erro");
            break;
    }
    self.tabBarController.tabBar.hidden = YES;

    
}

- (void)showBar{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你点击了导航栏右按钮" delegate:self  cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alter show];
    NSLog(@"click tabBarItem");
}
//设置按钮点击事件
- (IBAction)settingBtn:(id)sender {
    
    //找到故事板
    UIStoryboard *setting = [UIStoryboard storyboardWithName:@"ShowUserInfo"bundle:nil];
    //从故事板实例化视图控制器
    SettingViewController *settingViewController = [setting instantiateViewControllerWithIdentifier:@"SettingStoryboard"];
    settingViewController.title = @"设置";
    //跳转视图
 
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:nil action:"showBar"];
//        
//            [self.navigationItem setBackBarButtonItem:backItem];
//            [self.navigationController pushViewController:settingViewController animated:YES];
//
//    });
    
    self.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStylePlain target:nil action:"showBar"];
    
    [self.navigationItem setBackBarButtonItem:backItem];
    [self.navigationController pushViewController:settingViewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

   
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }else{
         return 2;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSInteger section = [indexPath section];
    
    if (section == 0) {
        static NSString *cellIndentifier = @"UserInfoCell";//这里的cellID就是cell的xib对应的名称

        UserInfoCell *cell = (UserInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];

        if(nil == cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIndentifier owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        self.tableView.rowHeight = cell.frame.size.height;//注意，这里我们要把table的rowHeight设为和cell的高度一样

        cell.userImage.image = [UIImage imageNamed:@"1.png"];
        cell.userName.text = @"Username";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        return cell;
        
    }else if (section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
        NSInteger *row = [indexPath row];
        if (row == 0) {
            cell.textLabel.text = @"my activity";
        }else if (row == 1){
            cell.textLabel.text = @"my release";
        }else{
            cell.textLabel.text = @"my love";
        }
        cell.imageView.image = [UIImage imageNamed:@"Chile.png"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        self.tableView.rowHeight = 44;

        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
        NSInteger *row = [indexPath row];
        if (row == 0) {
            cell.textLabel.text = @"about us";
        }else {
            cell.textLabel.text = @"feedback";
        }
        self.tableView.rowHeight = 44;
        cell.imageView.image = [UIImage imageNamed:@"Argentina.png"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }

    

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
