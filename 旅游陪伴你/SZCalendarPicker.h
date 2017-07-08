//
//  CityViewController.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/1/29.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol clickSureDelegate <NSObject>
- (void)selectSureBtnClick:(UIButton *)sender;
@end

@interface SZCalendarPicker : UIView<UICollectionViewDelegate , UICollectionViewDataSource>
@property (nonatomic , strong) NSDate *date;
@property (nonatomic , strong) NSDate *today;
@property (nonatomic, copy) void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year);
@property (weak,nonatomic) id<clickSureDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

+ (instancetype)showOnView:(UIView *)view;
@end
