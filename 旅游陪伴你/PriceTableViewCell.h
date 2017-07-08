//
//  PriceTableViewCell.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/13.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceList.h"

@protocol clickScenicDelegate <NSObject>
- (void)leaveToWeb:(UIButton *)sender;
@end

@interface PriceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ticketTitle;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *normalPrice;
@property (weak, nonatomic) IBOutlet UILabel *bookUrl;
@property(strong,nonatomic) PriceList *priceList;

@property (strong,nonatomic) id<clickScenicDelegate> delegate;

@end
