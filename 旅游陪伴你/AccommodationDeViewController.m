//
//  AccommodationDeViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/18.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "AccommodationDeViewController.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+Extension.h"
#import "SZCalendarPicker.h"
#import "IndeTravelWherViewController.h"
#import "CustomWhereViewController.h"
#import "CustomGroup.h"

@interface AccommodationDeViewController ()<UIWebViewDelegate,clickSureDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *save;
@property (weak, nonatomic) IBOutlet UIToolbar *tabar;
@property(strong,nonatomic)NSString *objectId;

//存储时间
@property (strong,nonatomic) NSString *date;

- (IBAction)goBack:(UIBarButtonItem *)sender;
- (IBAction)goForward:(UIBarButtonItem *)sender;
- (IBAction)save:(UIBarButtonItem *)sender;


@end

@implementation AccommodationDeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.isViewContrller isEqualToString:@"自助游"]){
        [self.save setTitle:@"点击保存为一条路线"];
    }
    self.webView.scalesPageToFit = YES;
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    NSString *URL = [NSString string];
    if ([self.isViewContrller isEqualToString:@"住宿"]) {
        URL = self.accommodation.URL;
    }
    else if ([self.isViewContrller isEqualToString:@"自助游"]){
        URL = self.traveURL;
    }
    else if ([self.isViewContrller isEqualToString:@"景点"]){
        URL = self.ScenicURL;
    }
    else if ([self.isViewContrller isEqualToString:@"美食"]){
        URL = self.foodURL;
    }
    else if ([self.isViewContrller isEqualToString:@"热门游记"]){
        URL = self.popularBlogURL;
    }
    self.webView.delegate = self;
    NSURL *url =[NSURL URLWithString:URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
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
    self.title = @"详细结果";
    if (self.basic == nil && ![self.isAddView isEqualToString:@"添加自助旅游"]) {
        //设置导航栏右边的
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_star_gray_48"] style:UIBarButtonItemStylePlain  target:self action:@selector(saveMessage:)];
        self.tabar.alpha = 0;
    }
    i=0;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    NSLog(@"%@",webView.request.URL.absoluteString);
}
- (IBAction)goBack:(UIBarButtonItem *)sender {
    [self.webView goBack];
}

- (IBAction)goForward:(UIBarButtonItem *)sender {
    [self.webView goForward];
}

- (IBAction)save:(UIBarButtonItem *)sender {
    if ([self.isViewContrller isEqualToString:@"住宿"]) {
        [MBProgressHUD showMessage:@"正在保存中..."];
        BmobObject *post  = [BmobObject objectWithClassName:@"CustomWhere"];
        [post setObject:self.basic.objectId forKey:@"objectUserID"];
        BmobObject *obj = [BmobObject objectWithoutDatatWithClassName:@"accommodation" objectId:self.accommodation.objectId];
        [post setObject:@"住宿" forKey:@"isType"];
        [post setObject:obj forKey:@"accommodation"];
        [post setObject:self.basic.day forKey:@"day"];
        [post saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error){
            if (isSuccessful) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showSuccess:@"添加成功"];
                int day = self.basic.day.intValue;
                CustomGroup *customGroup = self.datas[day];
                if (customGroup.settingItems == nil) {
                    customGroup.settingItems  = [NSMutableArray array];
                    [customGroup.settingItems addObject:self.accommodation];
                }
                else{
                [customGroup.settingItems insertObject:self.accommodation atIndex:customGroup.settingItems.count];
                }
                [self.delegate returnData:self.datas];
                NSArray *temArray = self.navigationController.viewControllers;
                for (UIViewController *temVC in temArray) {
                    if ([temVC isKindOfClass:[CustomWhereViewController class]]) {
                        [self.navigationController popToViewController:temVC animated:YES];
                        break;
                    }
                }
            }
        }];
    }
    else if ([self.isViewContrller isEqualToString:@"自助游"]){
        
        SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
        calendarPicker.today = [NSDate date];
        calendarPicker.date = calendarPicker.today;
        //设置日历的位置
        calendarPicker.frame = CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height-260);
        calendarPicker.delegate = self;
        
        calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
            self.date = [NSString stringWithFormat:@"%li年%li月%li日", (long)year,(long)month,(long)day];
        };
    }
}
-(void)selectSureBtnClick:(UIButton *)sender{
    BmobUser *bUser = [BmobUser getCurrentUser];
    BmobObject *obj = [BmobObject objectWithClassName:@"TravelWhere"];
    [obj setObject:bUser.username forKey:@"userID"];
    [obj setObject:self.travelCityName forKey:@"cityName"];
    [obj setObject:self.traveURL forKey:@"travelURL"];
    [obj setObject:self.travelName forKey:@"travelName"];
    [obj setObject:self.date forKey:@"startTime"];
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [MBProgressHUD showSuccess:@"保存路线成功"];
        }
        if (error) {
            [MBProgressHUD showError:@"已经存在"];
        }
        if([self.isAddView isEqualToString:@"添加自助旅游"]){
            NSArray *temArray = self.navigationController.viewControllers;
            for (UIViewController *temVC in temArray) {
                if ([temVC isKindOfClass:[IndeTravelWherViewController class]]) {
                    [self.navigationController popToViewController:temVC animated:YES];
                    break;
                }
            }
        }
    }];
}
static int i;
-(void)saveMessage:(UIButton *)sender{
    if ([self.isViewContrller isEqualToString:@"住宿"]) {
    if(i%2 == 0){
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
        BmobUser *bUser = [BmobUser getCurrentUser];
        BmobObject *obj = [BmobObject objectWithClassName:@"AccommodationCollection"];
        [obj setObject:bUser.username forKey:@"userID"];
        [obj setObject:self.cityName forKey:@"destination"];
        [obj setObject:self.accommodation.price forKey:@"price"];
        [obj setObject:self.accommodation.imageName forKey:@"imageName"];
        [obj setObject:self.accommodation.address forKey:@"address"];
        [obj setObject:self.accommodation.hotelName forKey:@"hotelName"];
        [obj setObject:self.accommodation.score forKey:@"score"];
        [obj setObject:self.accommodation.URL forKey:@"URL"];
        [obj setObject:self.accommodation.hotelName forKey:@"hotelName"];
        [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
            if (isSuccessful) {
                [MBProgressHUD showSuccess:@"收藏成功"];
                self.objectId = [obj objectId];
                ++i;
            }
            else{
                [MBProgressHUD showSuccess:@"已经收藏过了"];
//                self.objectId = [obj objectId];
            }
           
        }];
    }
    else{
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"AccommodationCollection" objectId:self.objectId];
        [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [MBProgressHUD showSuccess:@"取消收藏"];
            }
            ++i;
        }];
    }
    }
    else if ([self.isViewContrller isEqualToString:@"热门游记"]) {
        if(i%2 == 0){
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
            BmobUser *bUser = [BmobUser getCurrentUser];
            BmobObject *obj = [BmobObject objectWithClassName:@"PopularBlogsCollection"];
            [obj setObject:bUser.username forKey:@"userID"];
            [obj setObject:self.popularBlog.bookUrl forKey:@"bookUrl"];
            [obj setObject:self.popularBlog.headImage forKey:@"headImage"];
            [obj setObject:self.popularBlog.userName  forKey:@"userName"];
            [obj setObject:self.popularBlog.title  forKey:@"title"];
            [obj setObject:[NSNumber numberWithLong:self.popularBlog.viewCount] forKey:@"viewCount"];
            [obj setObject:[NSNumber numberWithLong:self.popularBlog.likeCount] forKey:@"likeCount"];
            [obj setObject:[NSNumber numberWithLong:self.popularBlog.commentCount] forKey:@"URL"];
            [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                self.objectId = [obj objectId];
                if (isSuccessful) {
                    [MBProgressHUD showSuccess:@"收藏成功"];
                    i++;
                }
                else{
                    [MBProgressHUD showSuccess:@"已经收藏过了"];
                }
            }];
        }
        else{
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
            BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"AccommodationCollection" objectId:self.objectId];
            [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [MBProgressHUD showSuccess:@"取消收藏"];
                    i++;
                }
        }];
    }
    }
    else if ([self.isViewContrller isEqualToString:@"美食"]) {
        if(i%2 == 0){
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
            BmobUser *bUser = [BmobUser getCurrentUser];
            BmobObject *obj = [BmobObject objectWithClassName:@"FoodCollection"];
            [obj setObject:bUser.username forKey:@"userID"];
            [obj setObject:[NSNumber numberWithLong:self.food.deal_id] forKey:@"deal_id"];
            [obj setObject:self.food.tiny_image forKey:@"tiny_image"];
            [obj setObject:self.food.title forKey:@"title"];
            [obj setObject:self.food.description_text  forKey:@"description_text"];
            [obj setObject:[NSNumber numberWithLong:self.food.market_price] forKey:@"market_price"];
            [obj setObject:[NSNumber numberWithLong:self.food.current_price] forKey:@"current_price"];
            [obj setObject:[NSNumber numberWithLong:self.food.sale_num] forKey:@"sale_num"];
            [obj setObject:[NSNumber numberWithLong:self.food.score] forKey:@"score"];
            [obj setObject:[NSNumber numberWithLong:self.food.comment_num] forKey:@"comment_num"];
            [obj setObject:self.food.deal_murl forKey:@"deal_murl"];
            [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                self.objectId = [obj objectId];
                if (isSuccessful) {
                    i++;
                    [MBProgressHUD showSuccess:@"收藏成功"];
                }
                else{
                    [MBProgressHUD showSuccess:@"已经收藏过了"];
                    
                }
            }];
        }
        else{
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
            BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"FoodCollection" objectId:self.objectId];
            [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [MBProgressHUD showSuccess:@"取消收藏"];
                    i++;
                }
            }];
        }
    }
    
    else if ([self.isViewContrller isEqualToString:@"自助游"]) {
        if(i%2 == 0){
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor orangeColor];
            BmobUser *bUser = [BmobUser getCurrentUser];
            BmobObject *obj = [BmobObject objectWithClassName:@"TravelCollection"];
            [obj setObject:bUser.username forKey:@"userID"];
            [obj setObject:self.travel.traveName forKey:@"traveName"];
            [obj setObject:self.travel.price forKey:@"price"];
            [obj setObject:self.travel.satisfaction forKey:@"satisfaction"];
            [obj setObject:self.travel.likeCount forKey:@"likeCount"];
            [obj setObject:self.travel.commentCount forKey:@"commentCount"];
            [obj setObject:self.travel.where forKey:@"where"];
            [obj setObject:self.travel.dayCount forKey:@"dayCount"];
            [obj setObject:self.travel.detailed forKey:@"detailed"];
            [obj setObject:self.travel.imageNames forKey:@"imageNames"];
            [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                self.objectId = [obj objectId];
                if (isSuccessful) {
                    [MBProgressHUD showSuccess:@"收藏成功"];
                    i++;
                }
                else{
                    [MBProgressHUD showSuccess:@"已经收藏过了"];
                }
            }];
        }
        else{
            self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
            BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"TravelCollection" objectId:self.objectId];
            [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [MBProgressHUD showSuccess:@"取消收藏"];
                    i++;
                }
            }];
        }
    }
}

@end
