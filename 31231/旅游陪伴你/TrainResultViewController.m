//
//  TrainResultViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/9.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "TrainResultViewController.h"
#import "Train.h"
#import "TrainTableViewCell.h"
#import "DataServers.h"
#import "TrainDetailed.h"
#import "TrainDetailedViewController.h"
#import "MBProgressHUD+Extension.h"

@interface TrainResultViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *isData;
@property (strong,nonatomic) DataServers *data;
@property (strong,nonatomic) TrainDetailed *trainDe;



@end

@implementation TrainResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.isEmpty isEqualToString:@"没有数据"]) {
        self.isData.hidden = NO;
    }
    else
        self.isData.hidden = YES;
    self.data = [[DataServers alloc]init];
}
-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏主题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回键字体的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"搜索结果";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Train *data = self.dataArray[indexPath.row];
    static NSString *CellIdentifier = @"tableViewCell";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"TrainTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    TrainTableViewCell *cell = (TrainTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.train = data;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Train *train = self.dataArray[indexPath.row];
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
//        VC.date = self.date;
        if (self.basic) {
            VC.basic = [[WhereBasic alloc]init];
            VC.basic = self.basic;
            VC.datas = [NSMutableArray array];
            VC.datas = self.datas;
        }
        [MBProgressHUD hideHUD];
        [self.navigationController pushViewController:VC animated:YES];
    }];
    
}
@end
