//
//  WeatherViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/17.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "WeatherViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD+Extension.h"
#import "ApiStoreSDK.h"
#import "DailyForecast.h"
#import "HourlyForecast.h"
#import "NowWeather.h"
#import "WeatherResultsViewController.h"
#import "DataServers.h"

@interface WeatherViewController ()<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *cityName;
//定义定位属性
@property (nonatomic,retain)CLLocationManager *locationManager;

//存储城市
@property (strong,nonatomic)NSMutableDictionary *city;

@property (strong,nonatomic)NSMutableArray *dailyForecasts;//几天的天气数据的数组
@property (strong,nonatomic)NowWeather *now;
@property (strong,nonatomic)DataServers *data;

- (IBAction)currentLocation:(UIButton *)sender;

- (IBAction)searchWeather:(UIButton *)sender;

@end

@implementation WeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [[DataServers alloc]init];
    UIImageView *image = [[UIImageView alloc]initWithFrame:self.view.bounds];
    image.image = [UIImage imageNamed:@"10340884"];
    [self.view addSubview:image];
    self.city = [[NSMutableDictionary alloc]init];
    self.dailyForecasts = [[NSMutableArray alloc]init];
//    self.hourlyForecasts = [[NSMutableArray alloc]init];
    self.now = [[NowWeather alloc]init];
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
    self.title = @"城市的输入";
    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)currentLocation:(UIButton *)sender {
    [self locate];
    [MBProgressHUD showMessage:@"正在获取当前位置...."];
    //发送网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
}

- (IBAction)searchWeather:(UIButton *)sender {
    if ([self.cityName.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请输入城市" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    NSString *httpUrl =  @"http://apis.baidu.com/heweather/weather/free";
    NSString *city = [self.cityName.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr = [[NSString alloc]initWithFormat:@"%@?city=%@",httpUrl,city];
    [self.data gainData:urlStr andBlock:^(NSDictionary *resultDic) {
        NSArray *array = [NSArray array];
        array = [resultDic valueForKey:@"HeWeather data service 3.0"];
        NSArray *dayArray = [array[0]valueForKey:@"daily_forecast"];
        for (int i = 0; i<dayArray.count; i++) {
            DailyForecast *day = [[DailyForecast alloc]init];
            day.sr = [[dayArray[i] valueForKey:@"astro"]valueForKey:@"sr"];
            day.ss = [[dayArray[i] valueForKey:@"astro"]valueForKey:@"ss"];
            day.txt_d = [[dayArray[i] valueForKey:@"cond"]valueForKey:@"txt_d"];
            day.txt_n = [[dayArray[i] valueForKey:@"cond"]valueForKey:@"txt_n"];
            day.date = [dayArray[i] valueForKey:@"date"];
            day.max = [[dayArray[i] valueForKey:@"tmp"] valueForKey:@"max"];
            day.min = [[dayArray[i] valueForKey:@"tmp"] valueForKey:@"min"];
            if (i == 0) {
                _now.daily = day;
            }
            else{
                [self.dailyForecasts addObject:day];
            }
        }
            NSDictionary *nowDic = [array[0] valueForKey:@"now"];
            _now.txt = [[nowDic valueForKey:@"cond"]valueForKey:@"txt"];
            _now.fl = [nowDic valueForKey:@"fl"];
            _now.hum = [nowDic valueForKey:@"hum"];
            _now.pcpn = [nowDic valueForKey:@"pcpn"];
            _now.pres = [nowDic valueForKey:@"pres"];
            _now.tmp = [nowDic valueForKey:@"tmp"];
            _now.dir = [[nowDic valueForKey:@"wind"] valueForKey:@"dir"];
            _now.sc = [[nowDic valueForKey:@"wind"] valueForKey:@"sc"];
            NSDictionary *suggestion = [array[0] valueForKey:@"suggestion"];
            _now.comf_brf = [[suggestion valueForKey:@"comf"] valueForKey:@"brf"];
            _now.comf_txt = [[suggestion valueForKey:@"comf"] valueForKey:@"txt"];
            _now.trav_brf = [[suggestion valueForKey:@"trav"] valueForKey:@"brf"];
            _now.trav_txt = [[suggestion valueForKey:@"trav"] valueForKey:@"txt"];
            _now.drsg_brf = [[suggestion valueForKey:@"drsg"] valueForKey:@"brf"];
            _now.drsg_txt = [[suggestion valueForKey:@"drsg"] valueForKey:@"txt"];
            _now.flu_brf = [[suggestion valueForKey:@"flu"] valueForKey:@"brf"];
            _now.flu_txt = [[suggestion valueForKey:@"flu"] valueForKey:@"txt"];
            _now.sport_brf = [[suggestion valueForKey:@"sport"] valueForKey:@"brf"];
            _now.sport_txt = [[suggestion valueForKey:@"sport"] valueForKey:@"txt"];
    }];
    if (self.dailyForecasts.count != 0) {
        [MBProgressHUD showMessage:[NSString stringWithFormat:@"正在获取%@的天气数据",self.cityName.text]];
        //发送网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            WeatherResultsViewController *vc = [[WeatherResultsViewController alloc]init];
            vc.cityName = self.cityName.text;
            vc.dailyForecasts = self.dailyForecasts;
            vc.nowWeather = self.now;
            [self.navigationController pushViewController:vc animated:YES];
        });
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
//             NSLog(@"4%@",placemark.locality);//获取市级地点
//             NSLog(@"5%@",placemark.subLocality);//获取市以下级的地点。
//             NSLog(@"6%@",placemark.administrativeArea);//获取省份
 
             //获取城市
             NSString *city = placemark.locality;
             if (!city) {
                 //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                 city = placemark.administrativeArea;
             }
             NSString *cc = [city substringToIndex:[city length] - 1];
             self.cityName.text = cc;
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
@end
