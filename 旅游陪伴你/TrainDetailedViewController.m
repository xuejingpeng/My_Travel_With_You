//
//  TrainDetailedViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/12.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "TrainDetailedViewController.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+Extension.h"
#import "CustomWhereViewController.h"
#import "CustomGroup.h"

@interface TrainDetailedViewController ()
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *from_station_name;
@property (weak, nonatomic) IBOutlet UILabel *to_station_name;
@property (weak, nonatomic) IBOutlet UILabel *station_train_code;
@property (weak, nonatomic) IBOutlet UILabel *start_station_name;
@property (weak, nonatomic) IBOutlet UILabel *end_station_name;
@property (weak, nonatomic) IBOutlet UILabel *gr;
@property (weak, nonatomic) IBOutlet UILabel *rw;
@property (weak, nonatomic) IBOutlet UILabel *rz;
@property (weak, nonatomic) IBOutlet UILabel *yw;
@property (weak, nonatomic) IBOutlet UILabel *yz;
@property (weak, nonatomic) IBOutlet UILabel *tz;
@property (weak, nonatomic) IBOutlet UILabel *zy;
@property (weak, nonatomic) IBOutlet UILabel *ze;
@property (weak, nonatomic) IBOutlet UILabel *swz;
@property (weak, nonatomic) IBOutlet UILabel *wz;
@property (weak, nonatomic) IBOutlet UILabel *qt;
- (IBAction)saveMessage:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *save;

@end

@implementation TrainDetailedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.startTime.text = self.train.start_time;
    self.endTime.text = self.train.arrive_time;
    self.time.text = self.train.date;
    self.from_station_name.text = self.train.from_station_name;
    self.to_station_name.text = self.train.to_station_name;
    self.start_station_name.text = self.train.start_station_name;
    self.station_train_code.text = self.train.station_train_code;
    self.end_station_name.text = self.train.end_station_name;
    self.gr.text = [NSString stringWithFormat:@"%@/%@",self.train.gr_num,self.trainDe.gr];
    self.rw.text = [NSString stringWithFormat:@"%@/%@",self.train.rw_num,self.trainDe.rw];
    self.rz.text = [NSString stringWithFormat:@"%@/%@",self.train.rz_num,self.trainDe.rz];
    self.yw.text = [NSString stringWithFormat:@"%@/%@",self.train.yw_num,self.trainDe.yw];
    self.yz.text = [NSString stringWithFormat:@"%@/%@",self.train.yz_num,self.trainDe.yz];
    self.tz.text = [NSString stringWithFormat:@"%@/%@",self.train.tz_num,self.trainDe.tz];
    self.zy.text = [NSString stringWithFormat:@"%@/%@",self.train.zy_num,self.trainDe.zy];
    self.ze.text = [NSString stringWithFormat:@"%@/%@",self.train.ze_num,self.trainDe.ze];
    self.swz.text = [NSString stringWithFormat:@"%@/%@",self.train.swz_num,self.trainDe.swz];
    self.wz.text = [NSString stringWithFormat:@"%@/%@",self.train.wz_num,self.trainDe.wz];
    self.qt.text = [NSString stringWithFormat:@"%@/%@",self.train.qt_num,self.trainDe.qt];
    if (self.basic) {
        self.save.hidden = NO;
    }
    else{
        self.save.hidden = YES;
    }
}
-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏主题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回键字体的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"结果详情";
}
- (IBAction)saveMessage:(UIButton *)sender {
    [MBProgressHUD showMessage:@"正在保存中..."];
    BmobObject *obj = [BmobObject objectWithClassName:@"Train"];
    [obj setObject:self.train.train_no forKey:@"train_no"];
    [obj setObject:self.train.station_train_code forKey:@"station_train_code"];
    [obj setObject:self.train.start_station_name forKey:@"start_station_name"];
    [obj setObject:self.train.end_station_name forKey:@"end_station_name"];
    [obj setObject:self.train.from_station_name forKey:@"from_station_name"];
    [obj setObject:self.train.to_station_name forKey:@"to_station_name"];
    [obj setObject:self.train.from_station_no forKey:@"from_station_no"];
    [obj setObject:self.train.to_station_no forKey:@"to_station_no"];
    [obj setObject:self.train.start_train_date forKey:@"start_train_date"];
    [obj setObject:self.train.start_time forKey:@"start_time"];
    [obj setObject:self.train.arrive_time forKey:@"arrive_time"];
    [obj setObject:self.train.lishi forKey:@"lishi"];
    [obj setObject:self.train.gr_num forKey:@"gr_num"];
    [obj setObject:self.train.qt_num forKey:@"qt_num"];
    [obj setObject:self.train.rw_num forKey:@"rw_num"];
    [obj setObject:self.train.rz_num forKey:@"rz_num"];
    [obj setObject:self.train.tz_num forKey:@"tz_num"];
    [obj setObject:self.train.wz_num forKey:@"wz_num"];
    [obj setObject:self.train.yw_num forKey:@"yw_num"];
    [obj setObject:self.train.yz_num forKey:@"yz_num"];
    [obj setObject:self.train.ze_num forKey:@"ze_num"];
    [obj setObject:self.train.zy_num forKey:@"zy_num"];
    [obj setObject:self.train.swz_num forKey:@"swz_num"];
    [obj setObject:self.train.date forKey:@"date"];
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            BmobObject *post  = [BmobObject objectWithClassName:@"CustomWhere"];
            [post setObject:self.basic.objectId forKey:@"objectUserID"];
            [post setObject:@"火车" forKey:@"isType"];
            [post setObject:obj forKey:@"train"];
            [post setObject:self.basic.day forKey:@"day"];
            [post saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showSuccess:@"添加成功"];
                    NSArray *temArray = self.navigationController.viewControllers;
                    int day = self.basic.day.intValue;
                    CustomGroup *customGroup = self.datas[day];
                    if (customGroup.settingItems == nil) {
                        customGroup.settingItems  = [NSMutableArray array];
                        [customGroup.settingItems addObject:self.train];
                    }
                    else{
                        [customGroup.settingItems insertObject:self.train atIndex:customGroup.settingItems.count];
                    }
                    [self.delegate returnData:self.datas];
                    for (UIViewController *temVC in temArray) {
                        if ([temVC isKindOfClass:[CustomWhereViewController class]]) {
                            [self.navigationController popToViewController:temVC animated:YES];
                            break;
                        }
                    }
                }
                
            }];
        }
    }];
}
@end
