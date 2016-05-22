//
//  RCCityViewController.m
//  rc
//
//  Created by 余笃 on 16/5/16.
//  Copyright © 2016年 AlanZhang. All rights reserved.
//

#import "RCCityViewController.h"
#import "CityCollectionViewCell.h"

@implementation RCCityViewController

- (void)viewWillAppear:(BOOL)animated
{
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigation];
    [self setCollectionView];
}


- (void)setNavigation
{
    self.title = @"城市选择";
    UIBarButtonItem *leftButton =[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"close"] style:UIBarButtonItemStylePlain target:self action:@selector(didCancelSelection)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
}

//取消城市选择直接返回上一个视图控制器
- (void)didCancelSelection
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(CityList *)ctList{
    if (!_ctList) {
        _ctList = [[CityList alloc]init];
    }
    return _ctList;
}

-(NSString *)locateCityId{
    if (!_locateCityId) {
        _locateCityId = [[NSString alloc]init];
    }
    return _locateCityId;
}

-(void)setCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 10);
    
    self.cityView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.cityView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.cityView];
    
    [self.cityView registerClass:[CityCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    
    [self.cityView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    
    self.cityView.delegate = self;
    self.cityView.dataSource = self;
}

#pragma mark collectionView代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.ctList.list.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CityCollectionViewCell *cell = (CityCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    cell.ctmodel = self.ctList.list[indexPath.row];
    if ([cell.ctmodel.cityID isEqualToString:self.locateCityId]) {
        cell.ctmodel.isLocate = YES;
    } else {
        cell.ctmodel.isLocate = NO;
    }
    [cell setCityViewWithCityModel:self.ctList.list[indexPath.row]];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenWidth/3, 130);
}

//垂直间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//水平间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView" forIndexPath:indexPath];
    headerView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    return headerView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CityCollectionViewCell *cell = (CityCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [userDefaults setObject:cell.ctmodel.cityID forKey:@"cityId"];
    if ([DataManager manager].user.isLogin) {
        [self modifyCity:cell.ctmodel.cityID];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshColumn" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"%@",cell.ctmodel.cityID);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)modifyCity:(NSString *)cityId{
    [[DataManager manager] modifyAccountWithUserId:[userDefaults objectForKey:@"userId"] opType:@"2" userPwdO:@"" userPwdN:@"" username:[userDefaults objectForKey:@"userName"] userSign:[userDefaults objectForKey:@"userSign"] userPic:[userDefaults objectForKey:@"userPic"] userSex:[userDefaults objectForKey:@"userSex"] userMail:[userDefaults objectForKey:@"userMail"] cityId:cityId success:^(NSString *msg) {
        
        [userDefaults setObject:cityId forKey:@"cityId"];
    } failure:^(NSError *error) {
        NSLog(@"Error:%@",error);;
    }];
    
}

@end
