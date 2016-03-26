//
//  CZHomeHeaderView.m
//  日常
//
//  Created by AlanZhang on 16/1/5.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZHomeHeaderView.h"
#import "Masonry.h"
#import "FlashActivityModel.h"

#define SCROLLVIEW_HEIGHT 150   //scrollView的宽度
#define PAGECONTROL_WIDTH 70   //pageControl的宽度
#define PAGECONTROL_HEIGHT  37  //pageControl的高度
#define FONTSIZE    15          //label字体大小

@interface CZHomeHeaderView ()<UIScrollViewDelegate>
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation CZHomeHeaderView


#pragma mark - 类方法

+ (instancetype) headerView
{
    
    CZHomeHeaderView *headerView = [CZHomeHeaderView new];
    headerView.backgroundColor = [UIColor whiteColor];
   
    //创建scrollView
    UIScrollView *scrollView = [UIScrollView new];
    headerView.scrollView = scrollView;
    [headerView addSubview:scrollView];
    
    //创建pageControl
    UIPageControl *pageControl = [UIPageControl new];
    headerView.pageControl = pageControl;
    [headerView addSubview:pageControl];
    
    //创建label
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:FONTSIZE];
    headerView.label = label;
    [headerView addSubview:label];
    
    //创建
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    headerView.segmentation = view;
    [headerView addSubview:view];
    
    return headerView;
}

- (void)setView:(NSArray *)flashArray
{
    //设置父容器的大小
    CGRect rect = [[UIScreen mainScreen]bounds];
    [self setFrame:CGRectMake(0, 0, rect.size.width, SCROLLVIEW_HEIGHT + 70.0f/2 + 14.0f/2)];
    
    //configure scrollView constraint
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self);
        make.width.mas_equalTo(rect.size.width);
        make.height.mas_equalTo(SCROLLVIEW_HEIGHT);
        
    }];
    
    //configure pagecontrol constraints
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrollView.mas_right).with.offset(-40.0f/2);
        make.bottom.equalTo(self.label.mas_top).with.offset(-10.0f);

        make.size.mas_equalTo(CGSizeMake(PAGECONTROL_WIDTH, PAGECONTROL_HEIGHT));
    }];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/2550 alpha:1.0];
    
    //configure label constraints
    NSString *text = @"为你推荐";
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    //计算文本的大小
    CGSize textSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONTSIZE]} context:nil].size;
    self.label.text = text;
    self.label.textColor = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10);
        make.top.equalTo(self.scrollView.mas_bottom).with.offset(10);
        make.size.mas_equalTo(textSize);
        
    }];
    
    //configure segmentation分割线
    [self.segmentation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self.label.mas_bottom).with.offset(10.0f);
        make.size.mas_equalTo(CGSizeMake(rect.size.width, 14.0/2));
    }];
    int count = 4;
    
#pragma mark - 设置从服务器接收的图片
    //创建ImageView
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = [UIImageView new];
        [self.scrollView addSubview:imageView];
        FlashActivityModel *flashModel = flashArray[i];
        NSString *imageName = flashModel.Image;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"img_3"]];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView.mas_left).with.offset(i * rect.size.width);
            make.top.equalTo(self.scrollView.mas_top);
            make.size.equalTo(self.scrollView);
        }];
    }
    //设置滚动范围
    self.scrollView.contentSize = CGSizeMake(count * rect.size.width, 0);

    //设置分布滚动，去掉水平和垂直滚动条
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    //设置pageControl
    self.pageControl.numberOfPages = count;
    //设置scrollView代理
    self.scrollView.delegate = self;
    

    //设置定时器
    [self addTimerObj];

}

//添加定时器
- (void)addTimerObj
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    self.timer = timer;
    //消息循环
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:timer forMode:NSRunLoopCommonModes];
}


- (void) nextImage
{
    //当前页码
    NSInteger page = self.pageControl.currentPage;
    
    if (page == self.pageControl.numberOfPages - 1)
    {
        page = 0;
    }else
    {
        page++;
    }
    self.pageControl.currentPage = page;
    
    CGFloat offsetX = page * self.scrollView.frame.size.width;
    //图片轮播动画
    [UIView animateWithDuration:1.0 animations:^{
        
        self.scrollView.contentOffset = CGPointMake(offsetX, 0);
    }];
}


#pragma mark - scrollView代理方法

//正在滚动的时候
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    int page = (scrollView.contentOffset.x + scrollView.frame.size.width / 2)/ scrollView.frame.size.width;
    self.pageControl.currentPage = page;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //停止定时器
    [self.timer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimerObj];
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
