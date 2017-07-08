//
//  PartTimeListViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/30.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "PartTimeListViewController.h"
#import "PartTime.h"
#import "PartTimeCell.h"
#import "WhereWebViewController.h"

@interface PartTimeListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic) PartTime *partTime;

@end

@implementation PartTimeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏主题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回键字体的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"兼职搜索结果";
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.partTime = self.resultArray[indexPath.row];
    static NSString *CellIdentifier = @"PartTimeCell";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"PartTimeCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    PartTimeCell *cell = (PartTimeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.partTime = self.partTime;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.partTime = self.resultArray[indexPath.row];
    WhereWebViewController *vc= [[WhereWebViewController alloc]init];
    vc.URL = self.partTime.URL;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
