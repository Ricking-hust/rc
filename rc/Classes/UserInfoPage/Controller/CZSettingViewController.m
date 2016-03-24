//
//  CZSettingViewController.m
//  rc
//
//  Created by AlanZhang on 16/2/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZSettingViewController.h"
#import "RCNewsNoteViewController.h"
#import "Masonry.h"

@implementation CZSettingViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    self.tableView.scrollEnabled = NO;
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardViewController)];
    
    [self.navigationItem setLeftBarButtonItem:leftButton];
    self.tableView.separatorInset = UIEdgeInsetsMake(10, 10, 10, 10);
}
//1.获取缓存文件路径
- (NSString *)getCachesPath{
    // 获取Caches目录路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask,YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    //NSString *filePath = [cachesDir stringByAppendingPathComponent:@"myCache"];
    return cachesDir;
}
//2.计算单个文件的大小
- (long long)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath])
    {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//3.遍历文件夹获得文件夹大小，返回多少M
- (CGFloat)getCacheSizeAtPath:(NSString*)folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];//从前向后枚举器
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        //NSLog(@"fileName ==== %@",fileName);
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        //NSLog(@"fileAbsolutePath ==== %@",fileAbsolutePath);
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    //NSLog(@"folderSize ==== %lld",folderSize);
    return folderSize/(1024.0*1024.0);
}
//4清理缓存
- (void)clearCacheAtPath:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path])
    {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles)
        {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}

- (void)backToForwardViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    }else
    {
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, 1)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];

    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"新消息通知";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else
        {
            cell.textLabel.text = @"清除缓存";
            UILabel *sizeLabel = [[UILabel alloc]init];
            sizeLabel.font = [UIFont systemFontOfSize:14];
            CGFloat size = [self getCacheSizeAtPath:[self getCachesPath]];;
            NSString *str = [NSString stringWithFormat:@"%0.2fM",size];
            sizeLabel.text = str;
            cell.accessoryView = sizeLabel;
            cell.accessoryView.alpha = 0.8;
            [cell addSubview:sizeLabel];
            CGSize bufferLabelSize = [self sizeWithText:str maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:14];
            [cell.accessoryView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(bufferLabelSize.width + 1);
                make.height.mas_equalTo(bufferLabelSize.height + 1);
                make.right.equalTo(cell.mas_right).offset(-10);
                make.centerY.equalTo(cell.mas_centerY);
            }];
            
        }
        
    }else
    {
        cell.textLabel.text = @"退出登陆";
        [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell);
        }];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.alpha = 0.8;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [[DataManager manager] UserLogout];
    }
    if (indexPath.section == 0 &&indexPath.row == 0)
    {//设置新消息通知
        [self newsNote];
//        [self addLocalNote];
    }else
    {
        CGFloat size = [self getCacheSizeAtPath:[self getCachesPath]];;
        NSString *str = [NSString stringWithFormat:@"确定清除%0.2fM缓存数据吗?",size];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"清除缓存"
                                                                       message:str
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self clearCacheAtPath:[self getCachesPath]];
            [tableView reloadData];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)newsNote
{
    RCNewsNoteViewController *newsVC = [[RCNewsNoteViewController alloc]init];
    newsVC.title = @"消息通知";
    
    [self.navigationController pushViewController:newsVC animated:YES];
}
- (void)addLocalNote
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:5];
    
    /*
     
     NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
     
     [formatter setDateFormat:@"HH:mm:ss"];
     
     NSDate *now = [formatter dateFromString:@"15:00:00"];//触发通知的时间
     
     */
    
    //chuagjian
    
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    
    if (noti)
    {
        //设置推送时间
        noti.fireDate = date;//=now
        
        //设置时区
        noti.timeZone = [NSTimeZone defaultTimeZone];
        
        //设置重复间隔
        noti.repeatInterval = NSWeekCalendarUnit;
        
        //推送声音
        noti.soundName = UILocalNotificationDefaultSoundName;
        
        //内容
        noti.alertBody = @"推送内容";
        
        //显示在icon上的红色圈中的数子
        noti.applicationIconBadgeNumber = 1;
        
        //设置userinfo 方便在之后需要撤销的时候使用
        NSDictionary *infoDic = [NSDictionary dictionaryWithObject:@"name" forKey:@"key"];
        noti.userInfo = infoDic;
        //添加推送到uiapplication
        UIApplication *app = [UIApplication sharedApplication];
        [app scheduleLocalNotification:noti];
        
    }
}
/**
 *  计算文本的大小
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
