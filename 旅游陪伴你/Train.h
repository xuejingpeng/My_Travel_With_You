//
//  Train.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/9.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Train : NSObject
@property(strong,nonatomic)NSString *train_no;//火车编号
@property(strong,nonatomic)NSString *station_train_code;//火车名
@property(strong,nonatomic)NSString *start_station_name;//开始站
@property(strong,nonatomic)NSString *end_station_name;//终点站
@property(strong,nonatomic)NSString *from_station_name;//出发站
@property(strong,nonatomic)NSString *to_station_name;//达到站
@property(strong,nonatomic)NSString *from_station_no;//出发站号
@property(strong,nonatomic)NSString *to_station_no;//达到站号
@property(strong,nonatomic)NSString *start_train_date;//开始日期
@property(strong,nonatomic)NSString *start_time;//出发时间
@property(strong,nonatomic)NSString *arrive_time;//到达时间
@property(strong,nonatomic)NSString *lishi;//历时
@property(strong,nonatomic)NSString *gr_num;//高级软卧
@property(strong,nonatomic)NSString *qt_num;//其他
@property(strong,nonatomic)NSString *rw_num;//软卧
@property(strong,nonatomic)NSString *rz_num;//软座
@property(strong,nonatomic)NSString *tz_num;//特等座
@property(strong,nonatomic)NSString *wz_num;//无座
@property(strong,nonatomic)NSString *yw_num;//硬卧
@property(strong,nonatomic)NSString *yz_num;//硬座
@property(strong,nonatomic)NSString *ze_num;//二等座
@property(strong,nonatomic)NSString *zy_num;//一等座
@property(strong,nonatomic)NSString *swz_num;//商务座
@property(strong,nonatomic)NSString *date;

@property(strong,nonatomic)NSString *objectId;

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
