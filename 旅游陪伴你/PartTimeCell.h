//
//  PartTimeCell.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/30.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartTime.h"

@interface PartTimeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *workTime;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *gender;
@property (weak, nonatomic) IBOutlet UILabel *treament;

@property(strong,nonatomic)PartTime *partTime;

@end
