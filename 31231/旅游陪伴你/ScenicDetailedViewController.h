//
//  ScenicDetailedViewController.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/12.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScenicSpotDtailed.h"
#import "WhereBasic.h"
#import "ScenicSpot.h"

@protocol DatasDelegate <NSObject>

-(void)returnData:(NSMutableArray *)datas;

@end

@interface ScenicDetailedViewController : UIViewController

@property(strong,nonatomic)WhereBasic *basic;
@property(strong,nonatomic)ScenicSpotDtailed *scenicDt;
@property (strong,nonatomic)NSMutableArray *priceList;
@property(strong,nonatomic)NSString *scenicId;
@property(strong,nonatomic)ScenicSpot *scenicSpot;
@property(strong,nonatomic)NSMutableArray *datas;
@property(nonatomic,weak)id<DatasDelegate>delegate;

@end
