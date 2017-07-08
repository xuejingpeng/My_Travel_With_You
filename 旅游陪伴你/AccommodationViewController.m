//
//  AccommodationViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/1/4.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "AccommodationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD+Extension.h"
#import "CityViewController.h"
#import "SZCalendarPicker.h"
#import "ResultAccommodationViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobProFile.h>
#import "Accommodation.h"

@interface AccommodationViewController ()<CLLocationManagerDelegate,CityViewControllerDelegate,clickSureDelegate>

@property(strong,nonatomic)NSMutableArray *array;
@property(strong,nonatomic)NSArray *allArray;
//选择地点
@property (weak, nonatomic) IBOutlet UIButton *destinationBtn;
//定义定位属性
@property(nonatomic,retain)CLLocationManager *locationManager;

//我所在的位置
- (IBAction)selectCurrentCity:(UIButton *)sender;
//入住时间
@property (weak, nonatomic) IBOutlet UIButton *checkIntTime;
- (IBAction)checkIntTime:(UIButton *)sender;
//离店时间
@property (weak, nonatomic) IBOutlet UIButton *checkOutTime;
- (IBAction)checkOutTime:(UIButton *)sender;

//存储时间
@property (strong,nonatomic) NSString *date;

//价格
@property (weak, nonatomic) IBOutlet UIButton *priceBtn;
- (IBAction)priceBtn:(UIButton *)sender;
@property (nonatomic , strong)IBOutlet UIView *mask;
- (IBAction)selectPriceBtn:(UIButton *)sender;
//查询
- (IBAction)query:(UIButton *)sender;

@end

@implementation AccommodationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.date = [[NSString alloc]init];
    [self addTap];
    self.array = [NSMutableArray array];
    self.allArray= [NSArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.title = @"住宿查询";
    self.tabBarController.tabBar.hidden = YES;
}

- (IBAction)selectCurrentCity:(UIButton *)sender {
    [self locate];
    [MBProgressHUD showMessage:@"正在获取当前位置...."];
    //发送网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
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
             [self.destinationBtn setTitle:cc forState:UIControlStateNormal];
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
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [super prepareForSegue:segue sender:sender];
    UIViewController *vc =  segue.destinationViewController;
    if ([vc isKindOfClass:[CityViewController class]]) {
        CityViewController *cityVC = segue.destinationViewController;
        cityVC.delegate = self;
    }
}

-(void)cityViewController:(CityViewController *)cityVC didCity:(NSString *)cityName{
    [self.destinationBtn setTitle:cityName forState:UIControlStateNormal];
}
- (IBAction)checkIntTime:(UIButton *)sender {
    SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    //设置日历的位置
    calendarPicker.frame = CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height-260);
    calendarPicker.delegate = self;
    
    calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        self.date = [NSString stringWithFormat:@"%li 年 %li 月 %li 日", (long)year,(long)month,(long)day];
    };
    calendarPicker.sureBtn.tag = 1;
}

-(void)selectSureBtnClick:(UIButton *)sender{
    if (sender.tag == 1) {
        [self.checkIntTime setTitle:self.date forState:UIControlStateNormal];
    }
    else if(sender.tag == 2){
        [self.checkOutTime setTitle:self.date forState:UIControlStateNormal];
    }
    
}
- (IBAction)checkOutTime:(UIButton *)sender {
    if ([self.checkIntTime.titleLabel.text isEqualToString:@"点击获得入住时间"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请先选择入住时间" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    else{
        SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
        //日期格式
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy 年 MM 月 dd 日"];
        //把字符串变成NSDate
        NSDate *destDate = [formatter dateFromString:self.date];
        //把NSDate多加8个小时
        NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
        NSInteger frominterval = [fromzone secondsFromGMTForDate: destDate];
        NSDate *fromDate = [destDate  dateByAddingTimeInterval: frominterval];
        //把NSDate的时间多加一天
        NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([fromDate timeIntervalSinceReferenceDate] + 24*3600)];
        calendarPicker.today = newDate;
        calendarPicker.date = calendarPicker.today;
        //设置日历的位置
        calendarPicker.frame = CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height-260);
        calendarPicker.delegate = self;
        calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
            self.date = [NSString stringWithFormat:@"%li 年 %li 月 %li 日", (long)year,(long)month,(long)day];
        };
        calendarPicker.sureBtn.tag = 2;
    }
}
- (IBAction)priceBtn:(UIButton *)sender {
    self.mask.alpha = 1;
}
- (void)addTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.mask addGestureRecognizer:tap];
}
//隐藏界面
- (void)hide
{
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.mask.alpha = 0;
    }];
}
- (IBAction)selectPriceBtn:(UIButton *)sender {
    [self.priceBtn setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    self.mask.alpha = 0;
}

- (IBAction)query:(UIButton *)sender {
    if ([self.destinationBtn.titleLabel.text isEqualToString:@"点击选择地点"]) {
        [MBProgressHUD showError:@"城市不能为空"];
        return;
    }
    if([self.checkIntTime.titleLabel.text isEqualToString:@"点击获得入住时间"]){
        [MBProgressHUD showError:@"入住时间不能为空"];
        return;
    }
    if ([self.checkOutTime.titleLabel.text isEqualToString:@"点击获得离店时间"]) {
        [MBProgressHUD showError:@"离店时间不能为空"];
        return;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy 年 MM 月 dd 日"];
    NSDate *date1= [dateFormatter dateFromString:self.checkIntTime.titleLabel.text];
    NSDate *date2 = [dateFormatter dateFromString:self.checkOutTime.titleLabel.text];
    NSTimeInterval time = [date2 timeIntervalSinceDate:date1];
    int  day = ((int)time)/(3600*24);
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"accommodation"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            self.allArray = array;
        if ([self.priceBtn.titleLabel.text isEqualToString: @"点击获得价格选项"] || [self.priceBtn.titleLabel.text isEqualToString: @"价格不限"]) {
            [self.array  removeAllObjects];
            for (BmobObject *obj in self.allArray) {
                if ([self.destinationBtn.titleLabel.text isEqualToString:[obj objectForKey:@"destination"]]) {
                    NSDictionary *dic = @{@"price":[obj objectForKey:@"price"],
                                          @"imageName":[obj objectForKey:@"imageName"],
                                          @"address":[obj objectForKey:@"address"],
                                          @"hotelName":[obj objectForKey:@"hotelName"],
                                          @"score":[obj objectForKey:@"score"],
                                          @"URL":[obj objectForKey:@"URL"]};
                    Accommodation *accommodation = [[Accommodation alloc]initWithDictionary:dic];
                    [self.array addObject:accommodation];
                }
            }
        }
        else if ([self.priceBtn.titleLabel.text isEqualToString:@"￥100以下"]){
            [self.array  removeAllObjects];
            for (BmobObject *obj in self.allArray) {
                if ([self.destinationBtn.titleLabel.text isEqualToString:[obj objectForKey:@"destination"]]) {
                    if ([[obj objectForKey:@"price"] intValue]<100) {
                        NSDictionary *dic = @{@"price":[obj objectForKey:@"price"],
                                              @"imageName":[obj objectForKey:@"imageName"],
                                              @"address":[obj objectForKey:@"address"],
                                              @"hotelName":[obj objectForKey:@"hotelName"],
                                              @"score":[obj objectForKey:@"score"],
                                              @"URL":[obj objectForKey:@"URL"]};
                        Accommodation *accommodation = [[Accommodation alloc]initWithDictionary:dic];
                        [self.array addObject:accommodation];
                    }
                }
            }
        }
        else if ([self.priceBtn.titleLabel.text isEqualToString:@"￥100-￥150"]){
            [self.array  removeAllObjects];
            for (BmobObject *obj in self.allArray) {
                if ([self.destinationBtn.titleLabel.text isEqualToString:[obj objectForKey:@"destination"]]) {
                    if ([[obj objectForKey:@"price"] intValue]>100 &&[[obj objectForKey:@"price"] intValue]<150) {
                        NSDictionary *dic = @{@"price":[obj objectForKey:@"price"],
                                              @"imageName":[obj objectForKey:@"imageName"],
                                              @"address":[obj objectForKey:@"address"],
                                              @"hotelName":[obj objectForKey:@"hotelName"],
                                              @"score":[obj objectForKey:@"score"],
                                              @"URL":[obj objectForKey:@"URL"]};
                        Accommodation *accommodation = [[Accommodation alloc]initWithDictionary:dic];
                        [self.array addObject:accommodation];
                    }
                }
            }
        }
        else if ([self.priceBtn.titleLabel.text isEqualToString:@"￥150-￥200"]){
            [self.array  removeAllObjects];
            for (BmobObject *obj in self.allArray) {
                if ([self.destinationBtn.titleLabel.text isEqualToString:[obj objectForKey:@"destination"]]) {
                    if ([[obj objectForKey:@"price"] intValue]>150 &&[[obj objectForKey:@"price"] intValue]<200) {
                        NSDictionary *dic = @{@"price":[obj objectForKey:@"price"],
                                              @"imageName":[obj objectForKey:@"imageName"],
                                              @"address":[obj objectForKey:@"address"],
                                              @"hotelName":[obj objectForKey:@"hotelName"],
                                              @"score":[obj objectForKey:@"score"],
                                              @"URL":[obj objectForKey:@"URL"]};
                        Accommodation *accommodation = [[Accommodation alloc]initWithDictionary:dic];
                        [self.array addObject:accommodation];
                    }
                }
            }
        }
        else if ([self.priceBtn.titleLabel.text isEqualToString:@"￥200-￥300"]){
            [self.array  removeAllObjects];
            for (BmobObject *obj in self.allArray) {
                if ([self.destinationBtn.titleLabel.text isEqualToString:[obj objectForKey:@"destination"]]) {
                    if ([[obj objectForKey:@"price"] intValue]>200 &&[[obj objectForKey:@"price"] intValue]<300) {
                        NSDictionary *dic = @{@"price":[obj objectForKey:@"price"],
                                              @"imageName":[obj objectForKey:@"imageName"],
                                              @"address":[obj objectForKey:@"address"],
                                              @"hotelName":[obj objectForKey:@"hotelName"],
                                              @"score":[obj objectForKey:@"score"],
                                              @"URL":[obj objectForKey:@"URL"]};
                        Accommodation *accommodation = [[Accommodation alloc]initWithDictionary:dic];
                        [self.array addObject:accommodation];
                    }
                }
            }
        }
        else if ([self.priceBtn.titleLabel.text isEqualToString:@"￥300以上"]){
            [self.array  removeAllObjects];
            for (BmobObject *obj in self.allArray) {
                if ([self.destinationBtn.titleLabel.text isEqualToString:[obj objectForKey:@"destination"]]) {
                    if ([[obj objectForKey:@"price"] intValue]>300) {
                        NSDictionary *dic = @{@"price":[obj objectForKey:@"price"],
                                              @"imageName":[obj objectForKey:@"imageName"],
                                              @"address":[obj objectForKey:@"address"],
                                              @"hotelName":[obj objectForKey:@"hotelName"],
                                              @"score":[obj objectForKey:@"score"],
                                              @"URL":[obj objectForKey:@"URL"]};
                        Accommodation *accommodation = [[Accommodation alloc]initWithDictionary:dic];
                        [self.array addObject:accommodation];
                    }
                }
            }
        }
        [bquery clearCachedResult];
        ResultAccommodationViewController *vc = [[ResultAccommodationViewController alloc]init];
        vc.dayNum = day;
        vc.resultArray = self.array;
        vc.cityName = self.destinationBtn.titleLabel.text;
        [self.navigationController pushViewController:vc animated:YES];
        }];
    
}


@end
