//
//  DeliciouFoodViewController.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/26.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliciouFoodViewController : UIViewController

@property(strong,nonatomic)NSMutableArray *resultArray;
@property(strong,nonatomic)NSString *cityName;
@property(strong,nonatomic)NSString *urlStr;
@property(assign,nonatomic)long cityId;

@end
