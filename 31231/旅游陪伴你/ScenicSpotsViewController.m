//
//  ScenicSpotsViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/20.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "ScenicSpotsViewController.h"
#import "ScenicSpot.h"
#import "DataServers.h"
#import "ScenicSpotDtailed.h"
#import "PriceList.h"
#import "ScenicDetailedViewController.h"

@interface ScenicSpotsViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//搜索到的结果
@property (nonatomic, retain) NSMutableArray *results;
@property (nonatomic,strong)DataServers *data;

@end

@implementation ScenicSpotsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.searchBar setPlaceholder:@"搜索景点"];
    self.searchBar.delegate = self;
    self.searchController.searchResultsDelegate= self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.delegate = self;
    self.data = [[DataServers alloc]init];
    self.searchController.searchResultsTableView.estimatedRowHeight = 50;
    self.searchController.searchResultsTableView.rowHeight = UITableViewAutomaticDimension;
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
    self.tabBarController.tabBar.hidden = YES;
    self.title = @"景点";
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) viewDidLayoutSubviews
{
    if(floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset = self.topLayoutGuide.length;
        viewBounds.origin.y = topBarOffset * -1;
        self.view.bounds = viewBounds;
    }
}
#pragma mark - UISearchDisplayDelegate
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString  scope:[_searchBar scopeButtonTitles][_searchBar.selectedScopeButtonIndex]];
    return YES;
}
-(BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
    [self filterContentForSearchText:_searchBar.text scope:_searchBar.scopeButtonTitles[searchOption]];
    return YES;
}
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    for (int i = 0; i< self.scenicSpots.count; i++) {
        NSMutableString *str = [NSMutableString string];
        [str appendString:[NSString stringWithFormat:@"%@ , 地址：%@",((ScenicSpot *)self.scenicSpots[i]).spotName,((ScenicSpot *)self.scenicSpots[i]).address]];
        //        NSString *storeString = ((ScenicSpot *)self.scenicSpots[i]).address;
        NSRange storeRange = NSMakeRange(0, str.length);
        NSRange foundRange = [str rangeOfString:searchText options:searchOptions range:storeRange];
        if (foundRange.length) {
            [tempResults addObject:self.scenicSpots[i]];
        }
    }
    [self.results removeAllObjects];
    _results = [NSMutableArray arrayWithArray:tempResults];
}

#pragma mark - UITableView的相关操作
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _searchController.searchResultsTableView) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor =  [UIColor colorWithRed:236/255.0 green:239/255.0 blue:243/255.0 alpha:1];
        return _results.count;
    }
    else {
        return self.scenicSpots.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.tableView) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        ScenicSpot *city = self.scenicSpots[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"iconfont-dian"];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = [UIColor grayColor];
        NSMutableString *str = [NSMutableString string];
        [str appendString:[NSString stringWithFormat:@"%@ , 地址：%@",city.spotName,city.address]];
        cell.textLabel.text = str;
        return cell;
    }
    if ([tableView isEqual:tableView]) {
        static NSString *kCellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        }
        if (tableView == self.searchController.searchResultsTableView) {
            ScenicSpot *city =  _results[indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"iconfont-dian"];
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.textColor = [UIColor grayColor];
            NSMutableString *str = [NSMutableString string];
            [str appendString:[NSString stringWithFormat:@"%@ , 地址：%@",city.spotName,city.address]];
            
            cell.textLabel.text = str;
        }
        return cell;
    }
    return  nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ScenicSpot *scenic = [[ScenicSpot alloc]init];
    if (tableView == self.searchController.searchResultsTableView) {
        scenic =_results[indexPath.row];
    }
    else{
        scenic =self.scenicSpots[indexPath.row];
    }
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
        vc.scenicId = scenic.objectId;
        vc.scenicSpot = scenic;
        if (self.basic) {
            vc.basic = [[WhereBasic alloc]init];
            vc.basic = self.basic;
            vc.datas = [NSMutableArray array];
            vc.datas = self.datas;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
