//
//  DeliciouFoodViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/26.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "DeliciouFoodViewController.h"
#import "FoodType.h"
#import "SortType.h"
#import "Food.h"
#import "FoodTableViewCell.h"
#import "DataServers.h"
#import "MBProgressHUD+Extension.h"
#import "AccommodationDeViewController.h"
#import <MJRefresh.h>

@interface DeliciouFoodViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cityNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *food;
@property(strong,nonatomic) NSArray *foodDatas;
@property (weak, nonatomic) IBOutlet UIButton *sort;
@property(strong,nonatomic) NSArray *sortDatas;
@property (weak, nonatomic) IBOutlet UITableView *foodTableView;
@property (weak, nonatomic) IBOutlet UITableView *sortTableView;
@property (weak, nonatomic) IBOutlet UIView *foodView;
@property (weak, nonatomic) IBOutlet UIView *sortView;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@property(strong,nonatomic) DataServers *data;
@property(strong,nonatomic)FoodType *foodType;
@property(strong,nonatomic)SortType *sortType;

- (IBAction)food:(UIButton *)sender;
- (IBAction)sort:(UIButton *)sender;

@end

@implementation DeliciouFoodViewController

static int i =1;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.foodType = [[FoodType alloc]init];
    self.sortType = [[SortType alloc]init];
    self.data = [[DataServers alloc]init];
    [self.cityNameLabel setTitle:self.cityName forState:UIControlStateNormal];
    FoodType *food1 = [[FoodType alloc]init];
    food1.subcat_id = 364;
    food1.subcat_name = @"火锅";
    FoodType *food2 = [[FoodType alloc]init];
    food2.subcat_id = 962;
    food2.subcat_name = @"全部中餐";
    FoodType *food3 = [[FoodType alloc]init];
    food3.subcat_id = 392;
    food3.subcat_name = @"自助餐";
    FoodType *food4 = [[FoodType alloc]init];
    food4.subcat_id = 393;
    food4.subcat_name = @"川菜";
    FoodType *food5 = [[FoodType alloc]init];
    food5.subcat_id = 389;
    food5.subcat_name = @"日本料理";
    FoodType *food6 = [[FoodType alloc]init];
    food6.subcat_id = 391;
    food6.subcat_name = @"西餐";
    FoodType *food7 = [[FoodType alloc]init];
    food7.subcat_id = 460;
    food7.subcat_name = @"烧烤/烤肉";
    FoodType *food8 = [[FoodType alloc]init];
    food8.subcat_id = 501;
    food8.subcat_name = @"韩国料理";
    FoodType *food9 = [[FoodType alloc]init];
    food9.subcat_id = 655;
    food9.subcat_name = @"素食";
    FoodType *food10 = [[FoodType alloc]init];
    food10.subcat_id = 878;
    food10.subcat_name = @"甜点饮品";
    FoodType *food11 = [[FoodType alloc]init];
    food11.subcat_id = 884;
    food11.subcat_name = @"麻辣烫";
    FoodType *food12 = [[FoodType alloc]init];
    food12.subcat_id = 439;
    food12.subcat_name = @"海鲜";
    FoodType *food13 = [[FoodType alloc]init];
    food13.subcat_id = 451;
    food13.subcat_name = @"新疆/清真菜";
    FoodType *food14 = [[FoodType alloc]init];
    food14.subcat_id = 327;
    food14.subcat_name = @"其他";
    self.foodDatas = [NSArray arrayWithObjects:food1,food2,food3,food4, food5,food6,food7,food8,food9,food10,food11,food12,food13,food14,nil];
    SortType *sort1 = [[SortType alloc]init];
    sort1.typeName = @"综合排序";
    sort1.typeNum = 0;
    SortType *sort2 = [[SortType alloc]init];
    sort2.typeName = @"价格低优先";
    sort2.typeNum = 1;
    SortType *sort3 = [[SortType alloc]init];
    sort3.typeName = @"价格高优先";
    sort3.typeNum = 2;
    SortType *sort4 = [[SortType alloc]init];
    sort4.typeName = @"折扣高优先";
    sort4.typeNum = 3;
    SortType *sort5 = [[SortType alloc]init];
    sort5.typeName = @"销量高优先";
    sort5.typeNum = 4;
    SortType *sort6 = [[SortType alloc]init];
    sort6.typeName = @"距离近优先";
    sort6.typeNum = 5;
    SortType *sort7 = [[SortType alloc]init];
    sort7.typeName = @"用户评分高优先";
    sort7.typeNum = 8;
    self.sortDatas = [NSArray arrayWithObjects:sort1,sort2,sort3,sort4,sort5,sort6,sort7, nil];
    self.resultTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSString *str = [NSString stringWithFormat:@"%@&page=%d",self.urlStr,i];
        [self.data gainSynchronizationData:str andBlock:^(NSDictionary *resultDic) {
            if ([[resultDic valueForKey:@"data"] isKindOfClass:[NSNull class]]) {
                self.resultTableView.mj_footer.hidden = YES;
            }
            else{
                NSArray *array = [NSArray array];
                array = [[resultDic valueForKey:@"data"]valueForKey:@"deals"];
                NSMutableArray *array1= [NSMutableArray array];
                for (NSDictionary *dic in array) {
                    Food *food = [[Food alloc]initWithDictionary:dic];
                    [array1 addObject:food];
                }
                [self.resultArray insertObjects:array1 atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.resultArray.count, array1.count)]];
            }
            
            
        }];
        i++;
        [self.resultTableView reloadData];
        [self.resultTableView.mj_footer endRefreshing];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏主题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回键字体的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"美食";
    //设置导航栏的出现
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}
#pragma mark - UITableView的相关操作

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([tableView isEqual:self.foodTableView]){
        return self.foodDatas.count;
    }
    else if ([tableView isEqual:self.sortTableView]){
        return self.sortDatas.count;
    }
    else if ([tableView isEqual:self.resultTableView]){
        return self.resultArray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([tableView isEqual:self.foodTableView]){
        static NSString *kCellIdentifier = @"foodCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        }
        FoodType *food = self.foodDatas[indexPath.row];
        cell.textLabel.text = food.subcat_name;
        return cell;
    }
    else if ([tableView isEqual:self.sortTableView]){
        static NSString *kCellIdentifier = @"sortCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        }
        SortType *sort = self.sortDatas[indexPath.row];
        cell.textLabel.text = sort.typeName;
        return cell;
    }
    else if ([tableView isEqual:self.resultTableView]){
        Food *data = self.resultArray[indexPath.row];
        static NSString *CellIdentifier = @"FoodtableViewCell";
        BOOL nibsRegistered = NO;
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:@"FoodTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
            nibsRegistered = YES;
        }
        FoodTableViewCell *cell = (FoodTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.food = data;
        return cell;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([tableView isEqual:self.foodTableView]){
        return 44;
    }
    else if ([tableView isEqual:self.sortTableView]){
        return 44;
    }
    else if ([tableView isEqual:self.resultTableView]){
        return 110;
    }
    return 0;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([tableView isEqual:self.foodTableView]){
        [MBProgressHUD showMessage:@"正在搜索"];
        self.foodType = self.foodDatas[indexPath.row];
        [self.food setTitle:self.foodType.subcat_name forState:UIControlStateNormal];
        NSString *str;
        if ([self.sortType.typeName isEqualToString:@""]) {
            str = [NSString stringWithFormat:@"&subcat_ids=%d",self.foodType.subcat_id];
        }
        else{
           str = [NSString stringWithFormat:@"&subcat_ids=%d&sort=%d",self.foodType.subcat_id,self.sortType.typeNum];
        }
        NSString *urlStr1 = [[NSString alloc]initWithFormat: @"%@%@",self.urlStr, str];
        [self.data gainSynchronizationData:urlStr1 andBlock:^(NSDictionary *resultDic) {
            NSArray *array = [NSArray array];
            array = [[resultDic valueForKey:@"data"]valueForKey:@"deals"];
            [self.resultArray removeAllObjects];
            for (NSDictionary *dic in array) {
                Food *food = [[Food alloc]initWithDictionary:dic];
                [self.resultArray addObject:food];
            }
            self.foodView.alpha = 0;
            isFood++;
            [self.resultTableView reloadData];
            [MBProgressHUD hideHUD];
        }];
    }
    else if ([tableView isEqual:self.sortTableView]){
        self.sortType = self.sortDatas[indexPath.row];
        [self.sort setTitle:self.sortType.typeName forState:UIControlStateNormal];
        [MBProgressHUD showMessage:@"正在搜索"];
        NSString *str;
        if ([self.foodType.subcat_name isEqualToString:@""]) {
            str = [NSString stringWithFormat:@"&sort=%d",self.sortType.typeNum];
        }
        else{
            str = [NSString stringWithFormat:@"&subcat_ids=%d&sort=%d",self.foodType.subcat_id,self.sortType.typeNum];
        }
        NSString *urlStr1 = [[NSString alloc]initWithFormat: @"%@%@",self.urlStr, str];
        [self.data gainSynchronizationData:urlStr1 andBlock:^(NSDictionary *resultDic) {
            NSArray *array = [NSArray array];
            array = [[resultDic valueForKey:@"data"]valueForKey:@"deals"];
            [self.resultArray removeAllObjects];
            for (NSDictionary *dic in array) {
                Food *food = [[Food alloc]initWithDictionary:dic];
                [self.resultArray addObject:food];
            }
            self.sortView.alpha = 0;
            isSort++;
            [self.resultTableView reloadData];
            [MBProgressHUD hideHUD];
        }];
    }
    else if ([tableView isEqual:self.resultTableView]){
        Food *food = self.resultArray[indexPath.row];
        AccommodationDeViewController *vc = [[AccommodationDeViewController alloc]init];
        vc.isViewContrller = @"美食";
        vc.foodURL = food.deal_murl;
        vc.food = food;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

static int isFood;
- (IBAction)food:(UIButton *)sender {
    if (isFood%2 == 0) {
        [UIView animateWithDuration:1.0 animations:^{
            self.foodView.alpha = 1;
        }];
    }
    else{
        [UIView animateWithDuration:1.0 animations:^{
            self.foodView.alpha = 0;
        }];
    }
    isFood++;
}

static int isSort;
- (IBAction)sort:(UIButton *)sender {
    if (isSort%2 == 0) {
        [UIView animateWithDuration:1.0 animations:^{
            self.sortView.alpha = 1;
        }];
    }
    else{
        [UIView animateWithDuration:1.0 animations:^{
            self.sortView.alpha = 0;
        }];
    }
    isSort++;
}
@end
