//
//  TravelViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/18.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "TravelViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD+Extension.h"
#import "CityViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobProFile.h>
#import "TravelTableViewCell.h"
#import "Travel.h"
#import "AccommodationDeViewController.h"

typedef NSComparisonResult (^NSComparator)(id obj1,id obj2);
@interface TravelViewController ()<CLLocationManagerDelegate,CityViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cityName;
- (IBAction)cityName:(UIButton *)sender;

//定义定位属性
@property(nonatomic,retain)CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *priceView;//价格下拉
@property (weak, nonatomic) IBOutlet UIView *scoreView;//评分下拉
@property (weak, nonatomic) IBOutlet UIButton *sortResult;//价格排序结果
@property (weak, nonatomic) IBOutlet UIButton *scoreResult;//评分排序结果
@property (weak, nonatomic) IBOutlet UIButton *highScoreBtn;

@property (strong,nonatomic)NSMutableArray *result;
@property (strong,nonatomic)NSArray *lowPriceScore;//低价评分排序结果
@property (strong,nonatomic)NSArray *highPriceScore;//高价评分排序结果
@property (strong,nonatomic)NSArray *priceHighScore;//价格高评分排序结果
@property (strong,nonatomic)NSArray *lowPriceHighScore;//低价高评分排序结果
@property (strong,nonatomic)NSArray *highPriceHighScore;//高价高评分排序结果

@property (strong,nonatomic)Travel *travel;
//评分排序事件
- (IBAction)scoreResult:(UIButton *)sender;
- (IBAction)scoreSort:(UIButton *)sender;

//价格排序事件
- (IBAction)sortResult:(UIButton *)sender;

- (IBAction)priceSort:(UIButton *)sender;

@end

@implementation TravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.travel = [[Travel alloc]init];
    [self locate];
    [MBProgressHUD showMessage:@"正在获取当前位置...."];
    //发送网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
    self.result = [NSMutableArray array];
    self.result = self.resultArray;
    self.lowPriceScore = [NSArray array];
    self.highPriceScore = [NSArray array];
    self.priceHighScore = [NSArray array];
    self.lowPriceHighScore = [NSArray array];
    self.highPriceHighScore = [NSArray array];
    
    self.lowPriceScore =[self.resultArray sortedArrayUsingComparator:^NSComparisonResult(Travel  *obj1, Travel *obj2) {
        return [[NSNumber numberWithInt:[obj1.price intValue]] compare:[NSNumber numberWithInt:[obj2.price intValue]]];
    }];
    self.highPriceScore =[self.resultArray sortedArrayUsingComparator:^NSComparisonResult(Travel  *obj1, Travel *obj2) {
        return [[NSNumber numberWithInt:[obj2.price intValue]] compare:[NSNumber numberWithInt:[obj1.price intValue]]];;
    }];
    self.priceHighScore =[self.resultArray sortedArrayUsingComparator:^NSComparisonResult(Travel  *obj1, Travel *obj2) {
        return [obj2.satisfaction compare:obj1.satisfaction];
    }];
    self.lowPriceHighScore =[self.lowPriceScore sortedArrayUsingComparator:^NSComparisonResult(Travel  *obj1, Travel *obj2) {
        return [obj2.satisfaction  compare:obj1.satisfaction];
    }];
    self.highPriceHighScore =[self.highPriceScore sortedArrayUsingComparator:^NSComparisonResult(Travel  *obj1, Travel *obj2) {
        return [obj2.satisfaction compare:obj1.satisfaction];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏主题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回键字体的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"搜索结果";
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    [self.tableView reloadData];
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
             [self.cityName setTitle:city forState:UIControlStateNormal];
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

-(void)cityViewController:(CityViewController *)cityVC didCity:(NSString *)cityName{
    [self.cityName setTitle:cityName forState:UIControlStateNormal];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.travel = self.resultArray[indexPath.row];
    static NSString *CellIdentifier = @"travelTableViewCell";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"TravelTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    TravelTableViewCell *cell = (TravelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString: self.travel.imageNames]];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.backgroundView =[[UIImageView alloc]initWithImage:[UIImage imageWithData:data]];
        });
    });
    cell.travel = self.travel;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AccommodationDeViewController *vc = [[AccommodationDeViewController alloc]init];
    vc.travelCityName = self.cityName.titleLabel.text;
    self.travel = self.resultArray[indexPath.row];
    vc.traveURL = self.travel.detailed;
    vc.isViewContrller = @"自助游";
    vc.travelName = self.travel.traveName;
    vc.travel = self.travel;
    vc.resultDatas = self.resultDatas;
    if ([self.isViewController isEqualToString:@"添加自助旅游"]) {
        vc.isAddView = @"添加自助旅游";
    }
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)priceSort:(UIButton *)sender {
    isSelectPrice++;
    [UIView animateWithDuration:0.5 animations:^{
        self.priceView.alpha = 0;
    }];
    [self.sortResult setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    
    [sender setTitle:self.sortResult.titleLabel.text forState:UIControlStateNormal];
    if ([sender.titleLabel.text isEqualToString:@"低价优先"]) {
        [self.resultArray  removeAllObjects];
//        NSLog(@"评分：%@",self.scoreResult.titleLabel.text);
        if ([self.scoreResult.titleLabel.text isEqualToString:@"评分排序"]) {
            self.resultArray = [NSMutableArray arrayWithArray:self.lowPriceScore];
            [self.tableView reloadData];
        }
        else{
            self.resultArray = [NSMutableArray arrayWithArray:self.lowPriceHighScore];
            [self.tableView reloadData];
            
        }
    }
    else if ([sender.titleLabel.text isEqualToString:@"高价优先"]) {
        [self.resultArray  removeAllObjects];
        if ([self.scoreResult.titleLabel.text isEqualToString:@"评分排序"]) {
            self.resultArray = [NSMutableArray arrayWithArray:self.highPriceScore];
            [self.tableView reloadData];
        }
        else{
            self.resultArray = [NSMutableArray arrayWithArray:self.highPriceHighScore];
            [self.tableView reloadData];
            
        }
    }
    
    else if ([sender.titleLabel.text isEqualToString:@"价格排序"]) {
        if ([self.scoreResult.titleLabel.text isEqualToString:@"评分排序"]) {
            self.resultArray = self.result;
            [self.tableView reloadData];
        }
        else{
            self.resultArray = [NSMutableArray arrayWithArray:self.priceHighScore];
            [self.tableView reloadData];
        }
    }
}

static int isSelectPrice;
- (IBAction)sortResult:(UIButton *)sender{
    if (isSelectPrice%2==0) {
        [UIView animateWithDuration:1.0 animations:^{
            self.priceView.alpha = 1;
        }];
    }
    else{
        [UIView animateWithDuration:1.0 animations:^{
            self.priceView.alpha = 0;
        }];
    }
    isSelectPrice++;
}
static int isSelectScore;
- (IBAction)scoreResult:(UIButton *)sender {
    if (isSelectScore%2==0) {
        [UIView animateWithDuration:1.0 animations:^{
            self.scoreView.alpha = 1;
        }];
    }
    else{
        [UIView animateWithDuration:1.0 animations:^{
            self.scoreView.alpha = 0;
        }];
    }
    isSelectScore++;
}

- (IBAction)scoreSort:(UIButton *)sender {
    isSelectScore++;
    [self.scoreResult setTitle:self.highScoreBtn.titleLabel.text forState:UIControlStateNormal];
    
    [self.highScoreBtn setTitle:self.sortResult.titleLabel.text forState:UIControlStateNormal];
    if ([sender.titleLabel.text isEqualToString:@"评分排序"]) {
        
        if ([self.sortResult.titleLabel.text isEqualToString:@"价格排序"]) {
            [self.resultArray  removeAllObjects];
            self.resultArray = self.result;
            [self.tableView reloadData];
        }
        else if ([self.sortResult.titleLabel.text isEqualToString:@"低价优先"]) {
            [self.resultArray  removeAllObjects];
            self.resultArray = [NSMutableArray arrayWithArray:self.lowPriceScore];
            [self.tableView reloadData];
        }
        else {
            self.resultArray = [NSMutableArray arrayWithArray:self.highPriceScore];
            [self.tableView reloadData];
        }
    }
    else if ([sender.titleLabel.text isEqualToString:@"高评分优先"]) {
        [self.resultArray  removeAllObjects];
        if ([self.sortResult.titleLabel.text isEqualToString:@"价格排序"]) {
            self.resultArray = [NSMutableArray arrayWithArray:self.priceHighScore];
            [self.tableView reloadData];
        }
        else if ([self.sortResult.titleLabel.text isEqualToString:@"低价优先"]) {
            self.resultArray = [NSMutableArray arrayWithArray:self.lowPriceHighScore];
            [self.tableView reloadData];
        }
        else {
            self.resultArray = [NSMutableArray arrayWithArray:self.highPriceHighScore];
            [self.tableView reloadData];
        }
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.scoreView.alpha = 0;
    }];
    
}
- (IBAction)cityName:(UIButton *)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CityViewController *cityVC = [story instantiateViewControllerWithIdentifier:@"city"];
    cityVC.delegate = self;
    [self.navigationController pushViewController:cityVC animated:YES];
}
@end