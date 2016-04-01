//
//  RCSettingTagTableViewController.m
//  rc
//
//  Created by AlanZhang on 16/3/17.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCSettingTagTableViewController.h"
#import "Masonry.h"
#import "RCTagCell.h"
#import "MBProgressHUD.h"
#include <sys/sysctl.h>
#define buttonSize CGSizeMake(65, 30)
#define IPHONE5PADDING  12
#define IPHONE6PADDING  23
#define IPHONE6PLUSPADDING  30.8

@interface RCSettingTagTableViewController ()
@property (nonatomic, assign) CurrentDevice device;
@property (nonatomic, assign) BOOL isShake;
@property (nonatomic, strong) NSMutableArray *myButton;
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSMutableArray *myTags;
@property (nonatomic, strong) MBProgressHUD    *HUD;
@property (nonatomic,strong) TagsList *allTag;
@property (nonatomic,strong) TagsList *myTag;
@property (nonatomic,copy) NSURLSessionDataTask *(^getAllTagBlock)();
@property (nonatomic,copy) NSURLSessionDataTask *(^getmyTagBlock)();

@end

@implementation RCSettingTagTableViewController
- (CurrentDevice)device
{
    if (!_device)
    {
        _device = [self currentDeviceSize];
    }
    return _device;
}
- (NSMutableArray *)myButton
{
    if (!_myButton)
    {
        _myButton = [[NSMutableArray alloc]init];
    }
    return _myButton;
}

- (NSMutableArray *)tags
{
    if (!_tags) {
        _tags = [[NSMutableArray alloc]init];
    }
    
    return _tags;
}

- (NSMutableArray *)myTags
{
    if (!_myTags) {
        _myTags = [[NSMutableArray alloc]init];
    }
    
    return _myTags;
}
#pragma mark - get data
-(void)configureBlocks{
    @weakify(self)
    self.getAllTagBlock = ^(){
        @strongify(self);
        return [[DataManager manager] getAllTagsSuccess:^(TagsList *tagList) {
            @strongify(self);
            self.allTag = tagList;
        } failure:^(NSError *error) {
            NSLog(@"Error:%@",error);
        }];
    };
    
    self.getmyTagBlock = ^(){
        @strongify(self);
        NSString *userId = [[NSString alloc]init];
        if ([userDefaults objectForKey:@"userId"]) {
            userId = [userDefaults objectForKey:@"userId"];
        } else {
            userId = @"-1";
        }
        return [[DataManager manager] getUsrTagsWithUserId:userId success:^(TagsList *tagsList) {
            @strongify(self);
            self.myTag = tagsList;
        } failure:^(NSError *error) {
            NSLog(@"Error:%@",error);
        }];
    };
}

- (void)startget{
    if (self.getAllTagBlock) {
        self.getAllTagBlock();
    }
    
    if (self.getmyTagBlock) {
        self.getmyTagBlock();
    }
}

-(void)setAllTag:(TagsList *)allTag{
    _allTag = allTag;
    
    [self.tags addObjectsFromArray:self.allTag.list];
    
    [self.tableView reloadData];
}

-(void)setMyTag:(TagsList *)myTag{
    _myTag = myTag;
    
    [self.myTags addObjectsFromArray:self.myTag.list];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self startget];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.isShake = NO;
    [self configureBlocks];
    //self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    [self setNavigation];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setNavigation
{
    self.navigationItem.title = @"标签选择";
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardVC)];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(backToForwardVC)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    UIBarButtonItem *rightButtont = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(updateMyTag)];
    [self.navigationItem setRightBarButtonItem:rightButtont];}
- (void)backToForwardVC
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 标签选择确定按钮
- (void)updateMyTag
{
    self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.HUD.removeFromSuperViewOnHide = YES;
    [self.view addSubview:self.HUD];
    [self.HUD showAnimated:YES];
    NSMutableArray *updateArray = [[NSMutableArray alloc]init];
    for (TagModel *model in self.myTags) {
        [updateArray addObject:model.tagId];
    }
    NSString *str = [updateArray componentsJoinedByString:@","];
    NSMutableString *mstr = [[NSMutableString alloc]initWithString:str];
    [mstr insertString:@"[" atIndex:0];
    [mstr appendString:@"]"];
    [[DataManager manager] setTagsWithUserId:[userDefaults objectForKey:@"userId"] tagsList:mstr success:^(NSString *msg) {
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.label.text = @"标签修改成功";
        [self.HUD hideAnimated:YES afterDelay:0.6];

    } failure:^(NSError *error) {
        self.HUD.mode = MBProgressHUDModeCustomView;
        self.HUD.label.text = @"设置失败";
        [self.HUD hideAnimated:YES afterDelay:0.6];
        NSLog(@"Error:%@",error);
    }];
    if (self.isShake)
    {
        [self pause];
        self.isShake = NO;
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        UILabel *myLabel = [[UILabel alloc]init];
        myLabel.text = @"我的标签";
        myLabel.font = [UIFont systemFontOfSize:12];
        myLabel.alpha = 0.6;
        [view addSubview:myLabel];
        [myLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(view.mas_left).offset(10);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(17);
        }];
        return view;
    }else
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        UILabel *myLabel = [[UILabel alloc]init];
        myLabel.text = @"点击添加标签";
        myLabel.font = [UIFont systemFontOfSize:12];
        myLabel.alpha = 0.6;
        [view addSubview:myLabel];
        [myLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(view.mas_left).offset(10);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(17);
        }];
        return view;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RCTagCell *cell = [[RCTagCell alloc]init];
    cell.tag = indexPath.section;
    if (indexPath.section == 0)
    {
        [self addButton:self.myTags ToCell:cell];
        
    }else
    {
        [self addButton:self.tags ToCell:cell];
    }
    if (self.isShake == YES)
    {
        [self shakeImage:self.myButton];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return [self heightForRow:self.myTags];
    }else
    {
        return [self heightForRow:self.tags];
    }
}
- (void)addButton:(NSArray *)array ToCell:(RCTagCell *)cell
{
    int x = 0;
    int y = 0;
    CGFloat XPading = 0;
    CGFloat YPadding = 12;
    CGFloat padding;
    if (self.device == IPhone5)
    {
        padding = IPHONE5PADDING;
    }else if (self.device == IPhone6)
    {
        padding = IPHONE6PADDING;
    }else
    {
        padding = IPHONE6PLUSPADDING;
    }
    for (int i = 0; i < array.count; i++)
    {
        UIButton *btn = [[UIButton alloc]init];
        [cell.contentView addSubview:btn];
        btn.tag = 10 + i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        TagModel *model = array[i];
        [self setButton:btn WithTittle:model.tagName AtCell:cell];
        if (cell.tag == 0)
        {
            [self.myButton addObject:btn];
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(buttonLongPress:)];
            [btn addGestureRecognizer:longPress];
        }
        if ((i) % 4 == 0 && i != 0 )
        {
            x = 0;
            YPadding = 12 * (y + 2) + (y+1) * 30;
            y++;
        }
        XPading = padding * (x + 1) + x * 65;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).with.offset(XPading);
            make.top.equalTo(cell.contentView.mas_top).with.offset(YPadding);
            make.size.mas_equalTo(buttonSize);
        }];
        x++;
    }
}
- (void)buttonLongPress:(UILongPressGestureRecognizer *)longPress
{
    [self shakeImage:self.myButton];
    self.isShake = YES;
}
- (void)click:(UIButton *)button
{
    UIView *view = [button superview];
    RCTagCell *cell = (RCTagCell *)view.superview;
    if (cell.tag == 0)
    {
        if (self.isShake == YES)
        {
            for (int i = 0; i<self.myTags.count; i++) {
                TagModel *model = self.myTags[i];
                if ([model.tagName isEqualToString:button.titleLabel.text]) {
                    [self.myTags removeObject:model];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
        }
    }else
    {
        BOOL isAdd = NO;
        for (TagModel *model in self.myTags) {
            if ([model.tagName isEqualToString:button.titleLabel.text]) {
                isAdd = YES;
                break;
            }
        }
        if (isAdd == NO)
        {
            for (int i = 0; i<self.tags.count; i++) {
                TagModel *model = self.tags[i];
                if ([model.tagName isEqualToString:button.titleLabel.text]) {
                    [self.myTags addObject:model];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }
        }

    }
}

- (void)pause
{
    for (int i = 0; i <self.myButton.count; i++) {
        UIButton *button = self.myButton[i];
        button.layer.speed = 0.0;
    }
}

- (void)resume
{
    for (int i = 0; i <self.myButton.count; i++) {
        UIButton *button = self.myButton[i];
        button.layer.speed = 1.0;
    }
}
- (void)shakeImage:(NSMutableArray *)button
{
    //创建动画对象,绕Z轴旋转
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //设置属性，周期时长
    [animation setDuration:0.08];
    
    //抖动角度
    animation.fromValue = @(-M_1_PI/2);
    animation.toValue = @(M_1_PI/2);
    //重复次数，无限大
    animation.repeatCount = HUGE_VAL;
    //恢复原样
    animation.autoreverses = YES;
    //锚点设置为图片中心，绕中心抖动
    for (int i = 0; i <self.myButton.count; i++) {
        UIButton *button = self.myButton[i];
        button.layer.anchorPoint = CGPointMake(0.5, 0.5);
        
        [button.layer addAnimation:animation forKey:@"rotation"];
    }

}
- (void)setButton:(UIButton *)button WithTittle:(NSString *)tittle AtCell:(RCTagCell *)cell
{
    if (cell.tag == 0)
    {

        [button setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }else
    {
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setTitleColor:[UIColor colorWithRed:38.0/255.0 green:40.0/255.0 blue:50.0/255.0 alpha:0.6] forState:UIControlStateNormal];
        [button.layer setBorderWidth:0.5];    //设置边界的宽度
        //设置按钮的边界颜色
        CGColorRef color =[UIColor colorWithRed:38.0/255.0 green:40.0/255.0 blue:50.0/255.0 alpha:0.4].CGColor;
        [button.layer setBorderColor:color];
    }

    [button setTitle:tittle forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [button.layer setCornerRadius:3];   //设置圆角
}
- (CGFloat)heightForRow:(NSArray *)array
{
    CGFloat row = array.count / 4.0;
    int height = (int)row;
    if (height == row)
    {
        return (height + 1) * 12 + height * 30;
    }else
    {
        height ++ ;
        return (height + 1) * 12 + height * 30;
    }

}
//获得设备型号
- (NSString *)getCurrentDeviceModel
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}
//获取当前设备
- (CurrentDevice)currentDeviceSize
{
    if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 4"] ||
        [[self getCurrentDeviceModel] isEqualToString:@"iPhone 5"])
    {
        return IPhone5;
        
    }else if ([[self getCurrentDeviceModel] isEqualToString:@"iPhone 6"] ||
              [[self getCurrentDeviceModel] isEqualToString:@"iPhone Simulator"])
    {
        return IPhone6;
    }else
    {
        return Iphone6Plus;
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
