//
//  RegisterViewController.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/1/1.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserDelegate <NSObject>

-(void)userID:(NSString *)userID userPass:(NSString *)userPass;

@end
@interface RegisterViewController : UIViewController

@property(nonatomic,weak)id<UserDelegate>delegate;

@end
