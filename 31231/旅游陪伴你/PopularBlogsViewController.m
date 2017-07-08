//
//  PopularBlogsViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/2.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "PopularBlogsViewController.h"
#import "ApiStoreSDK.h"
#import "PopularBlogsTableViewController.h"
#import "MBProgressHUD+Extension.h"
#import "DataServers.h"

@interface PopularBlogsViewController (){
    NSMutableArray *datas;
}
@property (weak, nonatomic) IBOutlet UITextField *placeName;
@property (strong,nonatomic)DataServers *data;
- (IBAction)searchBtn:(UIButton *)sender;

@end

@implementation PopularBlogsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [[DataServers alloc]init];
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
    self.title = @"游记搜索";
    self.tabBarController.tabBar.hidden = YES;
}

- (IBAction)searchBtn:(UIButton *)sender {
    if(![self.placeName.text isEqualToString:@""]){
        NSString *httpUrl =  @"http://apis.baidu.com/qunartravel/travellist/travellist";
        NSString *query = [self.placeName.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *urlStr = [[NSString alloc]initWithFormat:@"%@?query=%@&page=1",httpUrl,query];
         [MBProgressHUD showMessage:@"正在获取搜索结果...."];
        [self.data gainSynchronizationData:urlStr andBlock:^(NSDictionary *resultDic) {
            NSArray *array = [NSArray array];
            [MBProgressHUD hideHUD];
            array = [[resultDic valueForKey:@"data"] valueForKey:@"books"];
            [self loadDatas:array];
            PopularBlogsTableViewController *VC = [[PopularBlogsTableViewController alloc]init];
            VC.placeName = query;
            VC.datas = [NSMutableArray array];
            VC.datas = datas;
            [self.navigationController pushViewController:VC animated:YES];
        }];
    }
}
#pragma mark - 接收语言数据后解析
-(void)loadDatas:(NSArray *)data{
    if (datas == nil) {
        datas = [NSMutableArray array];
        for (NSDictionary *dict in data) {
            PopularBlog *data = [[PopularBlog alloc]initWithDictionary:dict];
            [datas addObject:data];
        }
    }
    else{
        [datas removeAllObjects];
        for (NSDictionary *dict in data) {
            PopularBlog *data = [[PopularBlog alloc]initWithDictionary:dict];
            [datas addObject:data];
        }
    }
}

@end
