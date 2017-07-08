//
//  HelpViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/14.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "HelpViewController.h"
#import "HelpItem.h"
#import "HTMLViewController.h"

@interface HelpViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *htmls;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView setTableFooterView:v];
    [self htmls];
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
    self.title = @"帮助页面";
    self.tabBarController.tabBar.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(NSArray *)htmls{
    
    if (_htmls == nil) {
        //获得JSON文件路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"help.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *htmlArray = [NSMutableArray array];
        for (NSDictionary *dict in array) {
            HelpItem *item = [HelpItem helpItemWithDict:dict];
            [htmlArray addObject:item];
        }
        _htmls = htmlArray;
    }
    return _htmls;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.htmls.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    HelpItem *item = self.htmls[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"iconfont-dian"];
    cell.textLabel.text = item.title;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HTMLViewController *htmlVC = [[HTMLViewController alloc] init];
    
    htmlVC.helpItem = self.htmls[indexPath.row];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:htmlVC];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
