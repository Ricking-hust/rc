//
//  CZHomeHeaderView.m
//  日常
//
//  Created by AlanZhang on 16/1/5.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "CZHomeHeaderView.h"
#import "Masonry.h"
#import "CZActivityInfoViewController.h"
#import "FlashActivityModel.h"
#import "RCDirectView.h"

#define d 150   //scrollView的宽度
#define PAGECONTROL_WIDTH 70   //pageControl的宽度
#define PAGECONTROL_HEIGHT  37  //pageControl的高度
#define FONTSIZE    15          //label字体大小

@interface CZHomeHeaderView ()<UIScrollViewDelegate>
@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) BOOL isEnd;
@end

@implementation CZHomeHeaderView


#pragma mark - 类方法

+ (instancetype) headerView
{
    
    CZHomeHeaderView *headerView = [CZHomeHeaderView new];
    headerView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
   
    headerView.isEnd = NO;
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
    
    //创建directView
    RCDirectView *directView = [[RCDirectView alloc]init];
    [directView setSubView];
    headerView.directView = directView;
    headerView.directView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:directView];
    
    //创建
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    [headerView addSubview:view];
    
    headerView.superView = view;
    
    return headerView;
}

-(NSArray *)acList{
    if (!_acList) {
        _acList = [[NSArray alloc]init];
    }
    return _acList;
};

- (void)setView:(NSArray *)flashArray
{
    self.acList = flashArray;
    //设置父容器的大小
    CGRect rect = [[UIScreen mainScreen]bounds];
    [self setFrame:CGRectMake(0, 0, rect.size.width, (rect.size.width*0.427)+99)];
    
    //configure scrollView constraint
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.equalTo(self);
        make.width.mas_equalTo(rect.size.width);
        make.height.mas_equalTo(rect.size.width*0.427);
        
    }];
    
    //configure pagecontrol constraints
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrollView.mas_right).offset(-25);
        make.bottom.equalTo(self.scrollView.mas_bottom);

        make.size.mas_equalTo(CGSizeMake(PAGECONTROL_WIDTH, PAGECONTROL_HEIGHT));
    }];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/2550 alpha:1.0];
    
    [self.directView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pageControl.mas_right);
        make.top.equalTo(self.pageControl.mas_bottom).offset(9);
        make.width.mas_equalTo(rect.size.width);
        make.height.mas_equalTo(90);
    }];
    
//    //configure label constraints
//    NSString *text = @"为你推荐";
//    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
//    //计算文本的大小
//    CGSize textSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:FONTSIZE]} context:nil].size;
//    self.label.text = text;
//    self.label.textColor = [UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:14.0/255.0 alpha:1.0];
//    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).with.offset(10);
//        make.top.equalTo(self.scrollView.mas_bottom).with.offset(10);
//        make.size.mas_equalTo(textSize);
//        
//    }];
    
    int count = (int)flashArray.count;
    
#pragma mark - 设置从服务器接收的图片
    //创建ImageView
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = [UIImageView new];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.scrollView addSubview:button];
        [button addTarget:self action:@selector(imageButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:imageView];
        FlashActivityModel *flashModel = flashArray[i];
        NSString *imageName = flashModel.Image;
        //NSLog(@"%@",imageName);
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"img_3"]];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView.mas_left).with.offset(i * rect.size.width);
            make.top.equalTo(self.scrollView.mas_top);
            make.size.equalTo(self.scrollView);
        }];
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
    NSTimer *timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    self.timer = timer;
    //消息循环
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    [runloop addTimer:timer forMode:NSRunLoopCommonModes];
}
- (UIResponder *)nextResponder
{
    [super nextResponder];
    return self.superView;
}
-(UIViewController *)viewController {
    /// Finds the view's view controller.
    
    // Traverse responder chain. Return first found view controller, which will be the view's view controller.
    UIResponder *responder = self;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    // If the view controller isn't found, return nil.
    return nil;
}

- (void) nextImage
{
    //当前页码
    NSInteger page = self.pageControl.currentPage;
    if (page == self.pageControl.numberOfPages - 1)
    {
        self.isEnd = YES;
    }
    if (page == 0)
    {
        self.isEnd = NO;
    }
    if (self.isEnd == NO)
    {
        page++;
    }else
    {
        page--;
    }
    if (page == self.pageControl.numberOfPages - 1)
    {
        self.isEnd = YES;
    }
    if (page == 0)
    {
        self.isEnd = NO;
    }
//    if (page == self.pageControl.numberOfPages - 1)
//    {
//        page--;
//    }else
//    {
//        page++;
//    }
    self.pageControl.currentPage = page;
    
    CGFloat offsetX = page * self.scrollView.frame.size.width;
    //图片轮播动画
    [UIView animateWithDuration:1.0 animations:^{
        
        self.scrollView.contentOffset = CGPointMake(offsetX, 0);
    }];
}

-(void)imageButton:(UIButton *)button{
    CZActivityInfoViewController *activityInfoView = [[CZActivityInfoViewController alloc]init];
    activityInfoView.title = @"活动介绍";
    activityInfoView.activityModelPre = self.acList[self.pageControl.currentPage];
    [[self viewController].navigationController pushViewController:activityInfoView animated:YES];
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
