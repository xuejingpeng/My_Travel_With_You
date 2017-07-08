//
//  SEViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/1/8.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "SEViewController.h"
#import "MiniGameViewController.h"
#import "MBProgressHUD+Extension.h"
#import "ApiStoreSDK.h"
#import "LittleJoke.h"
#import "LittleJokeTableViewController.h"
#import "DataServers.h"

@interface SEViewController (){
    NSMutableArray *datas;
}
@property (strong,nonatomic)DataServers *data;
//跳转到小游戏界面
- (IBAction)gameBtn:(UIButton *)sender;
//跳转到笑话短篇
- (IBAction)littleJoke:(UIButton *)sender;

@end

@implementation SEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    datas = [NSMutableArray array];
    self.data = [[DataServers alloc]init];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"u=2052518858,2675443286&fm=21&gp=0"];
    [self.view addSubview:imageView];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏的出现
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    self.title = @"小娱乐";
}

- (IBAction)gameBtn:(UIButton *)sender {
    MiniGameViewController *gameVC = [[MiniGameViewController alloc]initWithNibName:@"MiniGameViewController" bundle:nil];
    [self.navigationController pushViewController:gameVC animated:YES];
}

- (IBAction)littleJoke:(UIButton *)sender {
    NSString *httpUrl =  @"http://japi.juhe.cn/joke/content/text.from";
    int x = arc4random() % 800+1;
    NSString *urlStr = [[NSString alloc]initWithFormat:@"%@?page=%d&pagesize=20&key=e94374bbac9b53556e67d030b260481d",httpUrl,x];
    [MBProgressHUD showMessage:@"正在获取搜索结果...."];
    [self.data gainSynchronizationData:urlStr andBlock:^(NSDictionary *resultDic) {
        [MBProgressHUD hideHUD];
        NSArray *array = [NSArray array];
        array = [[resultDic valueForKey:@"result"] valueForKey:@"data"];
        [self loadDatas:array];
        LittleJokeTableViewController *VC = [[LittleJokeTableViewController alloc]initWithNibName:@"LittleJokeTableViewController" bundle:nil];
        VC.littleJokes = [NSMutableArray array];
        VC.littleJokes = datas;
        [self.navigationController pushViewController:VC animated:YES];
    }];
}

#pragma mark - 接收语言数据后解析
-(void)loadDatas:(NSArray *)data{
        [datas removeAllObjects];
        for (NSDictionary *dict in data) {
            LittleJoke *data = [[LittleJoke alloc]initWithDictionary:dict];
            [datas addObject:data];
        }
}

@end
