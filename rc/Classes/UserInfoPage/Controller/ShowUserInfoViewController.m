//
//  ShowUserInfoViewController.m
//  日常
//
//  Created by AlanZhang on 15/12/22.
//  Copyright © 2015年 AlanZhang. All rights reserved.
//

#import "ShowUserInfoViewController.h"
#import "UserDetailInfo.h"
#import "CustomCellForUserInfo.h"

@interface ShowUserInfoViewController ()


@end

@implementation ShowUserInfoViewController

- (void)viewWillAppear:(BOOL)animated{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    

    

}
-(void)dosomething{
    [self.navigationController popViewControllerAnimated:YES];
    
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

    if (section == 0) {
        return 5;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    long int section = [indexPath section];
    switch (section) {
        case 0:{
            if (indexPath.row == 0) {
                static NSString *cellIndentifier = @"UserDetailInfo";//这里的cellID就是cell的xib对应的名称
                
                UserDetailInfo *cell = (UserDetailInfo *)[tableView dequeueReusableCellWithIdentifier:cellIndentifier];
                
                if(nil == cell) {
                    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIndentifier owner:self options:nil];
                    cell = [nib objectAtIndex:0];
                }
                cell.userImage.image = [UIImage imageNamed:@"1.png"];
                cell.imageText.text = @"头像";
                cell.imageText.textAlignment = NSTextAlignmentLeft;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                cell.imageText.adjustsFontSizeToFitWidth = YES;
                
                return cell;
            }else{
                CustomCellForUserInfo *cell = [tableView dequeueReusableCellWithIdentifier:@"UserDetailInfoCell" forIndexPath:indexPath];
                switch (indexPath.row) {
                    case 1:{
                        cell.leftLabel.text = @"昵称";
                        cell.rightLabel.text = @"油条";
                    }
                        break;
                    case 2:{
                        cell.leftLabel.text = @"性别";
                        cell.rightLabel.text = @"女";
                    }
                        break;
                    case 3:{
                        cell.leftLabel.text = @"手机";
                        cell.rightLabel.text = @"00000000000";
                    }
                        break;
                    case 4:{
                        cell.leftLabel.text = @"邮箱";
                        cell.rightLabel.text = @"油条@qq.com";
                    }
                        break;
                }
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.leftLabel.textAlignment = NSTextAlignmentLeft;
                cell.rightLabel.textAlignment = NSTextAlignmentRight;
                
                cell.rightLabel.adjustsFontSizeToFitWidth = YES;
                
                return cell;
                
            }

        }
            break;
            
        default:{
            CustomCellForUserInfo *cell = [tableView dequeueReusableCellWithIdentifier:@"UserDetailInfoCell" forIndexPath:indexPath];
            cell.leftLabel.text = @"签名";
            cell.rightLabel.text = @"大饼把油条干死了";
            cell.leftLabel.textAlignment = NSTextAlignmentLeft;
            cell.rightLabel.textAlignment = NSTextAlignmentRight;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.rightLabel.adjustsFontSizeToFitWidth = YES;
            return cell;
        }
            break;
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
