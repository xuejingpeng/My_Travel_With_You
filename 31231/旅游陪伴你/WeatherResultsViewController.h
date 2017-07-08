//
//  WeatherResultsViewController.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/19.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NowWeather.h"

@interface WeatherResultsViewController : UIViewController

@property(strong,nonatomic)NSString *cityName;
@property(strong,nonatomic)NSMutableArray *dailyForecasts;//几天的天气数据的数组
//@property(strong,nonatomic)NSMutableArray *hourlyForecasts;//每三个小时的天气数据的数组
@property(strong,nonatomic)NowWeather *nowWeather;//当前天气状况

@end
