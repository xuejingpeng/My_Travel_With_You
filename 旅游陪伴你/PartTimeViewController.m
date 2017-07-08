//
//  PartTimeViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/30.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "PartTimeViewController.h"
#import "WhereBasicViewController.h"
#import "IndeTravelWherViewController.h"


@interface PartTimeViewController ()
//自助游
- (IBAction)IndependentPartTime:(UIButton *)sender;
//自定义
- (IBAction)CustomPartTime:(UIButton *)sender;

@end

@implementation PartTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"login"];
    [self.view addSubview:imageView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏主题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回键字体的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"兼职";
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}


- (IBAction)IndependentPartTime:(UIButton *)sender {
    IndeTravelWherViewController *vc = [[IndeTravelWherViewController alloc]init];
    vc.isViewContro = @"自助游兼职";
    vc.resultArray = [NSMutableArray array];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)CustomPartTime:(UIButton *)sender {
    
    WhereBasicViewController *vc = [[WhereBasicViewController alloc]init];
    vc.isViewContro = @"自定义兼职";
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
