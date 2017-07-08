//
//  PersonViewController.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/14.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonViewController : UIViewController
@property(strong,nonatomic)NSString *userID;
@property(strong,nonatomic) NSData *headImage;//上个控制器传过来的头像
@property(strong,nonatomic)NSString *userNameText;//上个控制器传过来的名字
@property(strong,nonatomic)NSString *gender;//上个控制传过来的性别
@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UIButton *male;//男
@property (weak, nonatomic) IBOutlet UIButton *female;//女

@end
