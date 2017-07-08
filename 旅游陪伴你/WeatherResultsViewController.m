//
//  WeatherResultsViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/19.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "WeatherResultsViewController.h"
#import "DailyForecast.h"
#import "WeatherTableViewCell.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+Extension.h"

@interface WeatherResultsViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UIScrollView *scrollerView;
}

@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *txt;
@property (weak, nonatomic) IBOutlet UILabel *tmp;
@property (weak, nonatomic) IBOutlet UILabel *week;
@property (weak, nonatomic) IBOutlet UILabel *max;
@property (weak, nonatomic) IBOutlet UILabel *min;
@property (weak, nonatomic) IBOutlet UILabel *sr;
@property (weak, nonatomic) IBOutlet UILabel *ss;
@property (weak, nonatomic) IBOutlet UILabel *txt_d;
@property (weak, nonatomic) IBOutlet UILabel *txt_n;
@property (weak, nonatomic) IBOutlet UILabel *fl;
@property (weak, nonatomic) IBOutlet UILabel *hum;
@property (weak, nonatomic) IBOutlet UILabel *pcpn;
@property (weak, nonatomic) IBOutlet UILabel *pres;
@property (weak, nonatomic) IBOutlet UILabel *dir;
@property (weak, nonatomic) IBOutlet UILabel *sc;

@property (weak, nonatomic) IBOutlet UILabel *trav_brf;
@property (weak, nonatomic) IBOutlet UILabel *trav_txt;

@property (weak, nonatomic) IBOutlet UILabel *comf_brf;
@property (weak, nonatomic) IBOutlet UILabel *comf_txt;

@property (weak, nonatomic) IBOutlet UILabel *drsg_brf;
@property (weak, nonatomic) IBOutlet UILabel *drsg_txt;

@property (weak, nonatomic) IBOutlet UILabel *flu_brf;
@property (weak, nonatomic) IBOutlet UILabel *flu_txt;

@property (weak, nonatomic) IBOutlet UILabel *sport_brf;
@property (weak, nonatomic) IBOutlet UILabel *sport_txt;
@property (weak, nonatomic) IBOutlet UITableView *dailyTableView;

@end

@implementation WeatherResultsViewController

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
    NSArray *views = [[NSBundle mainBundle]loadNibNamed:@"WeatherView" owner:self options:nil];
    UIView *view1 = views[0];
    view1.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,view1.frame.size.height);
    [scrollerView addSubview:view1];
    scrollerView.contentSize = CGSizeMake(view1.frame.size.width, view1.frame.size.height-55);
    
    self.cityNameLabel.text = self.cityName;
    self.txt.text = self.nowWeather.txt;
    self.tmp.text = self.nowWeather.tmp;
    NSArray *weekDay = [self.nowWeather.daily.date componentsSeparatedByString:@"-"];
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:[weekDay[2] intValue]];
    [_comps setMonth:[weekDay[1] intValue]];
    [_comps setYear:[weekDay[0] intValue]];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents =
    [gregorian components:NSWeekdayCalendarUnit fromDate:_date];
    int _weekday = (int)[weekdayComponents weekday];
    switch (_weekday) {
        case 1:
            self.week.text = @"星期日";
            break;
        case 2:
            self.week.text = @"星期一";
            break;
        case 3:
            self.week.text = @"星期二";
            break;
        case 4:
            self.week.text = @"星期三";
            break;
        case 5:
            self.week.text = @"星期四";
            break;
        case 6:
            self.week.text = @"星期五";
            break;
        case 7:
            self.week.text = @"星期六";
            break;
        default:
            break;
    }
//    NSLog(@"_weekday::%d",_weekday);
    self.max.text = self.nowWeather.daily.max;
    self.min.text = self.nowWeather.daily.min;
    self.sr.text = self.nowWeather.daily.sr;
    self.ss.text = self.nowWeather.daily.ss;
    self.txt_d.text = self.nowWeather.daily.txt_d;
    self.txt_n.text = self.nowWeather.daily.txt_n;
    self.fl.text = self.nowWeather.fl;
    self.hum.text = self.nowWeather.hum;
    self.pcpn.text = self.nowWeather.pcpn;
    self.pres.text = self.nowWeather.pres;
    self.dir.text = self.nowWeather.dir;
    self.sc.text = self.nowWeather.sc;
    
    self.trav_brf.text = self.nowWeather.trav_brf;
    self.trav_txt.text = self.nowWeather.trav_txt;
    
    self.comf_brf.text = self.nowWeather.comf_brf;
    self.comf_txt.text = self.nowWeather.comf_txt;
    
    self.drsg_brf.text = self.nowWeather.drsg_brf;
    self.drsg_txt.text = self.nowWeather.drsg_txt;
    
    self.flu_brf.text = self.nowWeather.flu_brf;
    self.flu_txt.text = self.nowWeather.flu_txt;
    
    self.sport_brf.text = self.nowWeather.sport_brf;
    self.sport_txt.text = self.nowWeather.sport_txt;
    
    self.dailyTableView.dataSource = self;
    self.dailyTableView.delegate = self;
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
    self.title = @"天气详情";
    //设置导航栏右边的
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_star_gray_48"] style:UIBarButtonItemStylePlain  target:self action:@selector(save:)];
}
static int i;
-(void)save:(UIButton *)sender{
    if(i%2 == 0){
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
        BmobUser *bUser = [BmobUser getCurrentUser];
        BmobObject *obj = [BmobObject objectWithClassName:@"weatherCollection"];
        [obj setObject:bUser.username forKey:@"userID"];
        [obj setObject:self.cityName forKey:@"cityName"];
        [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [MBProgressHUD showSuccess:@"收藏成功"];
            }
            else{
                [MBProgressHUD showSuccess:@"已经收藏过了"];
            }
        }];
    }
    else{
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        BmobQuery *bquery = [BmobQuery queryWithClassName:@"weatherCollection"];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            for (BmobObject *obj in array) {
                if ([[obj objectForKey:@"cityName"] isEqualToString:self.cityName]) {
                    BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"weatherCollection" objectId:[obj objectId]];
                    [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            [MBProgressHUD showSuccess:@"取消收藏"];
                        }
                    }];
                }
            }
        }];
    }
    i++;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dailyForecasts.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DailyForecast *daily = self.dailyForecasts[indexPath.row];
    static NSString *CellIdentifier = @"WeatherCell";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"WeatherTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    WeatherTableViewCell *weatherCell = (WeatherTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    weatherCell.daily = daily;
    return weatherCell;
}
@end
