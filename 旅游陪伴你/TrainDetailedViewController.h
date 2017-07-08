//
//  TrainDetailedViewController.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/12.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Train.h"
#import "TrainDetailed.h"
#import "WhereBasic.h"
#import "ScenicDetailedViewController.h"

@interface TrainDetailedViewController : UIViewController

@property(strong,nonatomic)Train *train;
@property(strong,nonatomic)TrainDetailed *trainDe;
@property (strong,nonatomic)NSString *date;
@property (strong,nonatomic)WhereBasic *basic;
@property(strong,nonatomic)NSMutableArray *datas;
@property(nonatomic,weak)id<DatasDelegate>delegate;

@end
