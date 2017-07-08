//
//  LittleJokeTableViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/15.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "LittleJokeTableViewController.h"
#import "LittleJoke.h"
#import "LittleJokeTableViewCell.h"
#import "MBProgressHUD+Extension.h"
#import "ApiStoreSDK.h"
#import "DataServers.h"

@interface LittleJokeTableViewController (){
    NSMutableArray *datas;
}
@property (strong,nonatomic)DataServers *data;
//@property (strong,nonatomic)NSMutableArray *heights;
//获取刷新状态
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
//设置控件颜色
@property (nonatomic, strong) UIColor *tintColor;
//设置控件文字
@property (nullable, nonatomic, strong) NSAttributedString *attributedTitle UI_APPEARANCE_SELECTOR;
@end

@implementation LittleJokeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.data = [[DataServers alloc]init];
//    self.heights = [NSMutableArray array];
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    refresh.tintColor = [UIColor grayColor];
    [refresh addTarget:self action:@selector(pullToRefresh) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}
//下拉刷新
- (void)pullToRefresh
{
    //模拟网络访问
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中"];
    double delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString *httpUrl =  @"http://japi.juhe.cn/joke/content/text.from";
        int x = arc4random() % 800+1;
        NSString *urlStr = [[NSString alloc]initWithFormat:@"%@?page=%d&pagesize=20&key=e94374bbac9b53556e67d030b260481d",httpUrl,x];
        [self.data gainSynchronizationData:urlStr andBlock:^(NSDictionary *resultDic) {
            NSArray *array = [NSArray array];
            array = [[resultDic valueForKey:@"result"] valueForKey:@"data"];
            [self loadDatas:array];
        }];
        [self.tableView reloadData];
        //刷新结束时刷新控件的设置
        [self.refreshControl endRefreshing];
        self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
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
    self.title = @"笑话";
    self.tabBarController.tabBar.hidden = YES;
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 接收语言数据后解析
-(void)loadDatas:(NSArray *)data{
    if (data.count != 0) {
        [self.littleJokes removeAllObjects];
        for (NSDictionary *dict in data) {
            LittleJoke *data = [[LittleJoke alloc]initWithDictionary:dict];
            [self.littleJokes addObject:data];
        }
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.littleJokes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LittleJoke *data = self.littleJokes[indexPath.row];
    static NSString *CellIdentifier = @"tableViewCell";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"LittleJokeTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    LittleJokeTableViewCell *cell = (LittleJokeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.littleJoke = data;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 180;
//}


@end
