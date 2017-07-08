//
//  ProductCollectionViewCell.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/14.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "ProductCollectionViewCell.h"
#import "Product.h"
@interface ProductCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;


@end

@implementation ProductCollectionViewCell

//如果你的资源或者部件是从XIB中获得的，那么这个方法就会被调用
- (void)awakeFromNib {
    
    self.iconView.layer.cornerRadius = 10;
    self.iconView.clipsToBounds = YES;
    
}

-(void)setProduct:(Product *)product{
    self.iconView.image = [UIImage imageNamed:[product.icon componentsSeparatedByString:@"@"][0]];
    self.titleView.text = product.title;
}

@end
