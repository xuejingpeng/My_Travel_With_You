//
//  MeTableViewCell.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/1/8.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "MeTableViewCell.h"
#import "MeItem.h"

@interface MeTableViewCell()

@property (nonatomic,strong)IBOutlet UIImageView *arrowView;
@property (nonatomic,strong)IBOutlet UILabel *labelView;

@end

@implementation MeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setItem:(MeItem *)item{
    
    _item = item;
    self.arrowView.image = [UIImage imageNamed:item.icon];
    self.labelView.text = item.title;
}

@end
