//
//  PersonCollectionViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/17.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "PersonCollectionViewController.h"
#import <BmobSDK/Bmob.h>
#import "PopularBlog.h"
#import "PopularBlogsTableViewController.h"
#import "WeatherTableViewController.h"
#import "Accommodation.h"
#import "Food.h"
#import "ScenicSpot.h"
#import "Travel.h"
#import "ResultAccommodationViewController.h"
#import "DeliciouFoodViewController.h"
#import "ScenicSpotsViewController.h"
#import "TravelViewController.h"

@interface PersonCollectionViewController ()

@property(strong,nonatomic)NSMutableArray *datas;
@property(strong,nonatomic)NSMutableArray *weatherDatas;
@property(strong,nonatomic)NSMutableArray *accommodationDatas;
@property(strong,nonatomic)NSMutableArray *foodDatas;
@property(strong,nonatomic)NSMutableArray *scencDatas;
@property(strong,nonatomic)NSMutableArray *travelDatas;
//热门游记收藏
- (IBAction)popularBlogsCollection:(UIButton *)sender;
//天气收藏
- (IBAction)weatherCollection:(UIButton *)sender;
//住宿收藏
- (IBAction)accommodationCollection:(UIButton *)sender;
//美食收藏
- (IBAction)foodCollection:(UIButton *)sender;
//景点收藏
- (IBAction)scencCollection:(UIButton *)sender;
//自助游收藏
- (IBAction)travelCollection:(UIButton *)sender;



@end

@implementation PersonCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = [NSMutableArray array];
    self.weatherDatas = [NSMutableArray array];
    self.accommodationDatas = [NSMutableArray array];
    self.foodDatas = [NSMutableArray array];
    self.scencDatas = [NSMutableArray array];
    self.travelDatas = [NSMutableArray array];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏的出现
    self.navigationController.navigationBarHidden = NO;
    //设置导航栏主题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回键字体的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"收藏的类别";
    self.tabBarController.tabBar.hidden = YES;
}
- (IBAction)popularBlogsCollection:(UIButton *)sender {
    BmobUser *bUser = [BmobUser getCurrentUser];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"PopularBlogsCollection"];
    [self.datas removeAllObjects];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"userID"] isEqualToString:bUser.username]) {
                PopularBlog *popularBlog = [[PopularBlog alloc]init];
                popularBlog.bookUrl = [obj objectForKey:@"bookUrl"];
                popularBlog.headImage = [obj objectForKey:@"headImage"];
                popularBlog.userName = [obj objectForKey:@"userName"];
                popularBlog.title = [obj objectForKey:@"title"];
                popularBlog.viewCount = [[obj objectForKey:@"viewCount"]longValue];
                popularBlog.likeCount = [[obj objectForKey:@"likeCount"]longValue];
                popularBlog.commentCount = [[obj objectForKey:@"commentCount"]longValue];
                [self.datas addObject:popularBlog];
            }
        }
        PopularBlogsTableViewController *vc=[[PopularBlogsTableViewController alloc]init];
        vc.datas = self.datas;
        vc.isRefresh = @"NO";
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (IBAction)weatherCollection:(UIButton *)sender {
    [self.weatherDatas removeAllObjects];
    BmobUser *bUser = [BmobUser getCurrentUser];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"weatherCollection"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"userID"] isEqualToString:bUser.username]) {
                [self.weatherDatas addObject:[obj objectForKey:@"cityName"]];
            }
        }
        WeatherTableViewController *vc=[[WeatherTableViewController alloc]init];
        vc.weatherDatas = self.weatherDatas;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (IBAction)accommodationCollection:(UIButton *)sender {
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"AccommodationCollection"];
    BmobUser *bUser = [BmobUser getCurrentUser];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.accommodationDatas  removeAllObjects];
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"userID"] isEqualToString:bUser.username]) {
                Accommodation *accommodation = [[Accommodation alloc]init];
                accommodation.destination = [obj objectForKey:@"destination"];
                accommodation.price = [obj objectForKey:@"price"];
                accommodation.imageName = [obj objectForKey:@"imageName"];
                accommodation.address =[obj objectForKey:@"address"];
                accommodation.score = [obj objectForKey:@"score"];
                accommodation.URL = [obj objectForKey:@"URL"];
                accommodation.hotelName = [obj objectForKey:@"hotelName"];
                [self.accommodationDatas addObject:accommodation];
            }
        }
        ResultAccommodationViewController *vc=[[ResultAccommodationViewController alloc]init];
        vc.resultArray = self.accommodationDatas;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (IBAction)foodCollection:(UIButton *)sender {
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"FoodCollection"];
    BmobUser *bUser = [BmobUser getCurrentUser];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.foodDatas  removeAllObjects];
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"userID"] isEqualToString:bUser.username]) {
                Food *food = [[Food alloc]init];
                food.deal_id = [[obj objectForKey:@"deal_id"]longValue];
                food.deal_murl = [obj objectForKey:@"deal_murl"];
                food.description_text = [obj objectForKey:@"description_text"];
                food.sale_num = [[obj objectForKey:@"sale_num"]longValue];
                food.comment_num = [[obj objectForKey:@"comment_num"]longValue];
                food.current_price = [[obj objectForKey:@"current_price"]longValue];
                food.market_price = [[obj objectForKey:@"market_price"]longValue];
                food.score = [[obj objectForKey:@"score"]longValue];
                food.tiny_image = [obj objectForKey:@"tiny_image"];
                [self.foodDatas addObject:food];
            }
        }
        DeliciouFoodViewController *vc=[[DeliciouFoodViewController alloc]init];
        vc.resultArray = self.foodDatas;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (IBAction)scencCollection:(UIButton *)sender {
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"ScencCollection"];
    BmobUser *bUser = [BmobUser getCurrentUser];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.scencDatas  removeAllObjects];
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"userID"] isEqualToString:bUser.username]) {
                ScenicSpot *scenc = [[ScenicSpot alloc]init];
                scenc.address = [obj objectForKey:@"address"];
                scenc.productId = [obj objectForKey:@"productId"];
                scenc.spotName = [obj objectForKey:@"spotName"];
                [self.scencDatas addObject:scenc];
            }
        }
        ScenicSpotsViewController *vc=[[ScenicSpotsViewController alloc]init];
        vc.scenicSpots = self.scencDatas;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (IBAction)travelCollection:(UIButton *)sender {
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"TravelCollection"];
    BmobUser *bUser = [BmobUser getCurrentUser];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.travelDatas  removeAllObjects];
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"userID"] isEqualToString:bUser.username]) {
                Travel *travel = [[Travel alloc]init];
                travel.commentCount = [obj objectForKey:@"commentCount"];
                travel.detailed = [obj objectForKey:@"detailed"];
                travel.imageNames = [obj objectForKey:@"imageNames"];
                travel.likeCount = [obj objectForKey:@"likeCount"];
                travel.price = [obj objectForKey:@"price"];
                travel.dayCount = [obj objectForKey:@"dayCount"];
                travel.satisfaction = [obj objectForKey:@"satisfaction"];
                travel.traveName = [obj objectForKey:@"traveName"];
                travel.where = [obj objectForKey:@"where"];
                [self.travelDatas addObject:travel];
            }
        }
        TravelViewController *vc=[[TravelViewController alloc]init];
        vc.resultArray = self.travelDatas;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
@end
