//
//  WeatherTableViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/17.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "WeatherTableViewController.h"
#import "MBProgressHUD+Extension.h"
#import "DataServers.h"
#import "WeatherResultsViewController.h"
#import "DailyForecast.h"
#import "NowWeather.h"

@interface WeatherTableViewController ()

@property (strong,nonatomic)DataServers *data;
//存储城市
@property (strong,nonatomic)NSMutableDictionary *city;

@property (strong,nonatomic)NSMutableArray *dailyForecasts;//几天的天气数据的数组
@property (strong,nonatomic)NowWeather *now;
@end

@implementation WeatherTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [[DataServers alloc]init];
    self.city = [[NSMutableDictionary alloc]init];
    self.dailyForecasts = [[NSMutableArray alloc]init];
    self.now = [[NowWeather alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.weatherDatas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"weatherCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    cell.textLabel.text = self.weatherDatas[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *httpUrl =  @"http://apis.baidu.com/heweather/weather/free";
    NSString *city = [self.weatherDatas[indexPath.row] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
        [MBProgressHUD showMessage:[NSString stringWithFormat:@"正在获取%@的天气数据",self.weatherDatas[indexPath.row]]];
        //发送网络请求
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
            WeatherResultsViewController *vc = [[WeatherResultsViewController alloc]init];
            vc.cityName = self.weatherDatas[indexPath.row];
            vc.dailyForecasts = self.dailyForecasts;
            vc.nowWeather = self.now;
            [self.navigationController pushViewController:vc animated:YES];
        });
    }
}

@end
