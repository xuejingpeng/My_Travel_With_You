//
//  WhereBasicCell.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/22.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhereBasic.h"
@protocol clickWhereBasicDelegate <NSObject>
- (void)whereBasiceModifyBtnClick:(UIButton *)sender;
@end

@interface WhereBasicCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *modify;
@property (weak, nonatomic) IBOutlet UILabel *title;

- (IBAction)modify:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (strong,nonatomic)WhereBasic *basic;
@property(strong,nonatomic)id<clickWhereBasicDelegate>delegate;

@end
