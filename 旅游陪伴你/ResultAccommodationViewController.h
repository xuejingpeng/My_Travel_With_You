//
//  ResultAccommodationViewController.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/15.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WhereBasic.h"

@interface ResultAccommodationViewController : UIViewController

@property(nonatomic,strong)NSString *cityName;
@property(nonatomic,assign)int dayNum;
@property(nonatomic,strong)NSMutableArray *resultArray;
@property(nonatomic,strong)WhereBasic *basic;
@property(strong,nonatomic)NSMutableArray *datas;


@end
