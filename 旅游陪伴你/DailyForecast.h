//
//  DailyForecast.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/19.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyForecast : NSObject

@property(nonatomic,strong)NSString *sr;//日出时间
@property(nonatomic,strong)NSString *ss;//日落时间
@property(nonatomic,strong)NSString *txt_d;//白天的天气
@property(nonatomic,strong)NSString *txt_n;//晚上的天气
@property(nonatomic,strong)NSString *date;//日期
@property(nonatomic,strong)NSString *max;//最高温度
@property(nonatomic,strong)NSString *min;//最低温度


@end
