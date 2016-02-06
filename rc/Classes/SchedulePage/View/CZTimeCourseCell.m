//
//  CZTimeCourseCell.m
//  rc
//
//  Created by AlanZhang on 16/2/2.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZTimeCourseCell.h"
#import "CZData.h"
#import "Masonry.h"

#define WEEKLABEL_SIZE 10   //星期标签字体大小
#define TIMELABEL_SIZE 16   ///时间标签字体大小
#define THEMECOLOR  [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0] //主题色

@implementation CZTimeCourseCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"TimeCourseCell";
    CZTimeCourseCell * cell = (CZTimeCourseCell*)[tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去掉分割线
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;    //设置cell点击时无状态
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;//禁用cell的点击事件
#pragma mark - 测试语句
    //cell.backgroundColor = [UIColor grayColor];
    
    return cell;

}
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建子控件
        self.bgImage = [[UIImageView alloc]init];
        [self.contentView addSubview:self.bgImage];
        
        self.timepUpLine = [[UILabel alloc]init];   //时间上线
        [self.contentView addSubview:self.timepUpLine];
        
        self.timepDownLine = [[UILabel alloc]init];   //时间下线
        [self.contentView addSubview:self.timepDownLine];
        
        self.timeLine = [[UILabel alloc]init];
        [self.contentView addSubview:self.timeLine];
        
        self.timeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.timeLabel];
        
        self.weekLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.weekLabel];
        
        self.pointView = [[UIView alloc]init];
        [self.contentView addSubview:self.pointView];
        
        self.currentPoint = [[UIImageView alloc]init];
        [self.contentView addSubview:self.currentPoint];
        
        self.tagImg = [[UIImageView alloc]init];
        [self.bgImage addSubview:self.tagImg];
        
        self.tagLabel = [[UILabel alloc]init];
        self.tagLabel.font = [UIFont systemFontOfSize:14];
        [self.bgImage addSubview:self.tagLabel];
        
        self.acTime = [[UILabel alloc]init];
        self.acTime.font = [UIFont systemFontOfSize:14];
        [self.bgImage addSubview:self.acTime];
        
        self.acContent = [[UILabel alloc]init];
        self.acContent.numberOfLines = 0;
        self.acContent.font = [UIFont systemFontOfSize:16];
        [self.bgImage addSubview:self.acContent];
        
        self.deleteBtn = [[UIButton alloc]init];
        [self.contentView addSubview:self.deleteBtn];
        
    }
    return self;
}

- (void) setData:(CZData *)data
{
    _data = data;
    [self setSubViewsContent];
    [self setSubViewsConstaint];
}
- (void)setSubViewsContent
{

    self.timeLine.backgroundColor = THEMECOLOR;
    self.timepDownLine.backgroundColor = THEMECOLOR;
    self.timepUpLine.backgroundColor = THEMECOLOR;
    self.pointView.backgroundColor = THEMECOLOR;
    [self.pointView.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
    [self.pointView.layer setCornerRadius:7];
    
    self.timeLabel.font = [UIFont systemFontOfSize:TIMELABEL_SIZE];
    self.timeLabel.textColor = THEMECOLOR;
    self.timeLabel.text = @"12.28";
    
    self.weekLabel.font = [UIFont systemFontOfSize:WEEKLABEL_SIZE];
    self.weekLabel.textColor = THEMECOLOR;
    self.weekLabel.text = @"星期一";
    
    self.currentPoint.image = [UIImage imageNamed:self.data.imgStr];
    self.tagImg.image = [UIImage imageNamed:self.data.tagStr];
    self.tagLabel.text = @"运行";
    self.acTime.text = self.data.timeStr;
    self.acContent.text = self.data.contentStr;
    
    UIImage *image = [UIImage imageNamed:self.data.bgimgStr];
    self.bgImage.layer.contents = (id) image.CGImage;    // 如果需要背景透明加上下面这句
    self.bgImage.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    [self.deleteBtn setImage:[UIImage imageNamed:@"deleteIcon"] forState:UIControlStateNormal];
    
#pragma mark - 隐藏currentPoint,默认隐藏删除按钮
    self.deleteBtn.hidden = YES;
    self.currentPoint.hidden = YES;
    if (self.isLastCell)
    {
        self.currentPoint.hidden = NO;
        self.timeLine.hidden = YES;
        self.timeLabel.hidden = YES;
        self.weekLabel.hidden = YES;
    }
}
- (void)setSubViewsConstaint
{
    CGRect rect = [[UIScreen mainScreen]bounds];
    CGFloat leftPadding = rect.size.width * 0.21;
    CGSize acTimeSize = [self sizeWithText:self.acTime.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:14];
    CGSize tagLabelSize = [self sizeWithText:self.tagLabel.text maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT) fontSize:14];
    CGSize acContentSize = [self sizeWithText:self.acContent.text maxSize:CGSizeMake(rect.size.width * 0.5, MAXFLOAT) fontSize:16];
    
    CGFloat tagImgTopPadding = 30/2;            //标志图片的上边距大小
    CGFloat tagImgLeftPadding = 36/2;           //标志图片的左边距大小
    CGFloat paddingBetweenTagimageAndTag = 5;   //标志图片与标签之间的间距
    CGFloat leftPaddingOfTagAndTime = 24/2;     //时间与标志图片之间的间距
    CGFloat topPadding = 34/2;                  //时间标签的上边距
    CGFloat paddingBetweenTimeAndContent = 16/2;//时间标签与主题之间的间距
    
    CGFloat width = rect.size.width;
    CGFloat height = topPadding + acTimeSize.height + paddingBetweenTimeAndContent + acContentSize.height + 20;
    self.cellSize = CGSizeMake(width, height);
    
    //添加时间轴约束
    [self.timeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(leftPadding-2);
        make.top.equalTo(self.contentView.mas_top);
        make.size.mas_equalTo(CGSizeMake(3, self.cellSize.height));
    }];
    

    //添加当前结节约束
    CGFloat leftPaddingOfCurrentPoint = leftPadding - self.currentPoint.image.size.width / 2 + 2; //当前时间结点的到父视图的左边距
    [self.currentPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(leftPaddingOfCurrentPoint);
        make.top.equalTo(self.bgImage.mas_top).with.offset(25);
        make.size.mas_equalTo(CGSizeMake(self.currentPoint.image.size.width, self.currentPoint.image.size.height));
    }];
    
    //时间上线约束
    [self.timepUpLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset(leftPadding-2);
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.bottom.equalTo(self.currentPoint.mas_top).with.offset(-4);
        make.width.equalTo(@3);
    }];
    
    //时间下线约束
    [self.timepDownLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.currentPoint.mas_bottom).with.offset(4);
        make.left.equalTo(self.timepUpLine).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(0);
        make.width.equalTo(self.timepUpLine);
    }];
    
    //添加标志图片约束
    [self.tagImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgImage.mas_left).with.offset(tagImgLeftPadding);
        make.top.equalTo(self.bgImage.mas_top).with.offset(tagImgTopPadding);
        make.size.mas_equalTo(self.tagImg.image.size);
    }];

    //添加标签约束
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagImg.mas_left).with.offset(2);
        make.top.equalTo(self.tagImg.mas_bottom).with.offset(paddingBetweenTagimageAndTag);
        make.size.mas_equalTo(CGSizeMake(tagLabelSize.width+1, tagLabelSize.height+1));
    }];
    
    //添加时间约束
    [self.acTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tagImg.mas_right).with.offset(leftPaddingOfTagAndTime);
        make.top.equalTo(self.bgImage.mas_top).with.offset(topPadding);
        make.size.mas_equalTo(CGSizeMake(acTimeSize.width+1, acTimeSize.height+1));
    }];
    
    //添加主题约束
    [self.acContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.acTime.mas_bottom).with.offset(paddingBetweenTimeAndContent);
        make.left.equalTo(self.acTime.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(acContentSize.width+1, acContentSize.height+1));
    }];
    
    //添加背景约束
    CGFloat bgWidth = acContentSize.width + acTimeSize.width + tagImgLeftPadding + leftPaddingOfTagAndTime + 10;
    CGFloat bgHeight = acTimeSize.height + acContentSize.height + topPadding + paddingBetweenTimeAndContent+ 20;
    [self.bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLine.mas_right).with.offset(20);
        make.top.equalTo(self.timeLine.mas_top).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(bgWidth, bgHeight));
    }];
    //添加时间点
    CGFloat paddingWithbgImage = bgHeight * 0.33;
    [self.pointView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentPoint.mas_left).with.offset(8);
        make.top.equalTo(self.bgImage.mas_top).with.offset(paddingWithbgImage);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    //添加时间标签约束
    CGSize timeSize = [self sizeWithText:self.timeLabel.text maxSize:CGSizeMake(50, 50) fontSize:TIMELABEL_SIZE];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pointView.mas_left).with.offset(-6);
        make.top.equalTo(self.pointView.mas_top);
        make.size.mas_equalTo(CGSizeMake(timeSize.width+1, timeSize.height+1));
    }];
    CGSize weekSize = [self sizeWithText:self.weekLabel.text maxSize:CGSizeMake(30, 30) fontSize:WEEKLABEL_SIZE];
    [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom);
        //make.right.equalTo(self.timeLabel.mas_right);
        make.centerX.equalTo(self.timeLabel);
        make.size.mas_equalTo(CGSizeMake(weekSize.width+1, weekSize.height+1));
    }];
    
    //添加删除按钮约束
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImage.mas_top).with.offset(0);
        make.right.equalTo(self.bgImage.mas_right).with.offset(0);
        make.size.mas_equalTo(self.deleteBtn.imageView.image.size);
    }];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
