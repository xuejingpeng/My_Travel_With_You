//
//  ForgetPasswordViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/4/11.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+Extension.h"
#import "LoginViewController.h"

@interface ForgetPasswordViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *YZM;
@property (weak, nonatomic) IBOutlet UIButton *obtainYZM;
@property(nonatomic,assign)NSUInteger count;
@property(nonatomic,assign)NSUInteger disabledTime;
@property (nonatomic,strong)NSTimer *timer;
@property (weak, nonatomic) IBOutlet UITextField *passwordNew;

- (IBAction)obtainYZM:(UIButton *)sender;
- (IBAction)leftToPassword:(UIButton *)sender;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 59;
    self.phoneNum.delegate = self;
    self.YZM.delegate = self;
    self.passwordNew.delegate = self;
    //点击其他地方键盘收起来
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏的出现
    self.navigationController.navigationBarHidden = NO;
    //设置导航栏主题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.title = @"忘记密码";
    //设置返回键字体的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
#pragma mark -- 点击回车收起键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark -- 点击其他地方收起键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.phoneNum resignFirstResponder];
    [self.YZM resignFirstResponder];
    [self.passwordNew resignFirstResponder];
}
- (IBAction)obtainYZM:(UIButton *)sender {
    BmobQuery *query = [BmobUser query];
    [query whereKey:@"username" equalTo:self.phoneNum.text];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if(array.count!=0){
        for (BmobUser *user in array) {
            //请求验证码
            [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:user.username andTemplate:@"忘记密码的验证码" resultBlock:^(int number, NSError *error) {
                if (error) {
                    
                }
                else{
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
                    self.obtainYZM.userInteractionEnabled = NO;
                    [self.obtainYZM setBackgroundColor:[UIColor grayColor]];
                }
                
            }];
        }
        }
        else{
            [MBProgressHUD showError:@"当前账号没有注册,请先注册。"];
        }
    }];
}


- (void)countDown:(NSTimer *)timer{
    [self.obtainYZM setTitle:[NSString stringWithFormat:@"%ld秒", (long)self.count] forState:UIControlStateNormal];
    self.count--;
    if(self.count <= 0)
    {
        //        [self.getYZM setBackgroundColor:[UIColor yellowColor]];
        //        [self.getYZM setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.obtainYZM setTitle:@"重新获取" forState:UIControlStateNormal];
        [timer invalidate];
        self.obtainYZM.userInteractionEnabled = YES;
        [self.obtainYZM setBackgroundColor:[UIColor colorWithRed:74/255.0 green:165/255.0 blue:225/255.0 alpha:1.0]];
        self.count = 119;
    }
}
- (void)disabledYzm:(NSTimer *)timeer{
    self.disabledTime--;
    if (self.disabledTime <= 0) {
        [timeer invalidate];
    }
}
- (IBAction)leftToPassword:(UIButton *)sender {
    if ([self.phoneNum.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"手机号码为空了"];
        return;
    }
    if([self.YZM.text isEqualToString:@""]){
        [MBProgressHUD showError:@"验证码为空了"];
        return;
    }
    if([self.passwordNew.text isEqualToString:@""]){
        [MBProgressHUD showError:@"密码为空了"];
        return;
    }
    [BmobUser resetPasswordInbackgroundWithSMSCode:self.YZM.text andNewPassword:self.passwordNew.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [MBProgressHUD showSuccess:@"重置密码成功"];
            NSArray *temArray = self.navigationController.viewControllers;
            for (UIViewController *temVC in temArray) {
                if ([temVC isKindOfClass:[LoginViewController class]]) {
                    [self.delegate userID:self.phoneNum.text userPass:self.passwordNew.text];
                    [self.navigationController popToViewController:temVC animated:YES];
                    break;
                }
            }
            
        } else {
            [MBProgressHUD showSuccess:@"验证码有错！"];
        }
        
    }];
//    [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:self.phoneNum.text andSMSCode:self.YZM.text resultBlock:^(BOOL isSuccessful, NSError *error) {
//        if (isSuccessful) {
//            PasswordViewController *vc = [[PasswordViewController alloc]init];
//            vc.YZM = self.YZM.text;
//            vc.phoneNum = self.phoneNum.text;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        if (error) {
//            [MBProgressHUD showError:@"验证码错误"];
//        }
//    }];
}
@end
