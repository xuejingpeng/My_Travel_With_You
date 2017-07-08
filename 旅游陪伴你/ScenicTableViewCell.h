//
//  ScenicTableViewCell.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/24.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ScenicSpotDtailed.h"

@interface ScenicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageName;
@property (weak, nonatomic) IBOutlet UILabel *spotName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *descreptionText;
@property(strong,nonatomic)ScenicSpotDtailed *scenic;

@end
