//
//  HTMLViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/14.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "HTMLViewController.h"

@interface HTMLViewController ()<UIWebViewDelegate>

@end

@implementation HTMLViewController

- (void)loadView{
    self.view = [[UIWebView alloc] init];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //创建URL
    NSURL *url = [[NSBundle mainBundle] URLForResource:self.helpItem.html withExtension:nil];
    
    //创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //执行访问
    UIWebView *webView = (UIWebView *)self.view;
    webView.delegate = self;
    [webView loadRequest:request];
    NSLog(@"url:%@",self.helpItem.html);
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
    self.title = self.helpItem.title;
    //设置左侧关闭按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // NSLog(@"load the html file is ok! id=%@",self.helpItem.id);
    
    NSString *setIdJS = [NSString stringWithFormat:@"window.location.href='#%@';",self.helpItem.id];
    
    //NSLog(@"%@",setIdJS);
    [webView stringByEvaluatingJavaScriptFromString:setIdJS];
    
    
}

@end
