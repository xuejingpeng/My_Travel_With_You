//
//  WeatherTableViewCell.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/20.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyForecast.h"
@interface WeatherTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *txt_d;
@property (weak, nonatomic) IBOutlet UILabel *txt_n;
@property (weak, nonatomic) IBOutlet UILabel *max;
@property (weak, nonatomic) IBOutlet UILabel *min;

@property (strong,nonatomic)DailyForecast *daily;
@end
