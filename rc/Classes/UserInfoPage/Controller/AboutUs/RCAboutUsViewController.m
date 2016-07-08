//
//  CZAboutUsViewController.m
//  rc
//
//  Created by AlanZhang on 16/2/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCAboutUsViewController.h"
#import "Masonry.h"

@interface RCAboutUsViewController()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *appIcon;
@property (nonatomic, strong) UILabel *appVersion;
@property (nonatomic, strong) NSArray *teamMember;
@end
@implementation RCAboutUsViewController
- (NSArray *)teamMember
{
    if (!_teamMember)
    {
        _teamMember = [[NSArray alloc]initWithObjects:@"日常1.0",@"生活不只有眼前的苟且", @"白日旧梦", @"但行好事，莫问前程", @"不因为害怕而不去拥有", @"天道酬勤", @"很高兴遇见你", @"随心而动", @"越努力，越幸运",nil];
    }
    return _teamMember;
}
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
    return 2;
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
            [self introduceApp];
        }
            break;
        case (1):{
            [self didSelectWeChat];
        }
            break;
        case (2):{
            NSString *versionURL = @"";
            UIAlertController *versionAlert = [UIAlertController alertControllerWithTitle:@"最新版本号" message:@"1.02" preferredStyle:UIAlertControllerStyleAlert];
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
#pragma mark - 产品介绍
- (void)introduceApp
{
    UIAlertController *chooseView = [UIAlertController alertControllerWithTitle:@"提示" message:@"我们正在来的路上哟。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [chooseView addAction:cancelAction];
    
    [self presentViewController:chooseView animated:YES completion:nil];
}
#pragma mark - 微信平台
- (void)didSelectWeChat
{
    UIAlertController *chooseView = [UIAlertController alertControllerWithTitle:@"提示" message:@"我们将会很快推出哟，敬请期待。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [chooseView addAction:cancelAction];
    
    [self presentViewController:chooseView animated:YES completion:nil];

}
- (void)createHeaderView
{
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    self.appIcon    = [[UIImageView alloc]init];
    self.appVersion  = [[UILabel alloc]init];
    self.appVersion.font = [UIFont systemFontOfSize:15];
    self.appIcon.image = [UIImage imageNamed:@"logo"];
    self.appIcon.userInteractionEnabled = YES;
    self.headerView.backgroundColor = [UIColor clearColor];
    [self.headerView addSubview:self.appVersion];
    [self.headerView addSubview:self.appIcon];
    
    self.appVersion.text = @"日常1.0";
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showTeamMembers)];
    [self.appIcon addGestureRecognizer:gesture];
    self.appIcon.layer.cornerRadius = 35;
    [self.appIcon mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headerView);
        make.centerY.equalTo(self.headerView).offset(-5);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(70);
    }];
    CGSize appVersionSize = [self sizeWithText:self.appVersion.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:15];
    [self.appVersion mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.appIcon);
        make.top.equalTo(self.appIcon.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(appVersionSize.width+1, appVersionSize.height+1));
    }];
    
}
- (void)showTeamMembers
{
    int x = [self getRandomNumber:1 to:9];
    NSString *strImg = [NSString stringWithFormat:@"member_%d",x];
    self.appIcon.image = [UIImage imageNamed:strImg];
    self.appVersion.text = self.teamMember[x-1];
    CGSize appVersionSize = [self sizeWithText:self.appVersion.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:15];
    [self.appVersion mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(appVersionSize.width+1, appVersionSize.height+1));
    }];
}
//获取一个随机整数，范围在[from,to]
-(int)getRandomNumber:(int)from to:(int)to

{
    
    return (int)(from + (arc4random() % (to - from + 1)));
    
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
