//
//  LittleJokeTableViewCell.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/15.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LittleJoke;

@interface LittleJokeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong,nonatomic)LittleJoke *littleJoke;
@property (assign,nonatomic) int numb;

@end
