//
//  CustomTourViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/19.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "CustomTourViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+Extension.h"
#import "CityViewController.h"
#import "SZCalendarPicker.h"

@interface CustomTourViewController ()<UITextViewDelegate,UITextFieldDelegate,CLLocationManagerDelegate,CityViewControllerDelegate,clickSureDelegate>{
    UIScrollView *scrollerView;
}

//定义定位属性
@property(nonatomic,retain)CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIButton *startCity;//出发地
@property (weak, nonatomic) IBOutlet UIButton *destinationCity;//目的地
@property (weak, nonatomic) IBOutlet UIButton *dateTime;//出发日期
@property (strong,nonatomic)NSString *time;
@property (weak, nonatomic) IBOutlet UILabel *travelDay;//出游天数
@property (weak, nonatomic) IBOutlet UILabel *travelPeopel;//出游人数
@property (weak, nonatomic) IBOutlet UILabel *travelPrice;//出游价格
@property (weak, nonatomic) IBOutlet UITextView *otherNeed;//其他补充
@property (weak, nonatomic) IBOutlet UITextField *name;//姓名
@property (weak, nonatomic) IBOutlet UITextField *phone;//手机
@property (weak, nonatomic) IBOutlet UITextField *mailbox;//邮箱

//出发地事件
- (IBAction)startCity:(UIButton *)sender;
//目的地事件
- (IBAction)destinationCity:(UIButton *)sender;
//时间事件
- (IBAction)dateTime:(UIButton *)sender;
//出游天数加减事件
- (IBAction)travelDay:(UIButton *)sender;
//出游人数加减事件
- (IBAction)travelPeopel:(UIButton *)sender;
//出游价格加减事件
- (IBAction)travelPrice:(UIButton *)sender;
//提交定制事件
- (IBAction)submit:(UIButton *)sender;

@end

@implementation CustomTourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //主的scrollview
    scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //设置溢出区的范围,弹跳效果
    scrollerView.bounces = NO;
    [self.view addSubview:scrollerView];
    // 隐藏水平滚动条
    scrollerView.showsHorizontalScrollIndicator = NO;
    scrollerView.showsVerticalScrollIndicator = NO;
    NSArray *views = [[NSBundle mainBundle]loadNibNamed:@"CustomTourView" owner:self options:nil];
    UIView *view1 = views[0];
    view1.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,view1.frame.size.height);
    [scrollerView addSubview:view1];
    scrollerView.contentSize = CGSizeMake(view1.frame.size.width, view1.frame.size.height);
    self.otherNeed.delegate = self;
    self.name.delegate = self;
    self.phone.delegate = self;
    self.mailbox.delegate = self;
    self.name.clearsOnBeginEditing = YES;
    self.phone.clearsOnBeginEditing = YES;
    self.mailbox.clearsOnBeginEditing = YES;
    [self locate];
    [MBProgressHUD showMessage:@"正在获取当前位置...."];
    //发送网络请求
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUD];
    });
    //点击其他地方键盘收起来
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
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
    self.title = @"定制游";
}
#pragma mark -- 点击其他地方收起键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.otherNeed resignFirstResponder];
    [self.name resignFirstResponder];
    [self.phone resignFirstResponder];
    [self.mailbox resignFirstResponder];
    if (istextView == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            scrollerView.contentOffset =  CGPointMake(0,0);
        }];
        istextView = 0;
    }
    if (istextField == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            scrollerView.contentOffset =  CGPointMake(0,100);
        }];
        istextField = 0;
    }
}
#pragma mark -- 点击回车收起键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (istextField == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            scrollerView.contentOffset =  CGPointMake(0,100);
        }];
        istextField = 0;
    }
    return YES;
}
#pragma mark -- 输入框限制
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *txt = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([textField isEqual:self.phone]) {
        if(txt.length >= 12){
            [MBProgressHUD showError:@"已达到最大个数。"];
            return NO;
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *resultStr = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL result = [string isEqualToString:resultStr];
        return result;
    }
    return YES;
}
#pragma mark - 点击输入框键盘弹起
static int istextView;
static int istext=0;
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (istext == 0) {
        self.otherNeed.text= @"";
        istext++;
    }
    [UIView animateWithDuration:0.5 animations:^{
        scrollerView.contentOffset =  CGPointMake(0,200);
    }];
    istextView = 1;
}
static int istextField;
-(void)textFieldDidBeginEditing:(UITextField *)textField{
        [UIView animateWithDuration:0.5 animations:^{
            scrollerView.contentOffset =  CGPointMake(0,300);
        }];
    istextField = 1;
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
             [self.startCity setTitle:city forState:UIControlStateNormal];
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

- (IBAction)startCity:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CityViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"city"];
    vc.delegate = self;
    vc.from = FromTravelBegin;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)destinationCity:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CityViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"city"];
    vc.delegate = self;
    vc.from = FromTravelEnd;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)cityViewController:(CityViewController *)cityVC didCity:(NSString *)cityName{
    if (cityVC.from == FromTravelBegin) {
        [self.startCity setTitle:cityName forState:UIControlStateNormal];
    }
    else if (cityVC.from == FromTravelEnd){
        [self.destinationCity setTitle:cityName forState:UIControlStateNormal];
    }
}

- (IBAction)dateTime:(UIButton *)sender {
    SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    //设置日历的位置
    calendarPicker.frame = CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height-260);
    calendarPicker.delegate = self;
    
    calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        NSString *day1 = [NSString string];
        NSString *month1 = [NSString string];
        if(day<10){
            day1 = [NSString stringWithFormat:@"0%ld",(long)day];
        }
        else{
            day1 = [NSString stringWithFormat:@"%ld",(long)day];
        }
        if(month<10){
            month1 = [NSString stringWithFormat:@"0%ld",(long)month];
        }
        else{
            month1 = [NSString stringWithFormat:@"%ld",(long)month];
        }
        self.time = [NSString stringWithFormat:@"%li-%@-%@", (long)year,month1,day1];
    };
}
-(void)selectSureBtnClick:(UIButton *)sender{
    [self.dateTime setTitle:self.time forState:UIControlStateNormal];
}
static int day = 3;
- (IBAction)travelDay:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"-"]) {
        if (day <=0) {
            [MBProgressHUD showError:@"不能再减了"];
            return;
        }
        day--;
        self.travelDay.text = [NSString stringWithFormat:@"%d",day];
    }
    else {
        day++;
        self.travelDay.text = [NSString stringWithFormat:@"%d",day];
    }
}
static int people = 10;
- (IBAction)travelPeopel:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"-"]) {
        if (people <=1) {
            [MBProgressHUD showError:@"不能再减了"];
            return;
        }
        people = people - 2;
        self.travelPeopel.text = [NSString stringWithFormat:@"%d",people];
    }
    else {
        people = people + 2;
        self.travelPeopel.text = [NSString stringWithFormat:@"%d",people];
    }
}
static int price = 200;
- (IBAction)travelPrice:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"-"]) {
        if (price <50) {
            [MBProgressHUD showError:@"不能再减了"];
            return;
        }
        price = price - 50;
        self.travelPrice.text = [NSString stringWithFormat:@"%d",price];
    }
    else {
        price = price + 50;
        self.travelPrice.text = [NSString stringWithFormat:@"%d",price];
    }
}

- (IBAction)submit:(UIButton *)sender {
    if ([self.startCity.titleLabel.text isEqualToString:@"点击获取城市"]) {
        [MBProgressHUD showError:@"请选择城市"];
        return;
    }
    if ([self.destinationCity.titleLabel.text isEqualToString:@"点击获取城市"]) {
        [MBProgressHUD showError:@"请选择城市"];
        return;
    }
    if ([self.dateTime.titleLabel.text isEqualToString:@"点击获取日期"]) {
        [MBProgressHUD showError:@"请选择日期"];
        return;
    }
    if ([self.travelDay.text isEqualToString:@"0"]) {
        [MBProgressHUD showError:@"天数不能为0"];
        return;
    }
    if ([self.travelPeopel.text isEqualToString:@"0"]) {
        [MBProgressHUD showError:@"人数不能为0"];
        return;
    }
    if ([self.travelPrice.text isEqualToString:@"0"]) {
        [MBProgressHUD showError:@"价格不能为0"];
        return;
    }
    if ([self.otherNeed.text isEqualToString:@""] || [self.otherNeed.text isEqualToString:@"还有什么需求补充吗？（请输入）"]) {
        self.otherNeed.text = @"无其他需求！";
    }
    if ([self.name.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"名字不能为空"];
        return;
    }
    if ([self.phone.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"手机不能为空"];
        return;
    }
    if ([self.mailbox.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"邮箱不能为空"];
        return;
    }
    BmobUser *user = [BmobUser getCurrentUser];
    BmobObject *obj = [BmobObject objectWithClassName:@"CustomTour"];
    [obj setObject:user.username forKey:@"userID"];
    [obj setObject:self.startCity.titleLabel.text forKey:@"startCity"];
    [obj setObject:self.destinationCity.titleLabel.text forKey:@"destinationCity"];
    [obj setObject:self.dateTime.titleLabel.text forKey:@"dateTime"];
    [obj setObject:self.travelDay.text forKey:@"travelDay"];
    [obj setObject:self.travelPeopel.text forKey:@"travelPeopel"];
    [obj setObject:self.travelPrice.text forKey:@"travelPrice"];
    [obj setObject:self.otherNeed.text forKey:@"otherNeed"];
    [obj setObject:self.name.text forKey:@"name"];
    [obj setObject:self.phone.text forKey:@"phone"];
    [obj setObject:self.mailbox.text forKey:@"mailbox"];
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [MBProgressHUD showSuccess:@"系统已收，会尽快制定！"];
        }
    }];
}
@end
