//
//  TrainTableViewCell.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/9.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Train.h"

@interface TrainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *station_train_code;
@property (weak, nonatomic) IBOutlet UILabel *from_station_name;
@property (weak, nonatomic) IBOutlet UILabel *to_station_name;
@property (weak, nonatomic) IBOutlet UILabel *start_time;
@property (weak, nonatomic) IBOutlet UILabel *arrive_time;
@property (weak, nonatomic) IBOutlet UILabel *lishi;
@property (weak, nonatomic) IBOutlet UILabel *ticketNum;
@property (strong,nonatomic)Train *train;

@end
