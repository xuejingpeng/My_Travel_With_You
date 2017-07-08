//
//  TrainResultViewController.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/9.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhereBasic.h"

@interface TrainResultViewController : UIViewController

//判断数据是不是空的
@property(strong,nonatomic)NSString *isEmpty;
@property(strong,nonatomic)NSMutableArray *dataArray;

@property (strong,nonatomic)WhereBasic *basic;
@property(strong,nonatomic)NSMutableArray *datas;

@end
