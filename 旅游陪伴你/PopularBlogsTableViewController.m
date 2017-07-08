//
//  PopularBlogsTableViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/2.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "PopularBlogsTableViewController.h"
#import "ApiStoreSDK.h"
#import <MJRefresh.h>
#import "PopularBlog.h"
#import "PopularTableViewCell.h"
#import "DataServers.h"
#import "AccommodationDeViewController.h"

@interface PopularBlogsTableViewController ()
//获取刷新状态
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;
//设置控件颜色
@property (nonatomic, strong) UIColor *tintColor;
//设置控件文字
//@property (nullable, nonatomic, strong) NSAttributedString *attributedTitle UI_APPEARANCE_SELECTOR;
@property (strong,nonatomic)DataServers *data;
@end

@implementation PopularBlogsTableViewController
static int x;
- (void)viewDidLoad {
    [super viewDidLoad];
    x=2;
    self.data = [[DataServers alloc]init];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSString *httpUrl =  @"http://apis.baidu.com/qunartravel/travellist/travellist";
        x = arc4random() % 50+1;
        NSString *urlStr = [[NSString alloc]initWithFormat:@"%@?query=%@&page=%d",httpUrl,self.placeName,x];
        [self.data gainSynchronizationData:urlStr andBlock:^(NSDictionary *resultDic) {
            NSArray *array = [NSArray array];
            array = [[resultDic valueForKey:@"data"] valueForKey:@"books"];
            [self loadDatas:array];
            
        }];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSString *httpUrl =  @"http://apis.baidu.com/qunartravel/travellist/travellist";
        x++;
        NSString *urlStr = [[NSString alloc]initWithFormat:@"%@?query=%@&page=%d",httpUrl,self.placeName,x];
        [self.data gainSynchronizationData:urlStr andBlock:^(NSDictionary *resultDic) {
            NSArray *array = [NSArray array];
            array = [[resultDic valueForKey:@"data"] valueForKey:@"books"];
            NSMutableArray *array1 = [NSMutableArray array];
            for (NSDictionary *dict in array) {
                PopularBlog *data = [[PopularBlog alloc]initWithDictionary:dict];
                [array1 addObject:data];
            }
            [self.datas insertObjects:array1 atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.datas.count, array1.count)]];
            
        }];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }];
}



-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
    //设置导航栏的出现
    self.navigationController.navigationBarHidden = NO;
    //设置导航栏主题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回键字体的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"搜索结果";
    self.tabBarController.tabBar.hidden = YES;
    
}
#pragma mark - 接收语言数据后解析
-(void)loadDatas:(NSArray *)data{
    if (data.count != 0) {
        [self.datas removeAllObjects];
        for (NSDictionary *dict in data) {
            PopularBlog *data = [[PopularBlog alloc]initWithDictionary:dict];
            [self.datas addObject:data];
        }
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopularBlog *data = self.datas[indexPath.row];
    static NSString *CellIdentifier = @"tableViewCell";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"PopularTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
     PopularTableViewCell *cell = (PopularTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.popularBlog = data;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AccommodationDeViewController *vc = [[AccommodationDeViewController alloc]init];
    vc.isViewContrller = @"热门游记";
    PopularBlog *data = self.datas[indexPath.row];
    vc.popularBlog = data;
    vc.popularBlogURL = data.bookUrl;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
