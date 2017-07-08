//
//  ChangePasswordViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/14.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+Extension.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPassword;
@property (weak, nonatomic) IBOutlet UITextField *passwordNew;
@property (weak, nonatomic) IBOutlet UITextField *passwordNewTwo;
- (IBAction)savePassword:(UIButton *)sender;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"20140909015511307"]];
    //点击其他地方键盘收起来
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    self.oldPassword.delegate = self;
    self.passwordNew.delegate = self;
    self.passwordNewTwo.delegate = self;
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
    self.title = @"修改密码";
    self.tabBarController.tabBar.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.oldPassword resignFirstResponder];
    [self.passwordNew resignFirstResponder];
    [self.passwordNewTwo resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.oldPassword resignFirstResponder];
    [self.passwordNew resignFirstResponder];
    [self.passwordNewTwo resignFirstResponder];
    return YES;
}

- (IBAction)savePassword:(UIButton *)sender {
    if ([self.oldPassword.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"旧密码为空了"];
        return;
    }
    if ([self.passwordNew.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"新密码为空了"];
        return;
    }
    if ([self.passwordNewTwo.text isEqualToString:@""]) {
       [MBProgressHUD showError:@"第二个新密码为空了"];
        return;
    }
    if (![self.passwordNewTwo.text isEqualToString:self.passwordNew.text]) {
        [MBProgressHUD showError:@"两次新密码不一样，请重新输入"];
        return;
    }
    BmobUser *user = [BmobUser getCurrentUser];
    [user updateCurrentUserPasswordWithOldPassword:self.oldPassword.text newPassword:self.passwordNew.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [BmobUser loginInbackgroundWithAccount:user.username andPassword:user.password block:^(BmobUser *user, NSError *error) {
                [MBProgressHUD showSuccess:@"密码修改成功！"];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
        else{
            [MBProgressHUD showError:@"密码有错！"];
        }
    }];

}
@end
