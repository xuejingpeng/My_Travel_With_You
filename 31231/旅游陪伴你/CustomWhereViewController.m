//
//  CustomWhereViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/24.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "CustomWhereViewController.h"
#import "DetailWhereViewController.h"
#import "CustomGroup.h"
#import "Train.h"
#import "ScenicSpot.h"
#import "Accommodation.h"
#import "TrainTableViewCell.h"
#import "accommodationTableViewCell.h"
#import "ScenicTableViewCell.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+Extension.h"
#import "ScenicSpotDtailed.h"
#import "ScenicDetailedViewController.h"
#import "DataServers.h"
#import "TrainDetailedViewController.h"
#import "PriceList.h"
#import "AccommodationDeViewController.h"



@interface CustomWhereViewController ()<UITableViewDataSource,UITableViewDelegate,DatasDelegate>
- (IBAction)addDay:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) DataServers *data;
@property (strong,nonatomic) TrainDetailed *trainDe;

@end

@implementation CustomWhereViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [[DataServers alloc]init];
}
-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏主题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回键字体的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"旅游路线";
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CustomGroup *group = self.datas[section];
    return group.settingItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomGroup *grp = self.datas[indexPath.section];
    if ([grp.settingItems[indexPath.row] isKindOfClass:[Train class]]) {
        Train *train = grp.settingItems[indexPath.row];
        static NSString *CellIdentifier = @"TrainTableViewCell";
        BOOL nibsRegistered = NO;
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:@"TrainTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
            nibsRegistered = YES;
        }
        TrainTableViewCell *cell = (TrainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.train = train;
        return cell;
    }
    else if ([grp.settingItems[indexPath.row] isKindOfClass:[ScenicSpotDtailed class]]) {
        ScenicSpotDtailed *scenc = grp.settingItems[indexPath.row];
        static NSString *CellIdentifier = @"scencTableViewCell";
        BOOL nibsRegistered = NO;
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:@"ScenicTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
            nibsRegistered = YES;
        }
        ScenicTableViewCell *cell = (ScenicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.scenic = scenc;
        return cell;
    }
    else if ([grp.settingItems[indexPath.row] isKindOfClass:[Accommodation class]]){
        Accommodation *data = grp.settingItems[indexPath.row];
        static NSString *CellIdentifier = @"AccommdationCell";
        BOOL nibsRegistered = NO;
        if (!nibsRegistered) {
            UINib *nib = [UINib nibWithNibName:@"accommodationTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
            nibsRegistered = YES;
        }
        accommodationTableViewCell *cell = (accommodationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.accommodation = data;
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomGroup *grp = self.datas[indexPath.section];
    if ([grp.settingItems[indexPath.row] isKindOfClass:[Train class]]) {
        return 80;
    }
    else if ([grp.settingItems[indexPath.row] isKindOfClass:[ScenicSpotDtailed class]]) {
        return 100;
    }
    else if ([grp.settingItems[indexPath.row] isKindOfClass:[Accommodation class]]){
        return 120;
    }
    else{
        return 50;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomGroup *grp = self.datas[indexPath.section];
    if ([grp.settingItems[indexPath.row] isKindOfClass:[Train class]]) {
        Train *train = grp.settingItems[indexPath.row];
        NSString *train_no =train.train_no;
        NSString *from_station_no = train.from_station_no;
        NSString *to_station_no =train.to_station_no;
        NSString *date = train.date;
        [MBProgressHUD showMessage:@"正在获取详情中..."];
        NSString *urlStr = [[NSString alloc]initWithFormat:@"http://apis.juhe.cn/train/ticket.price.php?train_no=%@&from_station_no=%@&to_station_no=%@&date=%@&key=2e6b5b32ea73feb500622dfd5b1ef5f9",train_no,from_station_no,to_station_no,date];
        [self.data gainTrainDeInfo:urlStr andBlock:^(NSDictionary *resultDic) {
            NSDictionary *dic = [[NSDictionary alloc]init];
            dic = [resultDic valueForKey:@"result"];
            self.trainDe = [[TrainDetailed alloc]initWithDictionary:dic];
            TrainDetailedViewController *VC = [[TrainDetailedViewController alloc]init];
            VC.train = [[Train alloc]init];
            VC.train = train;
            VC.trainDe = [[TrainDetailed alloc]init];
            VC.trainDe = self.trainDe;
            [MBProgressHUD hideHUD];
            [self.navigationController pushViewController:VC animated:YES];
        }];

    }
    else if ([grp.settingItems[indexPath.row] isKindOfClass:[ScenicSpotDtailed class]]) {
        ScenicSpotDtailed *scenic = grp.settingItems[indexPath.row];
        NSString *urlStr = [[NSString alloc]initWithFormat:@"http://apis.baidu.com/apistore/qunaerticket/querydetail?id=%@",scenic.productId];
        [self.data gainSynchronizationData:urlStr andBlock:^(NSDictionary *resultDic) {
            NSDictionary *dic = [[NSDictionary alloc]init];
            dic = [[[[[resultDic valueForKey:@"retData"]valueForKey:@"ticketDetail"]valueForKey:@"data"]valueForKey:@"display"]valueForKey:@"ticket"];
            ScenicSpotDtailed *scenicDt = [[ScenicSpotDtailed alloc]initWithDictionary:dic];
            scenicDt.productId = scenic.productId;
            NSMutableArray *priceList = [[NSMutableArray alloc]init];
            if ([[dic valueForKey:@"priceList"] isKindOfClass:[NSArray class]]) {
                NSArray *array = [[NSArray alloc]init];
                array =[dic valueForKey:@"priceList"];
                for (int  i=0; i<array.count; i++) {
                    PriceList *price = [[PriceList alloc]initWithDictionary:array[i]];
                    [priceList addObject:price];
                }
            }
            else{
                PriceList *price = [[PriceList alloc]initWithDictionary:[dic valueForKey:@"priceList"]];
                [priceList addObject:price];
            }
            ScenicDetailedViewController *vc = [[ScenicDetailedViewController alloc]init];
            vc.scenicDt = scenicDt;
            vc.priceList = priceList;
            [self.navigationController pushViewController:vc animated:YES];
        }];

    }
    else if ([grp.settingItems[indexPath.row] isKindOfClass:[Accommodation class]]){
        AccommodationDeViewController *vc=[[AccommodationDeViewController alloc]init];
        vc.accommodation = [[Accommodation alloc]init];
        vc.accommodation = grp.settingItems[indexPath.row];
        vc.cityName = self.basic.cityName;
        vc.isViewContrller = @"住宿";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
       
    }
}

//设置某个组的头部信息
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    CustomGroup *grp = self.datas[section];
    return grp.headerStr;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 80)];
    CustomGroup *grp = self.datas[section];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.text = grp.headerStr;
    label.textColor = [UIColor colorWithRed:116/255.0 green:91/255.0 blue:182/255.0 alpha:1.0];
    return label;
}
//设置某组的尾部

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    [button setBackgroundColor:[UIColor whiteColor]];
    [button setTitleColor:[UIColor colorWithRed:0/255.0 green:118/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    [button  setTitle:@"新增活动" forState:UIControlStateNormal];
    button.tag = section;
    [button addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
-(void)add:(UIButton *)sender{
    DetailWhereViewController *vc = [[DetailWhereViewController alloc]init];
    vc.basic = [[WhereBasic alloc]init];
    int day = (int)sender.tag;
    self.basic.day = [NSString stringWithFormat:@"%d",day];
    vc.basic = self.basic;
    vc.datas = [NSMutableArray array];
    vc.datas = self.datas;
    ScenicDetailedViewController *scenivDeVC = [[ScenicDetailedViewController alloc]init];
    scenivDeVC.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  80;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40;
}
-(void)returnData:(NSMutableArray *)datas{
    [self.datas removeAllObjects];
    self.datas = datas;
    [self.tableView reloadData];
}

- (IBAction)addDay:(UIButton *)sender {
    int count = (int)self.datas.count+1;
    CustomGroup *grp = [[CustomGroup alloc] init];
    if (count == 1) {
        grp.headerStr = [NSString stringWithFormat:@"第%d天（%@）",count,self.basic.date];
    }
    else{
    //日期格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    //把字符串变成NSDate
    NSDate *destDate = [formatter dateFromString:self.basic.date];
    //把NSDate多加8个小时
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: destDate];
    NSDate *fromDate = [destDate  dateByAddingTimeInterval: frominterval];
    //把NSDate的时间多加一天
    NSDate *newDate = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([fromDate timeIntervalSinceReferenceDate] + 24*3600*(count - 1))];
    NSString *date = [formatter stringFromDate:newDate];
       grp.headerStr = [NSString stringWithFormat:@"第%d天（%@）",count,date];
    }
    [self.datas addObject:grp];
    [self.tableView reloadData];
}
@end
