//
//  CityViewController.h
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/1/29.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "SZCalendarCell.h"

@implementation SZCalendarCell
- (UILabel *)dateLabel
{
    int height = [UIScreen mainScreen].bounds.size.height;
    if (!_dateLabel) {
        if (height == 568) {
           _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 8, 20, 20)];
        }else if(height == 667){
            _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 11, 20, 20)];
        }
        else if (height == 736){
            _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 13, 20, 20)];
        }
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setFont:[UIFont systemFontOfSize:16]];
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}
@end
