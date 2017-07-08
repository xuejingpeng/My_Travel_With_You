//
//  ScenicSpotsViewController.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/20.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhereBasic.h"

@interface ScenicSpotsViewController : UIViewController

@property(strong,nonatomic)WhereBasic *basic;
@property (strong,nonatomic)NSMutableArray *scenicSpots;
@property(strong,nonatomic)NSMutableArray *datas;

@end
