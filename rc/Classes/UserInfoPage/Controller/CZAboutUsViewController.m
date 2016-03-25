//
//  CZAboutUsViewController.m
//  rc
//
//  Created by AlanZhang on 16/2/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZAboutUsViewController.h"
#import "Masonry.h"

@interface CZAboutUsViewController()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *appIcon;
@property (nonatomic, strong) UILabel *appVersion;
@end
@implementation CZAboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"关于我们";
    self.tableView.scrollEnabled = NO;
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    [self createHeaderView];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.separatorInset = UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 11)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 2)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"产品介绍";
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"微信平台";
    }else{
        cell.textLabel.text = @"检查最新版本";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            NSLog(@"Please introduce our APP");
        }
            break;
        case (1):{
            NSLog(@"wechat");
        }
            break;
        case (2):{
            NSString *versionURL = @"http://fir.im/cbsg";
            UIAlertController *versionAlert = [UIAlertController alertControllerWithTitle:@"最新版本号" message:@"1.0" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *configureAlert = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionURL]];
            }];
            [versionAlert addAction:cancleAction];
            [versionAlert addAction:configureAlert];
            
            [self presentViewController:versionAlert animated:YES completion:nil];
        }
        default:
            break;
    }
}

- (void)createHeaderView
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.width * 0.4)];
    self.appIcon    = [[UIImageView alloc]init];
    self.appVersion  = [[UILabel alloc]init];
    self.appVersion.font = [UIFont systemFontOfSize:14];
    self.appIcon.image = [UIImage imageNamed:@"city_1"];
    self.headerView.backgroundColor = [UIColor clearColor];
    [self.headerView addSubview:self.appVersion];
    [self.headerView addSubview:self.appIcon];
    
    self.appVersion.text = @"日常1.0";
    [self.appIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView);
        make.top.equalTo(self.headerView.mas_top).with.offset(self.headerView.frame.size.height * 0.15);
        make.size.mas_equalTo(self.appIcon.image.size);
    }];
    CGSize appVersionSize = [self sizeWithText:self.appVersion.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:14];
    [self.appVersion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.appIcon);
        make.top.equalTo(self.appIcon.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(appVersionSize.width+1, appVersionSize.height+1));
    }];
    
}
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

@end
