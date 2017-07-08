//
//  ScenicTableViewCell.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/3/24.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "ScenicTableViewCell.h"

@implementation ScenicTableViewCell{
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

-(void)setScenic:(ScenicSpotDtailed *)scenic{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:scenic.imageUrl]];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageName.image = [UIImage imageWithData:data];
        });
    });
    self.spotName.text = scenic.spotName;
    self.address.text = scenic.address;
    self.descreptionText.text = scenic.descriptionText;
}

@end
