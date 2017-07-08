//
//  AccommodationDeViewController.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/18.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Accommodation.h"
#import "WhereBasic.h"
#import "PopularBlog.h"
#import "Food.h"
#import "Travel.h"
#import "ScenicDetailedViewController.h"

@interface AccommodationDeViewController : UIViewController

//从住宿控制器
@property(strong,nonatomic)Accommodation *accommodation;
@property(strong,nonatomic)NSString *travelCityName;
@property(strong,nonatomic)WhereBasic *basic;
@property(strong,nonatomic)NSMutableArray *datas;
@property(nonatomic,weak)id<DatasDelegate>delegate;
//从自助游控制器
@property(strong,nonatomic)NSString *traveURL;
@property(strong,nonatomic)NSString *cityName;
@property(strong,nonatomic)NSString *travelName;
@property(strong,nonatomic)NSString *isAddView;//是否是从添加界面过来的
@property(strong,nonatomic)Travel *travel;
@property (strong,nonatomic)NSMutableArray *resultDatas;
//从景点控制器
@property(strong,nonatomic)NSString *ScenicURL;
@property(strong,nonatomic)NSString *isViewContrller;

//从美食
@property(strong,nonatomic)NSString *foodURL;
@property(strong,nonatomic)Food *food;

//从热门游记
@property(strong,nonatomic)NSString *popularBlogURL;
@property(strong,nonatomic)PopularBlog *popularBlog;

@end
