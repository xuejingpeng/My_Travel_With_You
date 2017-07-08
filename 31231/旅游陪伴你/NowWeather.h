//
//  NowWeather.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/19.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DailyForecast.h"

@interface NowWeather : NSObject


@property(strong,nonatomic)DailyForecast *daily;
@property(strong,nonatomic)NSString *txt;//天气状态
@property(strong,nonatomic)NSString *fl;//体感温度
@property(strong,nonatomic)NSString *hum;//相对湿度
@property(strong,nonatomic)NSString *pcpn;//降水量
@property(strong,nonatomic)NSString *pres;//气压
@property(strong,nonatomic)NSString *tmp;//当前温度
@property(strong,nonatomic)NSString *dir;//风向
@property(strong,nonatomic)NSString *sc;//风级

@property(strong,nonatomic)NSString *trav_brf;//旅游指数
@property(strong,nonatomic)NSString *trav_txt;

@property(strong,nonatomic)NSString *comf_brf;//舒适度指数简介
@property(strong,nonatomic)NSString *comf_txt;//详细描述

@property(strong,nonatomic)NSString *drsg_brf;//穿衣指数
@property(strong,nonatomic)NSString *drsg_txt;

@property(strong,nonatomic)NSString *flu_brf;//感冒指数
@property(strong,nonatomic)NSString *flu_txt;

@property(strong,nonatomic)NSString *sport_brf;//运动指数
@property(strong,nonatomic)NSString *sport_txt;

@end
