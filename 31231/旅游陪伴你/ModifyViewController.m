//
//  ModifyViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/23.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "ModifyViewController.h"
#import "MBProgressHUD+Extension.h"
#import <BmobSDK/Bmob.h>
#import "CityViewController.h"
#import "SZCalendarPicker.h"

@interface ModifyViewController ()<UITextFieldDelegate,CityViewControllerDelegate,clickSureDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UIButton *date;
@property(strong,nonatomic)NSString *dateTime;
@property (weak, nonatomic) IBOutlet UIButton *cityName;


- (IBAction)date:(UIButton *)sender;
- (IBAction)city:(UIButton *)sender;

- (IBAction)save:(UIButton *)sender;

@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText.delegate = self;
    self.titleText.text = self.basic.title;
    [self.date setTitle:self.basic.date forState:UIControlStateNormal];
    [self.cityName setTitle:self.basic.cityName forState:UIControlStateNormal];
}

-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏主题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回键字体的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"修改旅游路线";
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
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
- (IBAction)save:(UIButton *)sender {
    if ([self.titleText.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"行程名称不能为空"];
        return;
    }
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"WhereBasic"];
    [bquery getObjectInBackgroundWithId:self.basic.objectId block:^(BmobObject *object, NSError *error) {
        [object setObject:self.titleText.text forKey:@"title"];
        [object setObject:self.date.titleLabel.text forKey:@"date"];
        [object setObject:self.cityName.titleLabel.text forKey:@"cityName"];
        [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [MBProgressHUD showSuccess:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            if (error) {
                [MBProgressHUD showError:@"修改失败"];
            }
        }];
    }];
}
@end
