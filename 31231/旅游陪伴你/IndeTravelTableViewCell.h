//
//  IndeTravelTableViewCell.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/21.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndeTravel.h"

@interface IndeTravelTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *travelName;
@property (weak, nonatomic) IBOutlet UILabel *cityName;

@property (weak, nonatomic) IBOutlet UILabel *timeDate;

@property(strong,nonatomic)IndeTravel *inTravel;

@end
