//
//  FoodTableViewCell.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/26.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Food.h"

@interface FoodTableViewCell : UITableViewCell

@property(strong,nonatomic)Food *food;
@property (weak, nonatomic) IBOutlet UIImageView *tiny_image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *descriptionText;
@property (weak, nonatomic) IBOutlet UIImageView *score1;
@property (weak, nonatomic) IBOutlet UIImageView *score2;
@property (weak, nonatomic) IBOutlet UIImageView *score3;
@property (weak, nonatomic) IBOutlet UIImageView *score4;
@property (weak, nonatomic) IBOutlet UIImageView *score5;
@property (weak, nonatomic) IBOutlet UILabel *current_price;
@property (weak, nonatomic) IBOutlet UILabel *sale_num;
@property (weak, nonatomic) IBOutlet UILabel *market_price;

@property (weak, nonatomic) IBOutlet UILabel *comment_num;


@end
