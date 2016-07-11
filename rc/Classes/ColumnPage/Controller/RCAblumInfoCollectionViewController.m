//
//  RCAblumInfoCollectionViewController.m
//  rc
//
//  Created by LittleMian on 16/7/11.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCAblumInfoCollectionViewController.h"
#import "Masonry.h"
@interface RCAblumInfoCollectionViewController()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@end
@implementation RCAblumInfoCollectionViewController
static NSString * const albumInfoReuseIdentifier = @"albumCell";
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0  blue:245.0/255.0  alpha:1.0];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"backIcon"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    self.navigationItem.title = @"这个还没写";
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

    return 10;
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:albumInfoReuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
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
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:albumInfoReuseIdentifier];

    }
    return _collectionView;
}
@end
