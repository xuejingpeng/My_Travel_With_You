//
//  main.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 15/12/31.
//  Copyright © 2015年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        [Bmob registerWithAppKey:@"4974746ccad2caf8052990c4e3a5d372"];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
