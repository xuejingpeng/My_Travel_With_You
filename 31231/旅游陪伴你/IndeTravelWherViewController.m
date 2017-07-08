//
//  IndeTravelWherViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/21.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "IndeTravelWherViewController.h"
#import "IndeTravel.h"
#import "IndeTravelTableViewCell.h"
#import "WhereWebViewController.h"
#import "TravelViewController.h"
#import <BmobSDK/Bmob.h>
#import "Travel.h"
#import "PartTime.h"
#import "PartTimeListViewController.h"

@interface IndeTravelWherViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong,nonatomic)IndeTravel *travel;
@property (strong,nonatomic)NSMutableArray *allArray;
@property(strong,nonatomic) NSMutableArray *datas;

@end

@implementation IndeTravelWherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.travel = [[IndeTravel alloc]init];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.allArray = [NSMutableArray array];
    self.datas = [NSMutableArray array];
}
-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏主题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回键字体的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"自助游路线";
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    //设置导航栏右边的
    if(![self.isViewContro isEqualToString:@"自助游兼职"]){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"gc_message_more_button"] style:UIBarButtonItemStylePlain  target:self action:@selector(saveMessage:)];
    }
    BmobUser *bUser = [BmobUser getCurrentUser];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"TravelWhere"];
    [self.resultArray removeAllObjects];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"userID"] isEqualToString:bUser.username]) {
                IndeTravel *travel = [[IndeTravel alloc]init];
                travel.cityName = [obj objectForKey:@"cityName"];
                travel.travelURL = [obj objectForKey:@"travelURL"];
                travel.travelName = [obj objectForKey:@"travelName"];
                travel.startTime = [obj objectForKey:@"startTime"];
                [self.resultArray addObject:travel];
            }
        }
       [self.tableView reloadData];
    }];
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
    return self.resultArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.travel = self.resultArray[indexPath.row];
    static NSString *CellIdentifier = @"IntravelTableViewCell";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"IndeTravelTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    IndeTravelTableViewCell *cell = (IndeTravelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.inTravel = self.travel;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.travel = self.resultArray[indexPath.row];
    if([self.isViewContro isEqualToString:@"自助游兼职"]){
        BmobQuery *bquery = [BmobQuery queryWithClassName:@"PartTime"];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            [self.datas removeAllObjects];
            for (BmobObject *obj in array) {
                if ([self.travel.cityName rangeOfString:[obj objectForKey:@"cityName"]].location!= NSNotFound) {
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
    WhereWebViewController *vc = [[WhereWebViewController alloc]init];
    vc.URL = self.travel.travelURL;
    [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)saveMessage:(UIButton *)sender{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"Travel"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.allArray  removeAllObjects];
        for (BmobObject *obj in array) {
            Travel *travel = [[Travel alloc]init];
            travel.traveName = [obj objectForKey:@"travelName"];
            travel.price = [obj objectForKey:@"price"];
            travel.satisfaction = [obj objectForKey:@"satisfaction"];
            travel.likeCount = [obj objectForKey:@"likeCount"];
            travel.commentCount = [obj objectForKey:@"commentCount"];
            travel.where = [obj objectForKey:@"where"];
            travel.dayCount = [obj objectForKey:@"dayCount"];
            travel.detailed = [obj objectForKey:@"detailed"];
            travel.imageNames = [obj objectForKey:@"imageNames"];
            [self.allArray addObject:travel];
        }
        TravelViewController *VC = [[TravelViewController alloc]initWithNibName:@"TravelViewController" bundle:nil];
        VC.resultArray = self.allArray;
        VC.resultDatas = self.resultArray;
        VC.isViewController = @"添加自助旅游";
        [self.navigationController pushViewController:VC animated:YES];
    }];
}
@end
