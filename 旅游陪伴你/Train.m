//
//  Train.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/9.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "Train.h"

@implementation Train

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        self.train_no = [dic valueForKey:@"train_no"];
        self.station_train_code = [dic valueForKey:@"station_train_code"];
        self.start_station_name = [dic valueForKey:@"start_station_name"];
        self.end_station_name = [dic valueForKey:@"end_station_name"];
        self.from_station_name = [dic valueForKey:@"from_station_name"];
        self.to_station_name = [dic valueForKey:@"to_station_name"];
        self.from_station_no = [dic valueForKey:@"from_station_no"];
        self.to_station_no = [dic valueForKey:@"to_station_no"];
        self.start_train_date = [dic valueForKey:@"start_train_date"];
        self.start_time = [dic valueForKey:@"start_time"];
        self.arrive_time = [dic valueForKey:@"arrive_time"];
        self.lishi = [dic valueForKey:@"lishi"];
        self.gr_num = [dic valueForKey:@"gr_num"];
        self.qt_num = [dic valueForKey:@"qt_num"];
        self.rw_num = [dic valueForKey:@"rw_num"];
        self.rz_num = [dic valueForKey:@"rz_num"];
        self.tz_num = [dic valueForKey:@"tz_num"];
        self.wz_num = [dic valueForKey:@"wz_num"];
        self.yw_num = [dic valueForKey:@"yw_num"];
        self.yz_num = [dic valueForKey:@"yz_num"];
        self.ze_num = [dic valueForKey:@"ze_num"];
        self.zy_num = [dic valueForKey:@"zy_num"];
        self.swz_num = [dic valueForKey:@"swz_num"];
        
    }
    return self;
}

@end
