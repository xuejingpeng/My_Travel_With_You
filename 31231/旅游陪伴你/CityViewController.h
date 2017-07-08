//
//  CityViewController.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/1/29.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CityViewController;
@protocol CityViewControllerDelegate <NSObject>

-(void)cityViewController:(CityViewController *)cityVC didCity:(NSString *)cityName;

@end

@interface CityViewController : UIViewController

typedef NS_ENUM(int, FromWhere) {
    FromTrainBegin,
    FromTrainEnd,
    FromTravelBegin,
    FromTravelEnd,
};
@property(nonatomic,weak)id<CityViewControllerDelegate>delegate;
@property (nonatomic) FromWhere  from;

@end
