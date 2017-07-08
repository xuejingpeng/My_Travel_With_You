//
//  TrainTableViewCell.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/9.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "TrainTableViewCell.h"

@implementation TrainTableViewCell{
    UIView *seperator;
}

- (void)awakeFromNib {
    seperator = [[UIView alloc] init];
    seperator.backgroundColor = [UIColor colorWithRed:236/255.0 green:239/255.0 blue:243/255.0 alpha:1];
    
    [self.contentView addSubview:seperator];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat x = 5;
    CGFloat y = self.frame.size.height-1;
    CGFloat width = self.frame.size.width-10;
    CGFloat height = 1;
    seperator.frame = CGRectMake(x, y, width, height);
}
-(void)setTrain:(Train *)train{
    self.station_train_code.text = train.station_train_code;
    self.from_station_name.text = train.from_station_name;
    self.to_station_name.text = train.to_station_name;
    self.lishi.text = train.lishi;
    self.start_time.text = train.start_time;
    self.arrive_time.text = train.arrive_time;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]init];
    if (![train.gr_num isEqualToString:@"--"]) {
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"高级软卧:%@   ",train.gr_num]];
        [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:33/255.0 green:185/255.0 blue:98/255.0 alpha:1.0] range:NSMakeRange(5, 2)];
        [str appendAttributedString:message];
    }
    if (![train.rw_num isEqualToString:@"--"]) {
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"软卧:%@   ",train.rw_num]];
        [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:33/255.0 green:185/255.0 blue:98/255.0 alpha:1.0] range:NSMakeRange(3, 2)];
        [str appendAttributedString:message];
    }
    if (![train.rz_num isEqualToString:@"--"]) {
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"软座:%@   ",train.rz_num]];
        [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:33/255.0 green:185/255.0 blue:98/255.0 alpha:1.0] range:NSMakeRange(3, 2)];
         [str appendAttributedString:message];
    }
    if (![train.tz_num isEqualToString:@"--"]) {
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"特等座:%@   ",train.tz_num]];
        [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:33/255.0 green:185/255.0 blue:98/255.0 alpha:1.0] range:NSMakeRange(4, 2)];
        [str appendAttributedString:message];
    }
    if (![train.yw_num isEqualToString:@"--"]) {
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"硬卧:%@   ",train.yw_num]];
        [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:33/255.0 green:185/255.0 blue:98/255.0 alpha:1.0] range:NSMakeRange(3, 2)];
        [str appendAttributedString:message];
    }
    if (![train.yz_num isEqualToString:@"--"]) {
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"硬座:%@   ",train.yz_num]];
        [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:33/255.0 green:185/255.0 blue:98/255.0 alpha:1.0] range:NSMakeRange(3, 2)];
        [str appendAttributedString:message];
    }
    if (![train.swz_num isEqualToString:@"--"]) {
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"商务座:%@   ",train.swz_num]];
        [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:33/255.0 green:185/255.0 blue:98/255.0 alpha:1.0] range:NSMakeRange(4, 2)];
       [str appendAttributedString:message];
    }
    if (![train.zy_num isEqualToString:@"--"]) {
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"一等座:%@   ",train.zy_num]];
        [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:33/255.0 green:185/255.0 blue:98/255.0 alpha:1.0] range:NSMakeRange(4, 2)];
        [str appendAttributedString:message];
    }
    if (![train.ze_num isEqualToString:@"--"]) {
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"二等座:%@   ",train.ze_num]];
        [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:33/255.0 green:185/255.0 blue:98/255.0 alpha:1.0] range:NSMakeRange(4, 2)];
        [str appendAttributedString:message];
    }
    if (![train.wz_num isEqualToString:@"--"]) {
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"无座:%@   ",train.wz_num]];
        [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:33/255.0 green:185/255.0 blue:98/255.0 alpha:1.0] range:NSMakeRange(3, 2)];
        [str appendAttributedString:message];
    }
    if (![train.qt_num isEqualToString:@"--"]) {
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"其他:%@   ",train.qt_num]];
        [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:33/255.0 green:185/255.0 blue:98/255.0 alpha:1.0] range:NSMakeRange(3, 2)];
        [str appendAttributedString:message];
    }
    self.ticketNum.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.ticketNum setAttributedText:str];
}
@end
