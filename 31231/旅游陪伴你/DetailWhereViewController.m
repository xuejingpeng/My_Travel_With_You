//
//  DetailWhereViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/23.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "DetailWhereViewController.h"
#import "TrainViewController.h"
#import "ScenicSpotsViewController.h"
#import "MBProgressHUD+Extension.h"
#import <BmobSDK/Bmob.h>
#import "ScenicSpot.h"
#import "Accommodation.h"
#import "ResultAccommodationViewController.h"


@interface DetailWhereViewController ()

@property(nonatomic,strong)NSMutableArray *scenicSpots;
//火车
- (IBAction)train:(UIButton *)sender;
//景点
- (IBAction)scenic:(UIButton *)sender;
//住宿
- (IBAction)accommodation:(UIButton *)sender;


@end

@implementation DetailWhereViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scenicSpots = [NSMutableArray array];
}
-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏主题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回键字体的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"旅游类型";
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

- (IBAction)train:(UIButton *)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TrainViewController *vc = [story instantiateViewControllerWithIdentifier:@"train"];
    vc.basic = [[WhereBasic alloc]init];
    vc.basic = self.basic;
    vc.datas = [NSMutableArray array];
    vc.datas = self.datas;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)scenic:(UIButton *)sender {
    [MBProgressHUD showMessage:@"正在搜索中...."];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Scenc"];
    bquery.limit =1000;
    [self.scenicSpots removeAllObjects];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"address"] rangeOfString:self.basic.cityName].location != NSNotFound) {
                ScenicSpot *scenic = [[ScenicSpot alloc]init];
                scenic.address = [obj objectForKey:@"address"];
                scenic.spotName = [obj objectForKey:@"spotName"];
                scenic.productId = [obj objectForKey:@"productId"];
                scenic.objectId = [obj objectId];
                [self.scenicSpots addObject:scenic];
            }
        }
        [MBProgressHUD hideHUD];
        ScenicSpotsViewController *vc = [[ScenicSpotsViewController alloc]init];
        vc.scenicSpots = self.scenicSpots;
        vc.basic = [[WhereBasic alloc]init];
        vc.basic = self.basic;
        vc.datas = [NSMutableArray array];
        vc.datas = self.datas;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (IBAction)accommodation:(UIButton *)sender {
    [MBProgressHUD showMessage:@"正在搜索中...."];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"accommodation"];
    [self.scenicSpots removeAllObjects];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"destination"] rangeOfString:self.basic.cityName].location != NSNotFound) {
                NSDictionary *dic = @{@"price":[obj objectForKey:@"price"],
                                      @"imageName":[obj objectForKey:@"imageName"],
                                      @"address":[obj objectForKey:@"address"],
                                      @"hotelName":[obj objectForKey:@"hotelName"],
                                      @"score":[obj objectForKey:@"score"],
                                      @"URL":[obj objectForKey:@"URL"]};
                Accommodation *accommodation = [[Accommodation alloc]initWithDictionary:dic];
                accommodation.objectId = [obj objectId];
                [self.scenicSpots addObject:accommodation];
            }
        }
        [MBProgressHUD hideHUD];
        ResultAccommodationViewController *vc = [[ResultAccommodationViewController alloc]init];
        vc.resultArray = self.scenicSpots;
        vc.basic = [[WhereBasic alloc]init];
        vc.basic = self.basic;
        vc.datas = [NSMutableArray array];
        vc.datas = self.datas;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
@end
