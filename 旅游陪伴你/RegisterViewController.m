//
//  RegisterViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/1/1.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "RegisterViewController.h"
#import <BmobSDK/Bmob.h>
#import "MBProgressHUD+Extension.h"

@interface RegisterViewController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextField *userID;//账号
@property (weak, nonatomic) IBOutlet UITextField *userPass;//密码
@property (weak, nonatomic) IBOutlet UITextField *verificationCode;//验证码
@property (weak, nonatomic) IBOutlet UIButton *getYZM;
@property (strong,nonatomic)NSString *isAgree;//判断是否同意
@property(nonatomic,assign)NSUInteger count;
@property(nonatomic,assign)NSUInteger disabledTime;
@property (nonatomic,strong)NSTimer *timer;
@property(nonatomic,strong)NSString *YZM;
//获取验证码
- (IBAction)obtainVerificationCode:(UIButton *)sender;
//是否同意
- (IBAction)isAgree:(UIButton *)sender;
//注册
- (IBAction)selectRegister:(UIButton *)sender;
//是否隐藏
- (IBAction)isHide:(UIButton *)sender;



@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.count = 119;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"register"];
    [self.view addSubview:imageView];
    self.isAgree = [NSString string];
    self.isAgree = @"否";
    self.userID.delegate = self;
    self.userPass.delegate = self;
    self.verificationCode.delegate = self;
    //点击其他地方键盘收起来
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    // Do any additional setup after loading the view.
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
}


- (IBAction)obtainVerificationCode:(UIButton *)sender {
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.userID.text andTemplate:@"注册验证码" resultBlock:^(int number, NSError *error) {
        if(error){
            [MBProgressHUD showError:@"手机号有误或已注册了"];
        }
        else{
             self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
            self.getYZM.userInteractionEnabled = NO;
            [self.getYZM setBackgroundColor:[UIColor grayColor]];
        }
        
    }];
}
- (void)countDown:(NSTimer *)timer{
    [self.getYZM setTitle:[NSString stringWithFormat:@"%ld秒", (long)self.count] forState:UIControlStateNormal];
    self.count--;
    if(self.count <= 0)
    {
//        [self.getYZM setBackgroundColor:[UIColor yellowColor]];
//        [self.getYZM setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.getYZM setTitle:@"重新获取" forState:UIControlStateNormal];
        [timer invalidate];
        self.getYZM.userInteractionEnabled = YES;
        [self.getYZM setBackgroundColor:[UIColor colorWithRed:74/255.0 green:165/255.0 blue:225/255.0 alpha:1.0]];
        self.count = 119;
    }
}
- (void)disabledYzm:(NSTimer *)timeer{
    self.disabledTime--;
    if (self.disabledTime <= 0) {
        [timeer invalidate];
    }
}

static int i;
- (IBAction)isAgree:(UIButton *)sender {
    if (i%2==0) {
        [sender setImage:[UIImage imageNamed:@"x_direction_disabled"] forState:UIControlStateNormal];
        self.isAgree = @"是";
    }
    else{
        [sender setImage:[UIImage imageNamed:@"x_direction_unchecked"] forState:UIControlStateNormal];
        self.isAgree = @"否";
    }
    i++;
}

- (IBAction)selectRegister:(UIButton *)sender {
    if ([self.userID.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"手机号码为空了"];
        return;
    }
    if ([self.verificationCode.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"验证码为空了"];
        return;
    }
    if ([self.userPass.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"密码为空了"];
        return;
    }
    if ([self.isAgree isEqualToString:@"否"]) {
        [MBProgressHUD showError:@"没有同意协议"];
        return;
    }
    BmobUser *buser = [[BmobUser alloc] init];
    buser.mobilePhoneNumber = self.userID.text;
    buser.password = self.userPass.text;
    [buser signUpOrLoginInbackgroundWithSMSCode:self.verificationCode.text block:^(BOOL isSuccessful, NSError *error) {
        if (error) {
            [MBProgressHUD showError:@"验证码有误!"];
        } else {
            BmobObject *obj = [[BmobObject alloc]initWithClassName:@"userMessage"];
            [obj setObject:self.userID.text forKey:@"userID"];
            [obj setObject:self.userID.text forKey:@"userName"];
            [obj setObject:@"无" forKey:@"gender"];
            [obj setObject:@"无" forKey:@"headImage"];
            [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [MBProgressHUD showSuccess:@"用户注册成功。"];
                    [self.delegate userID:self.userID.text userPass:self.userPass.text];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else{
                   [MBProgressHUD showError:@"注册失败！用户已存在。"];
                }
            }];
        }
    }];
}
#pragma mark -- 点击其他地方收起键盘
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.userID resignFirstResponder];
    [self.userPass resignFirstResponder];
    [self.verificationCode resignFirstResponder];
}
#pragma mark -- 点击回车收起键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark -- 输入框限制
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *txt = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([textField isEqual:self.userID]) {
        if(txt.length >= 12){
            [MBProgressHUD showError:@"达到最大值,不能再输了"];
            return NO;
        }
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString *resultStr = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL result = [string isEqualToString:resultStr];
        return result;
    }
    return YES;
}
static int isHide;
- (IBAction)isHide:(UIButton *)sender {
    if (isHide%2 == 0) {
        self.userPass.secureTextEntry = NO;
        [sender setBackgroundImage:[UIImage imageNamed:@"icon_gray_eye"] forState:UIControlStateNormal];
    }
    else{
        [sender setBackgroundImage:[UIImage imageNamed:@"icon_unpublic"] forState:UIControlStateNormal];
        self.userPass.secureTextEntry =YES;
        }
    isHide++;
}
@end
