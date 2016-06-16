//
//  RCTableView.m
//  rc
//
//  Created by AlanZhang on 16/3/18.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCTableView.h"
#import "CZScheduleInfoCell.h"
#import "RCScheduleInfoViewController.h"
#import "Masonry.h"
#import "RCScrollView.h"

@interface RCTableView ()
@property (nonatomic, strong) NSNumber *nodeIndex;
@property (nonatomic, strong) UIViewController *vc;
@end
@implementation RCTableView
- (id)init
{
    if (self = [super init])
    {
        self.planListRanged = [[NSMutableArray alloc]init];
        self.scArray = [[NSMutableArray alloc]init];
        self.view = [[UIView alloc]init];
        self.timeNodeSV = [[RCScrollView alloc]init];
        self.nodeIndex = [[NSNumber alloc]initWithInt:0];
        //注册通知，拿到响应链上的view
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSuperView:) name:@"getView" object:nil];
        //注册通知，刷新数据
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refleshData:) name:@"refleshSC" object:nil];
        //注册通知，拿到nodeIndex
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTimeNodeScrollView:) name:@"sendTimeNodeScrollView" object:nil];
        //注册通知，拿到timeNodeSV
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getTimeNodeSV:) name:@"timeNodeSV" object:nil];
        
    }
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    return self;
}

- (void)getTimeNodeSV:(NSNotification *)notification
{
    self.timeNodeSV = notification.object;

}
- (void)getTimeNodeScrollView:(NSNotification *)notification
{
    self.nodeIndex = notification.object;
}
- (void)refleshData:(NSNotification *)notification
{
    NSNumber *timeNode = notification.object;
    self.nodeIndex = notification.object;
    self.scArray = self.planListRanged[[timeNode intValue]];
    [self reloadData];
}
- (void)getSuperView:(NSNotification *)notification
{
    self.view = notification.object;
    self.vc = [self viewController];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.scArray.count + 1;
 
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else
    {
        if (self.scArray.count != 0)
        {
            CZScheduleInfoCell *cell = [[CZScheduleInfoCell alloc]init];
            //对cell进行赋值
            [self setValueToCell:cell AtIndexPath:indexPath];
            //对cell进行布局
            [self addCellConstraint:cell];
            //设置点击事件
            [self didClickCell:cell];
            cell.tag = indexPath.row - 1;
            //cell.backgroundColor = [UIColor blackColor];
            return cell;
        }
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        if (self.scArray.count == 1)
        {
            UIImage *image = [UIImage imageNamed:@"bg_background1"];
            return 35+130 - image.size.height * 0.205;
        }else
        {
            return 64;
        }

    }else
    {
        CZScheduleInfoCell *cell = (CZScheduleInfoCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.height;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CZScheduleInfoCell *cell = [tableView cellForRowAtIndexPath:indexPath];
// 
//    RCScheduleInfoViewController *sc = [[RCScheduleInfoViewController alloc]init];
//    self.showdDelegate = sc;
//    [self.showdDelegate show:self.scArray[cell.tag]];
//    [self.showdDelegate passScIndex:(int)cell.tag];
//    [self.showdDelegate passScArray:self.scArray];
//    [self.showdDelegate passTableView:self];
//    [self.showdDelegate passTimeNodeScrollView:self.timeNodeSV];
//    [self.showdDelegate passNodeIndex:self.nodeIndex];
//    [self.showdDelegate passPlanListRanged:self.planListRanged];
//    [[self viewController].navigationController pushViewController:sc animated:YES];
}
- (void)didClickCell:(CZScheduleInfoCell *)cell
{
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickSC:)];
    gesture.delegate = self;
    [cell.bgView addGestureRecognizer:gesture];
    
}
#pragma mark - 行程信息的点击事件
- (void)didClickSC:(UITapGestureRecognizer *)clickGesture
{

    RCScheduleInfoViewController *sc = [[RCScheduleInfoViewController alloc]init];
    self.showdDelegate = sc;
    [self.showdDelegate show:self.scArray[clickGesture.view.tag]];
    [self.showdDelegate passScIndex:(int)clickGesture.view.tag];
    [self.showdDelegate passScArray:self.scArray];
    [self.showdDelegate passTableView:self];
    [self.showdDelegate passTimeNodeScrollView:self.timeNodeSV];
    [self.showdDelegate passNodeIndex:self.nodeIndex];
    [self.showdDelegate passPlanListRanged:self.planListRanged];
    [[self viewController].navigationController pushViewController:sc animated:YES];
}
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}
- (UIViewController *)viewController {
    /// Finds the view's view controller.
    
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    return nil;
}
- (UIResponder *)nextResponder
{
    [super nextResponder];
    return self.view;
}
#pragma mark - 判断指定的行程是否已经发生
- (BOOL)isHappened:(PlanModel *)plmodel
{
    NSString *year = [plmodel.planTime substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [plmodel.planTime substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [plmodel.planTime substringWithRange:NSMakeRange(8, 2)];
    NSString *strDate = [NSString stringWithFormat:@"%@%@%@",year,month,day];
    NSInteger intDate = [strDate integerValue];//指定行程的日期
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateformat=[[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"yyyyMMdd"];//设置格式
    [dateformat setTimeZone:[[NSTimeZone alloc]initWithName:@"Asia/Beijing"]];//指定时区
    NSString *currentStrDate = [dateformat stringFromDate:date];
    NSInteger currentIntDate = [currentStrDate integerValue];//当前日期
    
    if (intDate > currentIntDate || intDate == currentIntDate)
    {
        return NO;
    }else
    {
        return YES;
    }
    
}
- (void)setValueToCell:(CZScheduleInfoCell *)cell AtIndexPath:(NSIndexPath *)indexPath
{
    
    PlanModel *plmodel = self.scArray[indexPath.row-1];
    cell.tagImageView.image = [UIImage imageNamed:[self getTagImageFormNString:plmodel.themeName]];
    cell.tagLabel.text = plmodel.themeName;
    NSString *timeText = [plmodel.planTime substringWithRange:NSMakeRange(11, 5)];
    cell.timeLabel.text = timeText;
    cell.contentLabel.text = plmodel.planContent;
    //cell.placeLabel.text = plmodel.acPlace;
    cell.bgView.tag = indexPath.row - 1;
    
    cell.tagLabel.alpha = 0.8;
    cell.contentLabel.alpha = 0.8;
    cell.timeLabel.alpha = 0.8;
    //判断此行程是否已发生
    BOOL isHappened = [self isHappened:plmodel];
    if (isHappened == YES)
    {
        cell.tagLabel.textColor = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
        cell.contentLabel.textColor = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
        cell.timeLabel.textColor = [UIColor colorWithRed:183.0/255.0 green:183.0/255.0 blue:183.0/255.0 alpha:1.0];
        NSString *imgStr = [self getTagImageFormNString:plmodel.themeName];
        cell.tagImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Grey",imgStr]];
    }else
    {
        cell.tagLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9];
        cell.contentLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9];
        cell.timeLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.9];
    }
    
}
- (void)addCellConstraint:(CZScheduleInfoCell *)cell
{
    //75表示界面左侧的tableView的宽度, 60表示cell中的各项间距
    CGFloat maxW = kScreenWidth - 75 - 60 - cell.tagImageView.image.size.width;
    CGSize size = [self sizeWithText:cell.contentLabel.text maxSize:CGSizeMake(maxW, MAXFLOAT) fontSize:14];
    
    [cell.tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.bgView.mas_left).offset(18);
        make.centerY.equalTo(cell.bgView.mas_centerY).offset(-10);
        make.size.mas_equalTo(cell.tagImageView.image.size);
    }];
    
    [cell.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.tagImageView.mas_bottom);
        make.centerX.equalTo(cell.tagImageView.mas_centerX);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(25);
    }];
    
    [cell.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.bgView.mas_top).offset(12);
        make.left.equalTo(cell.tagImageView.mas_right).offset(12);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(17);
    }];
    CGSize  placeSize = [self sizeWithText:cell.placeLabel.text maxSize:CGSizeMake(maxW, MAXFLOAT) fontSize:14];
    [cell.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.timeLabel.mas_bottom);
        make.left.equalTo(cell.timeLabel.mas_left);
        make.width.mas_equalTo(placeSize.width + 1);
        make.height.mas_equalTo(placeSize.height + 1);
    }];
    [cell.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.placeLabel.mas_bottom);
        make.left.equalTo(cell.timeLabel.mas_left);
        make.width.mas_equalTo(size.width+1);
        make.height.mas_equalTo(size.height+1);
    }];
    [cell.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left).offset(10);
        make.right.equalTo(cell.contentView.mas_right).offset(-10);
        make.centerY.equalTo(cell.contentView.mas_centerY).offset(0);
        make.height.mas_equalTo(17 + 12 + size.height + placeSize.height + 12);
    }];
    //17表示timeLabel的高度，12为timeLabel的上边距，size.height表示内容的高度,placeSize.height表示地点的高度,12表示内容的下边距,15表示bgView的上下边距
    cell.height = 17 + 12 + size.height + placeSize.height + 12 + 15+15;
    
}
- (CGSize)sizeWithText:(NSString *)text maxSize:(CGSize)maxSize fontSize:(CGFloat)fontSize
{
    //计算文本的大小
    CGSize nameSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    return nameSize;
}
- (NSString *)getTagImageFormNString:(NSString *)str
{
    if ([str isEqualToString:@"运动"])
    {
        return @"sportSmallIcon";
    }else if ([str isEqualToString:@"约会"])
    {
        return @"appointmentSmallIcon";
    }else if ([str isEqualToString:@"出差"])
    {
        return @"businessSmallIcon";
    }else if ([str isEqualToString:@"会议"])
    {
        return @"meetingSmallIcon";
    }else if ([str isEqualToString:@"购物"])
    {
        return @"shoppingSmallIcon";
    }else if ([str isEqualToString:@"娱乐"])
    {
        return @"entertainmentSmallIcon";
    }else if ([str isEqualToString:@"聚会"])
    {
        return @"partSmallIcon";
    }else
    {
        return @"otherSmallIcon";
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
