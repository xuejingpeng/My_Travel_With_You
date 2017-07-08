//
//  TrainViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/20.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "TrainViewController.h"
#import "CityViewController.h"
#import "SZCalendarPicker.h"
#import "MBProgressHUD+Extension.h"
#import "ApiStoreSDK.h"
#import "DataServers.h"
#import "Train.h"
#import "TrainResultViewController.h"

@interface TrainViewController ()<CityViewControllerDelegate,clickSureDelegate>{
    NSString *ms1;
    NSString *ms2;
}

@property (weak, nonatomic) IBOutlet UIButton *beginCity;
@property (weak, nonatomic) IBOutlet UIButton *endCity;
@property (weak, nonatomic) IBOutlet UIButton *date;
@property (strong,nonatomic)NSString *time;
@property (strong, nonatomic)DataServers * dataServer;
@property (strong,nonatomic) NSMutableArray *resultArray;
@property (strong,nonatomic)NSString *isEmpty;

- (IBAction)selectDate:(UIButton *)sender;
- (IBAction)queryTrain:(UIButton *)sender;


@end

@implementation TrainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //实例化
    self.dataServer = [[DataServers alloc]init];
    self.resultArray = [NSMutableArray array];
    self.isEmpty = [NSString string];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.title = @"火车票";
    self.tabBarController.tabBar.hidden = YES;
    if (self.basic) {
        [self.endCity setTitle:self.basic.cityName forState:UIControlStateNormal];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender{
    
    [super prepareForSegue:segue sender:sender];
    UIViewController *vc =  segue.destinationViewController;
    if ([vc isKindOfClass:[CityViewController class]]) {
        CityViewController *cityVC = segue.destinationViewController;
        cityVC.delegate = self;
        if (sender.tag == 100) {
            cityVC.from = FromTrainBegin;
        }
        else if (sender.tag == 200){
            cityVC.from = FromTrainEnd;
        }
    }
}

- (IBAction)selectDate:(UIButton *)sender {
    SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    //设置日历的位置
    calendarPicker.frame = CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height-260);
    calendarPicker.delegate = self;
    
    calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        NSString *day1 = [NSString string];
        NSString *month1 = [NSString string];
        //在月和日小于10的前面加个0
        if(day<10){
            day1 = [NSString stringWithFormat:@"0%ld",(long)day];
        }
        else{
            day1 = [NSString stringWithFormat:@"%ld",(long)day];
        }
        if(month<10){
            month1 = [NSString stringWithFormat:@"0%ld",(long)month];
        }
        else{
            month1 = [NSString stringWithFormat:@"%ld",(long)month];
        }
        self.time = [NSString stringWithFormat:@"%li-%@-%@", (long)year,month1,day1];
    };
}

- (IBAction)queryTrain:(UIButton *)sender {
    if ([self.beginCity.titleLabel.text isEqualToString:@"点击获取城市"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请点击获取出发站" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    if ([self.endCity.titleLabel.text isEqualToString:@"点击获取城市"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请点击获取终点站" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        return;
    }
    if([self.date.titleLabel.text isEqualToString:@"点击获取日期"]){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请点击获取日期" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    //    [parameter setObject:@"1.0" forKey:@"version"];
    [parameter setObject:self.beginCity.titleLabel.text forKey:@"from"];
    [parameter setObject:self.endCity.titleLabel.text forKey:@"to"];
    [parameter setObject:self.time forKey:@"date"];
    [MBProgressHUD showMessage:@"正在搜索中..."];
    [self.dataServer gainTrainInfo:parameter andBlock:^(NSDictionary *resultDic) {
        [self.resultArray removeAllObjects];
        if([[resultDic valueForKey:@"result"] isEqual:[NSNull null]]){
            self.isEmpty = @"没有数据";
        }
        else{
        NSArray *arrayResult = [[NSArray alloc]initWithArray:[resultDic valueForKey:@"result"]];
             for (int i=0; i<arrayResult.count; i++) {
            NSDictionary *dic = [arrayResult[i] valueForKey:@"queryLeftNewDTO"];
            Train *train = [[Train alloc]initWithDictionary:dic];
            train.date = self.date.titleLabel.text;
            [self.resultArray addObject:train];
        }
        self.isEmpty = @"有数据";
        }
        [MBProgressHUD hideHUD];
    }];
    if ([self.isEmpty isEqualToString:@"有数据"]) {
        TrainResultViewController *vc = [[TrainResultViewController alloc]init];
        vc.isEmpty = self.isEmpty;
        vc.dataArray = self.resultArray;
        if (self.basic) {
            vc.basic = [[WhereBasic alloc]init];
            vc.basic = self.basic;
            vc.datas = [NSMutableArray array];
            vc.datas = self.datas;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([self.isEmpty isEqualToString:@"没有数据"]){
        TrainResultViewController *vc = [[TrainResultViewController alloc]init];
        vc.isEmpty = self.isEmpty;
        if (vc.dataArray==nil) {
            vc.dataArray = [NSMutableArray array];
        }
        else{
            [vc.dataArray removeAllObjects];
        }
//        vc.date = self..date.titleLabel.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)cityViewController:(CityViewController *)cityVC didCity:(NSString *)cityName{
    if (cityVC.from == FromTrainBegin) {
        [self.beginCity setTitle:cityName forState:UIControlStateNormal];
    }
    else if(cityVC.from == FromTrainEnd){
        [self.endCity setTitle:cityName forState:UIControlStateNormal];
    }
}

-(void)selectSureBtnClick:(UIButton *)sender{
    [self.date setTitle:self.time forState:UIControlStateNormal];
}
@end
