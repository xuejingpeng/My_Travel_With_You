//
//  WhereWebViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/21.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "WhereWebViewController.h"

@interface WhereWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WhereWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url =[NSURL URLWithString:self.URL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];

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
    self.title = @"详细结果";
}



@end
