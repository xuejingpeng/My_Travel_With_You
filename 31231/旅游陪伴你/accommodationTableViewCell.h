//
//  accommodationTableViewCell.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/15.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Accommodation.h"

@interface accommodationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageNmae;
@property (weak, nonatomic) IBOutlet UILabel *holeNmae;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (strong,nonatomic)Accommodation * accommodation;
@end
