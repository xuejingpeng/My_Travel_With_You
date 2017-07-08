//
//  WeatherTableViewCell.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/20.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "WeatherTableViewCell.h"

@implementation WeatherTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setDaily:(DailyForecast *)daily{
    NSArray *weekDay = [daily.date componentsSeparatedByString:@"-"];
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
            self.date.text = @"星期日";
            break;
        case 2:
            self.date.text = @"星期一";
            break;
        case 3:
            self.date.text = @"星期二";
            break;
        case 4:
            self.date.text = @"星期三";
            break;
        case 5:
            self.date.text = @"星期四";
            break;
        case 6:
            self.date.text = @"星期五";
            break;
        case 7:
            self.date.text = @"星期六";
            break;
        default:
            break;
    }
    self.txt_d.text = daily.txt_d;
    self.txt_n.text = daily.txt_n;
    self.max.text = daily.max;
    self.min.text = daily.min;
}

@end
