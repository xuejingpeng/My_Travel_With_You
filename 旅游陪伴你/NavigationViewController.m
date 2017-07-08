//
//  NavigationViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/1/2.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

//该方法在OC类加载到内存之后，运行一次，在整个类的生命周期中，只运行一次。
+ (void)initialize{
    
    //设置导航栏主题
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:63/255.0 green:186/255.0 blue:217/255.0 alpha:1.0]];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    
//    //NSLog(@"you push me!");
//    viewController.hidesBottomBarWhenPushed = YES;
//    [super pushViewController:viewController animated:YES];
//    
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
