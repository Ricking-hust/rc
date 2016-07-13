//
//  RCAblumInfoCollectionViewController.m
//  rc
//
//  Created by LittleMian on 16/7/11.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCAblumInfoCollectionViewController.h"
#import "RCNetworkingRequestOperationManager.h"
#import "RCAblumActivityModel.h"
#import "RCAblumInfoCollectionCell.h"
#import "Masonry.h"
@interface RCAblumInfoCollectionViewController()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *ablumActivity;
@property (nonatomic, strong) NSString *tittle;
@property (nonatomic, strong) NSString *album_id;
@end
@implementation RCAblumInfoCollectionViewController
static NSString * const albumInfoReuseIdentifier = @"albumCell";
- (void)setNavigationTittle:(NSString *)tittle
{
    self.tittle = tittle;
}
- (void)setAblumID:(NSString *)ablumID
{
    self.album_id = ablumID;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    self.navigationItem.title = self.tittle;
    //[self getAllAblumActivity];
    [self test];
}
#pragma mark - 测试函数
- (void)test
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    RCAblumActivityModel *model = [[RCAblumActivityModel alloc]init];
    model.ac_id = @"2404";
    model.ac_img = @"http://img.myrichang.com/img/banner/2016-06/06/1-6.jpg";
    model.ac_title = @"【武昌VOX】6月26日 前卫摇滚 木推瓜 新专悲剧的诞生首发及重组巡演";
    model.ac_time = @"2016-06-26 21:00:00";
    model.ac_place = @"武汉 洪山区 鲁磨路118号国光大厦VOX LIVEHOUSE";
    model.ac_des = @"暂无";
    [arr addObject:model];
    self.ablumActivity = [[NSArray alloc]initWithArray:arr];
    [self.collectionView reloadData];
}
- (void)getAllAblumActivity
{
    NSString *urlStr = @"http://appv2.myrichang.com/Home/Industry/getAlbumAcs";
    NSLog(@"url = %@",urlStr);
    NSLog(@"参数--》album_id = %@",self.album_id);
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:self.album_id,@"album_id",nil];
    [RCNetworkingRequestOperationManager request:urlStr requestType:POST parameters:parameters completeBlock:^(NSData *data) {
        id dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        NSArray *temp = [self activityFromDict:dict];
        if (temp.count !=0 && temp != nil)
        {
            self.ablumActivity = temp;
            [self.collectionView reloadData];
        }
        
    } errorBlock:^(NSError *error) {
        NSLog(@"请求失败:%@",error);
    }];

}
- (NSArray *)activityFromDict:(NSDictionary *)dict
{
    NSNumber *code = [dict valueForKey:@"code"];
    
    NSLog(@"msg = %@",[dict valueForKey:@"msg"]);
    NSLog(@"code = %@",code);
    if ([code isEqualToNumber:[[NSNumber alloc]initWithInt:200]])
    {//返回正确的数据
        
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        NSArray *data = [dict valueForKey:@"data"];
        for (NSDictionary *dic in data)
        {
            
            [temp addObject:[self getAblumAcitvity:dic]];
        }
        NSArray *activities = [[NSArray alloc]initWithArray:temp];
        return activities;
    }else if ([code isEqualToNumber:[[NSNumber alloc]initWithInt:210]])
    {//返回失败
        NSLog(@"获取专辑内所有活动:%@",[dict valueForKey:@"msg"]);
        return nil;
    }else
    {
        NSLog(@"获取专辑内所有活动失败其他错误：%@",code);
        return nil;
    }
}
- (RCAblumActivityModel *)getAblumAcitvity:(NSDictionary *)dict
{
    RCAblumActivityModel *model = [[RCAblumActivityModel alloc]init];
    model.ac_id    = [dict valueForKey:@"ac_id"];
    model.ac_img   = [dict valueForKey:@"ac_img"];
    model.ac_title = [dict valueForKey:@"ac_title"];
    model.ac_time  = [dict valueForKey:@"ac_time"];
    model.ac_place = [dict valueForKey:@"ac_place"];
    model.ac_des   = [dict valueForKey:@"ac_des"];
    return model;
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - <UICollectionViewDataSource>
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.ablumActivity.count == 0 || self.ablumActivity == nil)
    {
        return 0;
    }else
    {
        return self.ablumActivity.count;
    }
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     RCAblumInfoCollectionCell*cell = (RCAblumInfoCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:albumInfoReuseIdentifier forIndexPath:indexPath];
    cell.model = self.ablumActivity.firstObject;
    return cell;
}
#pragma mark - load lazy
- (UICollectionView *)collectionView
{
    if (_collectionView == nil)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kScreenWidth, 360);
        layout.minimumInteritemSpacing = 0;//行间距
        layout.minimumLineSpacing = 10;    //列间距
        //CGFloat top = margin + 44;
        
       _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
       _collectionView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
        [self.view addSubview:_collectionView];
        [_collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(-64);//64用于消除collectionView在ScrollView的位置影响
            make.left.equalTo(self.view.mas_left);
            make.width.mas_equalTo(kScreenWidth);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        _collectionView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceHorizontal = NO;
        //if (iOS7Later) _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 2);
        _collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -2);
        
        [_collectionView registerClass:[RCAblumInfoCollectionCell class] forCellWithReuseIdentifier:albumInfoReuseIdentifier];

    }
    return _collectionView;
}
- (NSArray *)ablumActivity
{
    if (_ablumActivity == nil)
    {
        _ablumActivity =[[NSArray alloc]init];
    }
    return _ablumActivity;
}
- (NSString *)album_id
{
    if (_album_id == nil)
    {
        _album_id = [[NSString alloc]init];
    }
    return _album_id;
}
- (NSString *)tittle
{
    if (_tittle == nil)
    {
        _tittle = [[NSString alloc]init];
    }
    return _tittle;
}

@end
