//
//  AddWhereBasicViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/22.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "AddWhereBasicViewController.h"
#import "MBProgressHUD+Extension.h"
#import <BmobSDK/Bmob.h>
#import "CityViewController.h"
#import "SZCalendarPicker.h"

@interface AddWhereBasicViewController ()<UITextFieldDelegate,CityViewControllerDelegate,clickSureDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UIButton *date;
@property (weak, nonatomic) IBOutlet UIButton *cityName;
//存储时间
@property (strong,nonatomic) NSString *dateTime;

- (IBAction)date:(UIButton *)sender;
- (IBAction)city:(UIButton *)sender;

@end

@implementation AddWhereBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText.delegate = self;
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏主题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回键字体的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"创建路线";
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    //设置导航栏右边的
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(save:)];
}
#pragma mark -- 点击回车收起键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (IBAction)date:(UIButton *)sender {
    SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    //设置日历的位置
    calendarPicker.frame = CGRectMake(0, 180, self.view.frame.size.width, self.view.frame.size.height-260);
    calendarPicker.delegate = self;
    
    calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        self.dateTime = [NSString stringWithFormat:@"%li年%li月%li日", (long)year,(long)month,(long)day];
    };
}
-(void)selectSureBtnClick:(UIButton *)sender{
    [self.date setTitle:self.dateTime forState:UIControlStateNormal];
}
- (IBAction)city:(UIButton *)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CityViewController *cityVC = [story instantiateViewControllerWithIdentifier:@"city"];
    cityVC.delegate = self;
    [self.navigationController pushViewController:cityVC animated:YES];
}
-(void)cityViewController:(CityViewController *)cityVC didCity:(NSString *)cityName{
    [self.cityName setTitle:cityName forState:UIControlStateNormal];
}
-(void)save:(UIButton *)sender{
    if ([self.titleText.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"行程名称不能为空"];
        return;
    }
    if([self.date.titleLabel.text isEqualToString:@"出发日期"]){
        [MBProgressHUD showError:@"日期不能为空"];
        return;
    }
    if([self.cityName.titleLabel.text isEqualToString:@"旅游的城市"]){
        [MBProgressHUD showError:@"旅游的城市不能为空"];
        return;
    }
    BmobUser *bUser = [BmobUser getCurrentUser];
    BmobObject *obj = [BmobObject objectWithClassName:@"WhereBasic"];
    [obj setObject:bUser.username forKey:@"userID"];
    [obj setObject:self.titleText.text forKey:@"title"];
    [obj setObject:self.date.titleLabel.text forKey:@"date"];
    [obj setObject:self.cityName.titleLabel.text forKey:@"cityName"];
    int x = arc4random() % 15+1;
    [obj setObject:[NSString stringWithFormat:@"%d.jpg",x] forKey:@"imageName"];
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [MBProgressHUD showSuccess:@"完成"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        if (error) {
            [MBProgressHUD showError:@"路线已存在"];
            
        }
    }];
}
@end
