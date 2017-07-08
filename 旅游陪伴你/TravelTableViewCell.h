//
//  TravelTableViewCell.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/18.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Travel.h"

@interface TravelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *travelName;
@property (weak, nonatomic) IBOutlet UILabel *where;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *satisfaction;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property(strong,nonatomic)Travel *travel;

@end
