//
//  WhereBasicViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/22.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "WhereBasicViewController.h"
#import "WhereBasic.h"
#import "WhereBasicCell.h"
#import "AddWhereBasicViewController.h"
#import <BmobSDK/Bmob.h>
#import "ModifyViewController.h"
#import "MBProgressHUD+Extension.h"
#import "CustomWhereViewController.h"
#import "PartTime.h"
#import "PartTimeListViewController.h"
#import "DetailWhereViewController.h"
#import "CustomGroup.h"
#import "Train.h"
#import "ScenicSpot.h"
#import "Accommodation.h"
#import "ScenicSpotDtailed.h"

@interface WhereBasicViewController ()<UITableViewDataSource,UITableViewDelegate,clickWhereBasicDelegate>{
    int isFre;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic , strong)IBOutlet UIView *mask;
@property (strong,nonatomic) NSMutableArray *resultArray;
@property (strong,nonatomic) WhereBasic *basic;
@property(strong,nonatomic)NSMutableArray *datas;
@property(strong,nonatomic)NSMutableArray *customDatas;//最终结果
@property(strong,nonatomic)NSMutableArray *results;//按天数排序好的

- (IBAction)addWhere:(UIButton *)sender;

@end

@implementation WhereBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.resultArray = [NSMutableArray array];
    self.basic = [[WhereBasic alloc]init];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self addTap];
    self.datas = [NSMutableArray array];
    self.customDatas = [NSMutableArray array];
    self.results = [NSMutableArray array];
    isFre =0;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.customDatas removeAllObjects];
    isFre = 0;
    //设置导航栏主题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回键字体的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"旅游路线";
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    //设置导航栏右边的
    if(![self.isViewContro isEqualToString:@"自定义兼职"]){
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"gc_message_more_button"] style:UIBarButtonItemStylePlain  target:self action:@selector(saveMessage:)];
    }
    BmobUser *bUser = [BmobUser getCurrentUser];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"WhereBasic"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.resultArray removeAllObjects];
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"userID"]isEqualToString:bUser.username]) {
                WhereBasic *basic = [[WhereBasic alloc]init];
                basic.title = [obj objectForKey:@"title"];
                basic.date = [obj objectForKey:@"date"];
                basic.imageName = [obj objectForKey:@"imageName"];
                basic.cityName = [obj objectForKey:@"cityName"];
                basic.objectId = [obj objectId];
                [self.resultArray addObject:basic];
            }
        }
        [self.tableView reloadData];
    }];
    [self.tableView reloadData];
   
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.basic = self.resultArray[indexPath.row];
    static NSString *CellIdentifier = @"WhereBasicTableViewCell";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"WhereBasicCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    WhereBasicCell *cell = (WhereBasicCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:self.basic.imageName]];
    cell.basic = self.basic;
    cell.modify.tag = indexPath.row;
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.basic =self.resultArray[indexPath.row];
    if([self.isViewContro isEqualToString:@"自定义兼职"]){
        BmobQuery *bquery = [BmobQuery queryWithClassName:@"PartTime"];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            [self.datas removeAllObjects];
            for (BmobObject *obj in array) {
                if ([[obj objectForKey:@"cityName"] isEqualToString:self.basic.cityName]) {
                    PartTime *partTime = [[PartTime alloc]init];
                    partTime.tile = [obj objectForKey:@"title"];
                    partTime.workTime = [obj objectForKey:@"workTime"];
                    partTime.address = [obj objectForKey:@"address"];
                    partTime.gender = [obj objectForKey:@"gender"];
                    partTime.treatment = [obj objectForKey:@"treatment"];
                    partTime.cityName = [obj objectForKey:@"cityName"];
                    partTime.URL = [obj objectForKey:@"URL"];
                    [self.datas addObject:partTime];
                }
            }
            PartTimeListViewController *vc = [[PartTimeListViewController alloc]init];
            vc.resultArray = [NSMutableArray array];
            vc.resultArray = self.datas;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }
    else{
        [self add1];
    }
    }
-(void)add1{
    dispatch_group_t group = dispatch_group_create();
    BmobQuery *bquery = [[BmobQuery alloc]init];
    NSString *bql = @"select * from CustomWhere where objectUserID = ? group by day order by day";
    NSArray *place = @[self.basic.objectId];
    __block int num =0;
    [bquery queryInBackgroundWithBQL:bql pvalues:place block:^(BQLQueryResult *result, NSError *error) {
        if (result.resultsAry.count == 0) {
            isFre = 1;
        }else{
        for (NSDictionary *dic in result.resultsAry) {
            int i =[[[dic valueForKey:@"_bmobDataDic"] valueForKey:@"day"]intValue];
            if (i>num) {
                num = i;
            }
        }
    }
        if (isFre == 0) {
            BmobQuery *bquery1 = [BmobQuery queryWithClassName:@"CustomWhere"];
            dispatch_group_enter(group);
            [bquery1 findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                NSMutableArray *array0  = [NSMutableArray array];
                for (BmobObject *obj in array) {
                    if ([[obj objectForKey:@"objectUserID"] isEqualToString:self.basic.objectId]) {
                        [array0 addObject:obj];
                    }
                }
                [self.results removeAllObjects];
                for (int i =0; i<num+1; i++) {
                    NSMutableArray *dayArray = [NSMutableArray array];
                    [dayArray removeAllObjects];
                    for (BmobObject *obj in array0) {
                        if ([[obj objectForKey:@"day"]intValue] == i) {
                            [dayArray addObject:obj];
                        }
                    }
                    [self.results addObject:dayArray];
                }
                dispatch_group_leave(group);
            }];
            
            for (int i=0 ;i<self.results.count; i++) {
                NSArray *array2 = self.results[i];
                CustomGroup *grp = [[CustomGroup alloc] init];
                if (grp.settingItems == nil) {
                    grp.settingItems = [NSMutableArray array];
                }
                int count = i+1;
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
                for (BmobObject *obj in array2) {
                    dispatch_group_enter(group);
                    if ([[obj objectForKey:@"isType"]isEqualToString:@"景点"]) {
                        BmobQuery *bqu = [BmobQuery queryWithClassName:@"CustomWhere"];
                        [bqu includeKey:@"scenc"];
                        dispatch_group_enter(group);
                        [bqu getObjectInBackgroundWithId:[obj objectId] block:^(BmobObject *object, NSError *error) {
                            dispatch_group_leave(group);
                            BmobObject *scenObj=[object objectForKey:@"scenc"];
                            BmobQuery *bqu = [BmobQuery queryWithClassName:@"Scenc"];
                            [bqu includeKey:@"scencDetail"];
                            dispatch_group_enter(group);
                            [bqu getObjectInBackgroundWithId:[scenObj objectId] block:^(BmobObject *object, NSError *error) {
                                BmobObject *scenDeObj=[object objectForKey:@"scencDetail"];
                                ScenicSpotDtailed *scenDe = [[ScenicSpotDtailed alloc]init];
                                scenDe.productId = [scenObj objectForKey:@"productId"];
                                scenDe.address = [scenDeObj objectForKey:@"address"];
                                scenDe.spotName = [scenDeObj objectForKey:@"spotName"];
                                scenDe.descriptionText = [scenDeObj objectForKey:@"descriptionText"];
                                scenDe.imageUrl = [scenDeObj objectForKey:@"imageUrl"];
                                isFre = 1;
                                [grp.settingItems addObject:scenDe];
                                dispatch_group_leave(group);
                            }];
                        }];
                    }
                    else if ([[obj objectForKey:@"isType"]isEqualToString:@"火车"]){
                        BmobQuery *bqu = [BmobQuery queryWithClassName:@"CustomWhere"];
                        [bqu includeKey:@"train"];
                        dispatch_group_enter(group);
                        [bqu getObjectInBackgroundWithId:[obj objectId] block:^(BmobObject *object, NSError *error) {
                            BmobObject *trainObj=[object objectForKey:@"train"];
                            Train *train = [[Train alloc]init];
                            train.train_no =[trainObj objectForKey:@"train_no"];
                            train.station_train_code = [trainObj objectForKey:@"station_train_code"];
                            train.start_station_name = [trainObj objectForKey:@"start_station_name"];
                            train.end_station_name =[trainObj objectForKey:@"end_station_name"];
                            train.from_station_name =[trainObj objectForKey:@"from_station_name"];
                            train.to_station_name =[trainObj objectForKey:@"to_station_name"];
                            train.from_station_no =[trainObj objectForKey:@"from_station_no"];
                            train.to_station_no =[trainObj objectForKey:@"to_station_no"];
                            train.start_train_date =[trainObj objectForKey:@"start_train_date"];
                            train.start_time =[trainObj objectForKey:@"start_time"];
                            train.arrive_time =[trainObj objectForKey:@"arrive_time"];
                            train.lishi =[trainObj objectForKey:@"lishi"];
                            train.gr_num =[trainObj objectForKey:@"gr_num"];
                            train.qt_num =[trainObj objectForKey:@"qt_num"];
                            train.rw_num =[trainObj objectForKey:@"rw_num"];
                            train.rz_num =[trainObj objectForKey:@"rz_num"];
                            train.tz_num =[trainObj objectForKey:@"tz_num"];
                            train.wz_num =[trainObj objectForKey:@"wz_num"];
                            train.yw_num =[trainObj objectForKey:@"yw_num"];
                            train.yz_num =[trainObj objectForKey:@"yz_num"];
                            train.ze_num =[trainObj objectForKey:@"ze_num"];
                            train.zy_num =[trainObj objectForKey:@"zy_num"];
                            train.swz_num =[trainObj objectForKey:@"swz_num"];
                            train.objectId = [trainObj objectId];
                            [grp.settingItems addObject:train];
                            isFre = 1;
                            dispatch_group_leave(group);
                        }];
                        
                    }
                    else if ([[obj objectForKey:@"isType"]isEqualToString:@"住宿"]){
                        dispatch_group_enter(group);
                        BmobQuery *bqu = [BmobQuery queryWithClassName:@"CustomWhere"];
                        [bqu includeKey:@"accommodation"];
                        [bqu getObjectInBackgroundWithId:[obj objectId] block:^(BmobObject *object, NSError *error) {
                            BmobObject *accObj=[object objectForKey:@"accommodation"];
                            Accommodation *accommodation = [[Accommodation alloc]init];
                            accommodation.destination = [accObj objectForKey:@"destination"];
                            accommodation.price = [accObj objectForKey:@"price"];
                            accommodation.imageName = [accObj objectForKey:@"imageName"];
                            accommodation.address = [accObj objectForKey:@"address"];
                            accommodation.hotelName = [accObj objectForKey:@"hotelName"];
                            accommodation.score = [accObj objectForKey:@"score"];
                            accommodation.URL = [accObj objectForKey:@"URL"];
                            [grp.settingItems addObject:accommodation];
                            dispatch_group_leave(group);
                            isFre = 1;
                        }];
                    }
                    dispatch_group_leave(group);
                }
                [self.customDatas addObject:grp];
            }
            
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                if (isFre == 1) {
                    CustomWhereViewController *vc = [[CustomWhereViewController alloc]init];
                    vc.basic = [[WhereBasic alloc]init];
                    vc.basic = self.basic;
                    vc.datas = [NSMutableArray array];
                    vc.datas = self.customDatas;
                    isFre =0 ;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            });
        }
        else{
            CustomWhereViewController *vc = [[CustomWhereViewController alloc]init];
            vc.basic = [[WhereBasic alloc]init];
            vc.basic = self.basic;
            vc.datas = [NSMutableArray array];
            vc.datas = self.customDatas;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}
#pragma mark 左滑删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"删除" message:@"你确定要删除行程吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    self.basic = self.resultArray[indexPath.row];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        return;
    }
    else{
        [self.resultArray removeObject:self.basic];
        BmobObject *bObject = [BmobObject objectWithoutDatatWithClassName:@"WhereBasic" objectId:self.basic.objectId];
        [bObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [MBProgressHUD showSuccess:@"删除成功"];
            }
        }];
        [self.tableView reloadData];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)addTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    [self.mask addGestureRecognizer:tap];
}
//隐藏界面
- (void)hide
{
    [UIView animateWithDuration:0.5 animations:^(void) {
        self.mask.alpha = 0;
    }];
}

-(void)saveMessage:(UIButton *)sender{
    [UIView animateWithDuration:1.0 animations:^(void) {
        self.mask.alpha = 1;
    }];
}
- (IBAction)addWhere:(UIButton *)sender {
    self.mask.alpha = 0;
    AddWhereBasicViewController *vc = [[AddWhereBasicViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)whereBasiceModifyBtnClick:(UIButton *)sender{
    ModifyViewController *vc = [[ModifyViewController alloc]init];
    vc.basic = [[WhereBasic alloc]init];
    vc.basic = self.resultArray[sender.tag];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
