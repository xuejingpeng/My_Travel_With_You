//
//  HomeScreenViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/1/3.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "HomeScreenViewController.h"
#import "LoopView.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD+Extension.h"
#import "ApiStoreSDK.h"
#import "ScenicSpot.h"
#import "ScenicSpotsViewController.h"
#import "DataServers.h"
#import "TravelViewController.h"
#import <BmobSDK/Bmob.h>
#import "Travel.h"
#import "ScenicSpotDtailed.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "Food.h"
#import "DeliciouFoodViewController.h"

@interface HomeScreenViewController ()<UIScrollViewDelegate,CLLocationManagerDelegate>{
    BOOL _isOrder;
    CGFloat width;
    NSTimer *myTimer;//定时器
    int imageCount;
    LoopView *loopView;
    double longitude;//经度
    double latitude;//纬度
    
}
//定义定位属性
@property(nonatomic,strong)NSString *cityName;
@property(nonatomic,retain)CLLocationManager *locationManager;
@property(strong,nonatomic)NSMutableArray *scenicSpots;
@property (strong,nonatomic)NSMutableArray *allArray;
@property(strong,nonatomic)DataServers *data;
@property(strong,nonatomic)NSMutableArray *resultArray;
- (IBAction)leftToTravel:(UIButton *)sender;
- (IBAction)leftToScenic:(UIButton *)sender;
- (IBAction)leftToFood:(UIButton *)sender;


@end

@implementation HomeScreenViewController

//加载界面进来

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.allArray = [NSMutableArray array];
    width = [UIScreen mainScreen].bounds.size.width;
    self.resultArray = [NSMutableArray array];
    // Do any additional setup after loading the view.
    loopView = [[LoopView alloc]initWithFrame:CGRectMake(0, 0, width,120)];
    [self.view addSubview:loopView];
    loopView.scrollView.delegate = self;
    
    imageCount = (int)loopView.imageArray.count;
    [loopView.pageControl addTarget:self action:@selector(handlePageControl:) forControlEvents:UIControlEventValueChanged];
    _isOrder = YES;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changePage) userInfo:nil repeats:YES];
    self.data = [[DataServers alloc]init];
    [self locate];
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
    longitude = currentLocation.coordinate.longitude;
    latitude = currentLocation.coordinate.latitude;
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
             self.cityName = [city substringToIndex:[city length]];
             
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

#pragma mark - 滑动结束后判断页数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UIPageControl *pageControl = (UIPageControl *)[loopView viewWithTag:100];
    int currentPage = scrollView.contentOffset.x / width;
    
    if (currentPage == 0) {
        [scrollView setContentOffset:CGPointMake(width * imageCount, 0) animated:NO];
        pageControl.currentPage = imageCount;
    }
    //判断是否滑动最后一个
    else if (currentPage == imageCount) {
        [scrollView setContentOffset:CGPointMake(width, 0) animated:NO];
        pageControl.currentPage = 0;
        
    } else {
        pageControl.currentPage = currentPage - 1;
    }
}
#pragma mark - 点击pageControl来跳转到相应位置
- (void)handlePageControl:(UIPageControl *)pageControl
{
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:200];
    [scrollView setContentOffset:CGPointMake(width * (pageControl.currentPage + 1), 0) animated:YES];
}

#pragma mark - 自动跳转判断页数
- (void)changePage
{
     int page = (int)loopView.pageControl.currentPage;
     page++;
     page = page > imageCount-1 ? 0 : page;
     loopView.pageControl.currentPage = page;
     if (page) {
     [loopView.scrollView setContentOffset:CGPointMake(width * (page + 1), 0) animated:YES];
     } else {
     [loopView.scrollView setContentOffset:CGPointMake(width * (page + 1), 0) animated:NO];
     }
}
-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏的隐藏
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    self.title = @"首页";
    self.scenicSpots = [NSMutableArray array];
    //设置导航栏的出现
//    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leftToTravel:(UIButton *)sender {
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Travel"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            [self.allArray  removeAllObjects];
            for (BmobObject *obj in array) {
                Travel *travel = [[Travel alloc]init];
                travel.traveName = [obj objectForKey:@"travelName"];
                travel.price = [obj objectForKey:@"price"];
                travel.satisfaction = [obj objectForKey:@"satisfaction"];
                travel.likeCount = [obj objectForKey:@"likeCount"];
                travel.commentCount = [obj objectForKey:@"commentCount"];
                travel.where = [obj objectForKey:@"where"];
                travel.dayCount = [obj objectForKey:@"dayCount"];
                travel.detailed = [obj objectForKey:@"detailed"];
                travel.imageNames = [obj objectForKey:@"imageNames"];
                [self.allArray addObject:travel];
        }
        
        TravelViewController *VC = [[TravelViewController alloc]initWithNibName:@"TravelViewController" bundle:nil];
        VC.resultArray = self.allArray;
        [self.navigationController pushViewController:VC animated:YES];
     
    }];
}

- (IBAction)leftToScenic:(UIButton *)sender {
    [MBProgressHUD showMessage:@"正在搜索中...."];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Scenc"];
    bquery.limit =1000;
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            ScenicSpot *scenic = [[ScenicSpot alloc]init];
            scenic.address = [obj objectForKey:@"address"];
            scenic.spotName = [obj objectForKey:@"spotName"];
            scenic.productId = [obj objectForKey:@"productId"];
            scenic.objectId = [obj objectId];
            [self.scenicSpots addObject:scenic];
        }
        [MBProgressHUD hideHUD];
        ScenicSpotsViewController *vc = [[ScenicSpotsViewController alloc]init];
        vc.scenicSpots = self.scenicSpots;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (IBAction)leftToFood:(UIButton *)sender {
    [MBProgressHUD showMessage:@"正在搜索"];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"city"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"city_name"] rangeOfString:self.cityName].location!= NSNotFound) {
                NSString *httpUrl =  @"http://apis.baidu.com/baidunuomi/openapi/searchdeals";
                NSString *httpArg = [NSString stringWithFormat:@"city_id=%ld&cat_ids=326&location=%.4f,%4f&radius=1500&page_size=20",[[obj objectForKey:@"city_id"]longValue],longitude,latitude];
                NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, httpArg];
                [self.data gainSynchronizationData:urlStr andBlock:^(NSDictionary *resultDic) {
                    NSArray *array1 = [NSArray array];
                    array1 = [resultDic valueForKey:@"data"];
                    if ([[resultDic valueForKey:@"data"] isKindOfClass:[NSNull class]]) {
                        
                    }
                    else{
                    NSArray *array = [NSArray array];
                    array = [[resultDic valueForKey:@"data"]valueForKey:@"deals"];
                    [self.resultArray removeAllObjects];
                    for (NSDictionary *dic in array) {
                        Food *food = [[Food alloc]initWithDictionary:dic];
                        [self.resultArray addObject:food];
                    }
                    }
                    [MBProgressHUD hideHUD];
                    DeliciouFoodViewController *vc = [[DeliciouFoodViewController alloc]init];
                    vc.resultArray = [NSMutableArray array];
                    vc.resultArray = self.resultArray;
                    vc.cityId = [[obj objectForKey:@"city_id"]longValue];
                    vc.cityName = self.cityName;
                    vc.urlStr = urlStr;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            }
        }
        
    }];
}
@end
