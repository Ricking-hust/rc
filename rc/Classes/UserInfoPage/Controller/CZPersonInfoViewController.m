//
//  CZPersonInfoViewController.m
//  rc
//
//  Created by AlanZhang on 16/2/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZPersonInfoViewController.h"
#import "CZPersonInfoCell.h"
#import "Masonry.h"
#import "RegisteViewController.h"
#import "LoginViewController.h"
#import "MBProgressHUD.h"

@interface CZPersonInfoViewController()

@property (nonatomic, strong) MBProgressHUD    *HUD;

@end

@implementation CZPersonInfoViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.navigationItem.title = @"个人资料";
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
}

- (void)backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 5;
    }else
    {
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 11)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    CZPersonInfoCell *cell = [CZPersonInfoCell personInfoCellWithTableView:tableView];
    [self setCell:cell WithIndexPath:indexPath];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark - 单元格的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self didSelectCellAtIndexPath:indexPath];

    //[self.tableView reloadData];
    [self.view layoutIfNeeded];
}

- (void)didSelectCellAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                [self chooseImage];
            } else if (indexPath.row == 1){
                [self showNameEditAlertViewWitText:[userDefaults objectForKey:@"userName"]];
            } else if (indexPath.row == 2){
                [self showSexEditAlertView];
            } else if (indexPath.row == 4){
                [self showMailEditAlertViewWithText:[userDefaults objectForKey:@"userMail"]];
            }
        }
            break;
        case 1:
        {
            [self showSignEditAlertViewWithText:[userDefaults objectForKey:@"userSign"]];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 单元格赋值

- (void)setCell:(CZPersonInfoCell *)cell WithIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0)
            {
                cell.tittle.text = @"头像";
                [cell.personIcon sd_setImageWithURL:[userDefaults objectForKey:@"userPic"] placeholderImage:[UIImage imageNamed:@"about_icon"]];
            }else if (indexPath.row == 1)
            {
                cell.tittle.text = @"昵称";
                cell.contentLabel.text = [userDefaults objectForKey:@"userName"];
            }else if (indexPath.row == 2)
            {
                cell.tittle.text = @"性别";
                if ([[userDefaults objectForKey:@"userSex"] isEqualToString:@"1"]) {
                    cell.contentLabel.text = @"男";
                } else {
                    cell.contentLabel.text = @"女";
                }
            }else if (indexPath.row == 3)
            {
                cell.tittle.text = @"手机";
                cell.contentLabel.text = [userDefaults objectForKey:@"userPhone"];
            }else if (indexPath.row == 4)
            {
                cell.tittle.text = @"邮箱";
                cell.contentLabel.text = [userDefaults objectForKey:@"userMail"];
            }
        }
        break;
            
        default:
        {
            cell.tittle.text = @"签名";
            cell.contentLabel.text = [userDefaults objectForKey:@"userSign"];
        }
            break;
    }
    cell.indecatorImageView.image = [UIImage imageNamed:@"nextIcon"];
    cell.contentLabel.alpha = 0.6;
    [self setCellConstraints:cell WithIndexPath:indexPath];
}

- (void)setCellConstraints:(CZPersonInfoCell *)cell WithIndexPath:(NSIndexPath *)indexPath
{
    CGSize tittleSize = [self sizeWithText:cell.tittle.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:14];
    [cell.tittle mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).with.offset(10);
        make.centerY.equalTo(cell.contentView);
        make.size.mas_equalTo(CGSizeMake(tittleSize.width+1, tittleSize.height+1));
    }];
    [cell.indecatorImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.right.equalTo(cell.contentView.mas_right).with.offset(-10);
        make.size.mas_equalTo(cell.indecatorImageView.image.size);
    }];

    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row == 0)
            {
                [cell.personIcon mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.contentView);
                    make.right.equalTo(cell.indecatorImageView.mas_left).with.offset(-5);
                    make.size.mas_equalTo(CGSizeMake(30, 30));
                }];
            }else
            {
                CGSize contentLabelSize = [self sizeWithText:cell.contentLabel.text maxSize:CGSizeMake(200, 20) fontSize:14];
                [cell.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.contentView);
                    make.right.equalTo(cell.indecatorImageView.mas_left).with.offset(-5);
                    make.size.mas_equalTo(CGSizeMake(contentLabelSize.width+1, contentLabelSize.height+1));
                }];
            }
            if (indexPath.row == 3)
            {
                cell.indecatorImageView.image = [UIImage imageNamed:@""];
            }
        }
            break;
            
        default:
        {
            CGSize contentLabelSize = [self sizeWithText:cell.contentLabel.text maxSize:CGSizeMake(200, 20) fontSize:14];
            [cell.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(cell.contentView);
                make.right.equalTo(cell.indecatorImageView.mas_left).with.offset(-5);
                make.size.mas_equalTo(CGSizeMake(contentLabelSize.width+1, contentLabelSize.height+1));
            }];
        }
        break;
    }
}

#pragma mark - private methods

/**
 *  计算字体的长和宽
 *
 *  @param text 待计算大小的字符串
 *
 *  @param fontSize 指定绘制字符串所用的字体大小
 *
 *  @return 字符串的大小
 */
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
}

-(void)editPicWithPicUrl:(NSString *)picurl{
    @weakify(self);
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.view addSubview:self.HUD];
    [self.HUD showAnimated:YES];
    [[DataManager manager] modifyAccountWithUserId:[userDefaults objectForKey:@"userId"] opType:@"2" userPwdO:@"" userPwdN:@"" username:[userDefaults objectForKey:@"userName"] userSign:[userDefaults objectForKey:@"userSign"] userPic:picurl userSex:[userDefaults objectForKey:@"userSex"] userMail:[userDefaults objectForKey:@"userMail"] cityId:[userDefaults objectForKey:@"cityId"] success:^(NSString *msg) {
        @strongify(self)
        
        [userDefaults setObject:picurl forKey:@"userPic"];
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.label.text = @"修改成功";
        [self.HUD hideAnimated:YES afterDelay:0.6];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        @strongify(self);
        
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.label.text = @"修改失败";
        [self.HUD hideAnimated:YES afterDelay:0.6];
        
    }];

}

-(void)showNameEditAlertViewWitText:(NSString *)text{
    @weakify(self)
    
    UIAlertController *editControl = [UIAlertController alertControllerWithTitle:@"请输入昵称" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [editControl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = text;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *configureAction = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        @strongify(self);
        
        UITextField *textField = editControl.textFields[0];
        
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        self.HUD.removeFromSuperViewOnHide = YES;
        [self.view addSubview:self.HUD];
        [self.HUD showAnimated:YES];
        
        [[DataManager manager] modifyAccountWithUserId:[userDefaults objectForKey:@"userId"] opType:@"2" userPwdO:@"" userPwdN:@"" username:textField.text userSign:[userDefaults objectForKey:@"userSign"] userPic:[userDefaults objectForKey:@"userPic"] userSex:@"" userMail:[userDefaults objectForKey:@"userMail"] cityId:[userDefaults objectForKey:@"cityId"] success:^(NSString *msg) {
            @strongify(self);
            
            [userDefaults setObject:textField.text forKey:@"userName"];
            self.HUD.mode = MBProgressHUDModeCustomView;
            self.HUD.label.text = @"修改成功";
            [self.HUD hideAnimated:YES afterDelay:0.6];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            @strongify(self);
            self.HUD.mode = MBProgressHUDModeCustomView;
            self.HUD.label.text = @"修改失败";
            [self.HUD hideAnimated:YES afterDelay:0.6];
        }];
    }];
    
    [editControl addAction:cancelAction];
    [editControl addAction:configureAction];
    
    [self presentViewController:editControl animated:YES completion:nil];
}

-(void)showSexEditAlertView{
    @weakify(self)
    
    UIAlertController *editControl = [UIAlertController alertControllerWithTitle:@"请选择性别" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *maleAction = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        @strongify(self);
        
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        self.HUD.removeFromSuperViewOnHide = YES;
        [self.view addSubview:self.HUD];
        [self.HUD showAnimated:YES];
        
        [[DataManager manager] modifyAccountWithUserId:[userDefaults objectForKey:@"userId"] opType:@"2" userPwdO:@"" userPwdN:@"" username:[userDefaults objectForKey:@"userName"] userSign:[userDefaults objectForKey:@"userSign"] userPic:[userDefaults objectForKey:@"userPic"] userSex:@"1" userMail:[userDefaults objectForKey:@"userMail"] cityId:[userDefaults objectForKey:@"cityId"] success:^(NSString *msg) {
            @strongify(self)
            
            [userDefaults setObject:@"1" forKey:@"userSex"];
            self.HUD.mode = MBProgressHUDModeCustomView;
            self.HUD.label.text = @"修改成功";
            [self.HUD hideAnimated:YES afterDelay:0.6];
            [self.tableView reloadData];
            
        } failure:^(NSError *error) {
            @strongify(self);
            self.HUD.mode = MBProgressHUDModeCustomView;
            self.HUD.label.text = @"修改失败";
            [self.HUD hideAnimated:YES afterDelay:0.6];
        }];
    }];
    UIAlertAction *femaleAction = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        @strongify(self);
        
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        self.HUD.removeFromSuperViewOnHide = YES;
        [self.view addSubview:self.HUD];
        [self.HUD showAnimated:YES];
        
        [[DataManager manager] modifyAccountWithUserId:[userDefaults objectForKey:@"userId"] opType:@"2" userPwdO:@"" userPwdN:@"" username:[userDefaults objectForKey:@"userName"] userSign:[userDefaults objectForKey:@"userSign"] userPic:[userDefaults objectForKey:@"userPic"] userSex:@"2" userMail:[userDefaults objectForKey:@"userMail"] cityId:[userDefaults objectForKey:@"cityId"] success:^(NSString *msg) {
            @strongify(self)
            
            [userDefaults setObject:@"2" forKey:@"userSex"];
            self.HUD.mode = MBProgressHUDModeCustomView;
            self.HUD.label.text = @"修改成功";
            [self.HUD hideAnimated:YES afterDelay:0.6];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            @strongify(self);
            
            self.HUD.mode = MBProgressHUDModeCustomView;
            self.HUD.label.text = @"修改失败";
            [self.HUD hideAnimated:YES afterDelay:0.6];

        }];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [editControl addAction:maleAction];
    [editControl addAction:femaleAction];
    [editControl addAction:cancelAction];
    
    [self presentViewController:editControl animated:YES completion:nil];
}

-(void)showMailEditAlertViewWithText:(NSString *)text{
    @weakify(self)
    
    UIAlertController *editControl = [UIAlertController alertControllerWithTitle:@"请输入新邮箱" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [editControl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = text;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *configureController = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        @strongify(self);
        
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        self.HUD.removeFromSuperViewOnHide = YES;
        [self.view addSubview:self.HUD];
        [self.HUD showAnimated:YES];
        UITextField *textField = editControl.textFields[0];
        [[DataManager manager] modifyAccountWithUserId:[userDefaults objectForKey:@"userId"] opType:@"2" userPwdO:@"" userPwdN:@"" username:[userDefaults objectForKey:@"userName"] userSign:[userDefaults objectForKey:@"userSign"] userPic:[userDefaults objectForKey:@"userPic"] userSex:[userDefaults objectForKey:@"userSex"] userMail:textField.text cityId:[userDefaults objectForKey:@"cityId"] success:^(NSString *msg) {
            @strongify(self)
            
            [userDefaults setObject:textField.text forKey:@"userMail"];
            self.HUD.mode = MBProgressHUDModeCustomView;
            self.HUD.label.text = @"修改成功";
            [self.HUD hideAnimated:YES afterDelay:0.6];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            @strongify(self);
            
            self.HUD.mode = MBProgressHUDModeCustomView;
            self.HUD.label.text = @"修改失败";
            [self.HUD hideAnimated:YES afterDelay:0.6];

        }];
    }];
    
    [editControl addAction:cancelAction];
    [editControl addAction:configureController];
    
    [self presentViewController:editControl animated:YES completion:nil];
}

-(void)showSignEditAlertViewWithText:(NSString *)text{
    @weakify(self)
    
    UIAlertController *editControl = [UIAlertController alertControllerWithTitle:@"输入新的个性签名" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [editControl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = text;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *configureController = [UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        @strongify(self);
        
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        self.HUD.removeFromSuperViewOnHide = YES;
        [self.view addSubview:self.HUD];
        [self.HUD showAnimated:YES];
        UITextField *textField = editControl.textFields[0];
        [[DataManager manager] modifyAccountWithUserId:[userDefaults objectForKey:@"userId"] opType:@"2" userPwdO:@"" userPwdN:@"" username:[userDefaults objectForKey:@"userName"] userSign:textField.text userPic:[userDefaults objectForKey:@"userPic"] userSex:[userDefaults objectForKey:@"userSex"] userMail:[userDefaults objectForKey:@"userMail"] cityId:[userDefaults objectForKey:@"cityId"] success:^(NSString *msg) {
            @strongify(self)
            
            [userDefaults setObject:textField.text forKey:@"userSign"];
            self.HUD.mode = MBProgressHUDModeCustomView;
            self.HUD.label.text = @"修改成功";
            [self.HUD hideAnimated:YES afterDelay:0.6];
            [self.tableView reloadData];
        } failure:^(NSError *error) {
            @strongify(self);
            
            self.HUD.mode = MBProgressHUDModeCustomView;
            self.HUD.label.text = @"修改失败";
            [self.HUD hideAnimated:YES afterDelay:0.6];

        }];
    }];
    
    [editControl addAction:cancelAction];
    [editControl addAction:configureController];
    
    [self presentViewController:editControl animated:YES completion:nil];
}

-(void)chooseImage {
    UIAlertController *chooseControl = [UIAlertController alertControllerWithTitle:@"选择" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *librayAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {        
    }];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
            
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            
            [self presentViewController:imagePickerController animated:YES completion:^{
            }];
        }];
        
        [chooseControl addAction:cameraAction];
    }
    [chooseControl addAction:librayAction];
    [chooseControl addAction:cancelAction];
    
    [self presentViewController:chooseControl animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [[DataManager manager]uploadImgWithImage:image fileName:[NSString stringWithFormat:@"test"] success:^(id responseObject) {
        NSString *msg= [responseObject objectForKey:@"msg"];
        [self editPicWithPicUrl:msg];
    } fail:^(NSError *error) {
        NSLog(@"Error:%@",error);
    }];
}

@end
