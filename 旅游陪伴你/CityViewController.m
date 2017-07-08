//
//  CityViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/1/29.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "CityViewController.h"
#import "City.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD+Extension.h"

@interface CityViewController ()<CLLocationManagerDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate>{
    //城市数据的获取
    NSMutableArray *dataSources;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//搜索到的结果
@property (nonatomic, retain) NSMutableArray *results;
//定义定位属性
@property(nonatomic,retain)CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
- (IBAction)cityBtn:(UIButton *)sender;

@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.searchBar setPlaceholder:@"搜索城市"];
    self.searchBar.delegate = self;
    //初始化UISearchDisplayController
    self.searchController.searchResultsDelegate= self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.delegate = self;
    NSString *path = [[NSBundle mainBundle]pathForResource:@"cityList" ofType:@"plist"];
    NSArray *datas= [NSMutableArray arrayWithContentsOfFile:path];
    [self loadDatas:datas];
}
-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏的出现
    self.navigationController.navigationBarHidden = NO;
    //设置导航栏主题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回键字体的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self locate];
    [MBProgressHUD showMessage:@"正在获取当前位置...."];
    //发送网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
}

#pragma mark - 接收数据后解析
-(void)loadDatas:(NSArray *)datas{
    if (dataSources == nil) {
        dataSources = [NSMutableArray array];
        for (int i = 0;i < datas.count;i++) {
            City *city = [[City alloc]init];
            city.cityName = datas[i];
            [dataSources addObject:city];
        }
    }
}
- (void)locate {
    // 判断定位操作是否被允许
    if([CLLocationManager locationServicesEnabled]) {
        //定位初始化
        _locationManager=[[CLLocationManager alloc] init];
        _locationManager.delegate=self;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _locationManager.distanceFilter=10;
        [_locationManager requestWhenInUseAuthorization];//添加这句
        [_locationManager startUpdatingLocation];//开启定位
    }else {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    // 开始定位
    [_locationManager startUpdatingLocation];
}

#pragma mark - CoreLocation Delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *array, NSError *error)
     {
         if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             //NSLog(@%@,placemark.name);//具体位置
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
                 
             }
             NSString *cc = [city substringToIndex:[city length] - 1];
             [self.cityBtn setTitle:cc forState:UIControlStateNormal];
             //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
             [manager stopUpdatingLocation];
         }else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
     }];
}

#pragma mark - UISearchDisplayDelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString  scope:[_searchBar scopeButtonTitles][_searchBar.selectedScopeButtonIndex]];
    return YES;
}
-(BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
    [self filterContentForSearchText:_searchBar.text scope:_searchBar.scopeButtonTitles[searchOption]];
    return YES;
}
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    for (int i = 0; i< dataSources.count; i++) {
        NSString *storeString = ((City *)dataSources[i]).cityName;
        NSRange storeRange = NSMakeRange(0, storeString.length);
        NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
        if (foundRange.length) {
            [tempResults addObject:dataSources[i]];
        }
    }
    [self.results removeAllObjects];
    _results = [NSMutableArray arrayWithArray:tempResults];
}

#pragma mark - UITableView的相关操作
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _searchController.searchResultsTableView) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor =  [UIColor colorWithRed:236/255.0 green:239/255.0 blue:243/255.0 alpha:1];
        return _results.count;
    }
    else {
        return dataSources.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        static NSString *kCellIdentifier = @"iCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        }
        City *city = dataSources[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"iconfont-dian"];
        cell.textLabel.text = city.cityName;
        return cell;
    }
    if ([tableView isEqual:tableView]) {
        static NSString *kCellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        }
        if (tableView == self.searchController.searchResultsTableView) {
            City *city =  _results[indexPath.row];
            cell.textLabel.text = city.cityName;
            cell.imageView.image = [UIImage imageNamed:@"iconfont-dian"];
        }
        return cell;
    }
    return  nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    City *city = [[City alloc]init];
    if (tableView == _searchController.searchResultsTableView){
        city =  _results[indexPath.row];
    }
    else{
        city = dataSources[indexPath.row];
    }
    [self.delegate cityViewController:self didCity:city.cityName];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cityBtn:(UIButton *)sender {
    [self.delegate cityViewController:self didCity:sender.titleLabel.text];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
