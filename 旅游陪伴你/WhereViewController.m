//
//  WhereViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/1/8.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "WhereViewController.h"
#import "IndeTravel.h"
#import <BmobSDK/Bmob.h>
#import "IndeTravelWherViewController.h"
#import "WhereBasicViewController.h"

@interface WhereViewController ()

@property(strong,nonatomic)NSMutableArray *resultArray;
- (IBAction)IndeTravel:(UIButton *)sender;

- (IBAction)CustomTour:(UIButton *)sender;

@end

@implementation WhereViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"Where"];
    [self.view addSubview:imageView];
    self.navigationController.navigationBarHidden = YES;
    self.resultArray = [NSMutableArray array];
}
-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏的隐藏
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    self.title = @"去哪儿";

}
- (IBAction)IndeTravel:(UIButton *)sender {
        IndeTravelWherViewController *vc = [[IndeTravelWherViewController alloc]init];
        vc.resultArray = [NSMutableArray array];
        [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)CustomTour:(UIButton *)sender {
    WhereBasicViewController *vc = [[WhereBasicViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
