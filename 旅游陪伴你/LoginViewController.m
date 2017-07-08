//
//  LoginViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/1/1.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "LoginViewController.h"
#import "TabBarController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobProFile.h>
#import "MBProgressHUD+Extension.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"

@interface LoginViewController ()<UITextFieldDelegate,UserDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userID;
@property (weak, nonatomic) IBOutlet UITextField *userPass;
- (IBAction)loginBtn:(UIButton *)sender;
//忘记密码
- (IBAction)forgetPassword:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"login"];
    [self.view addSubview:imageView];
    self.userID.delegate = self;
    self.userPass.delegate = self;
    //点击其他地方键盘收起来
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏的隐藏
    self.navigationController.navigationBarHidden = YES;          
    //设置返回键
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:nil];
}
#pragma mark -- 点击回车收起键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark -- 点击其他地方收起键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.userID resignFirstResponder];
    [self.userPass resignFirstResponder];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [super prepareForSegue:segue sender:sender];
    UIViewController *vc =  segue.destinationViewController;
    if ([vc isKindOfClass:[RegisterViewController class]]) {
        RegisterViewController *VC = segue.destinationViewController;
        VC.delegate = self;
    }
}

-(void)userID:(NSString *)userID userPass:(NSString *)userPass{
    self.userID.text = userID;
    self.userPass.text = userPass;
}

- (IBAction)loginBtn:(UIButton *)sender {
    if ([self.userID.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"账号为空了"];
        return;
    }
    if ([self.userPass.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"密码为空了"];
        return;
    }
    [BmobUser loginInbackgroundWithAccount:self.userID.text andPassword:self.userPass.text block:^(BmobUser *user, NSError *error) {
        [MBProgressHUD showMessage:@"正在登录中...."];
        if (error) {
                [MBProgressHUD hideHUD];
               [MBProgressHUD showError:@"密码错误！"];
        }
        else{
                [MBProgressHUD hideHUD];
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                TabBarController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"TabBar"];
                [UIApplication sharedApplication].keyWindow.rootViewController = loginVC;
        }
    }];
}
- (IBAction)forgetPassword:(UIButton *)sender {
    ForgetPasswordViewController *vc = [[ForgetPasswordViewController alloc]init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
