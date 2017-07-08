//
//  MiniGameViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/5.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "MiniGameViewController.h"

@interface MiniGameViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *tomImageView;

- (IBAction)eatOnClick:(UIButton *)sender;
- (IBAction)cymbalOnClick:(UIButton *)sender;
- (IBAction)fartOnClick:(UIButton *)sender;
- (IBAction)drinkOnClick:(UIButton *)sender;
- (IBAction)pieOnClick:(UIButton *)sender;
- (IBAction)scratch:(UIButton *)sender;

- (IBAction)knockoutOnClick:(UIButton *)sender;
- (IBAction)angryOnClick:(UIButton *)sender;

- (IBAction)stomachOnClick:(UIButton *)sender;
- (IBAction)footLeft:(UIButton *)sender;
- (IBAction)footRight:(UIButton *)sender;

@end

@implementation MiniGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    //设置导航栏的出现
    self.navigationController.navigationBarHidden = NO;
    //设置导航栏主题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回键字体的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"小游戏";
    self.tabBarController.tabBar.hidden = YES;
}

- (IBAction)eatOnClick:(UIButton *)sender {
    [self tomAnimateWith:@"eat" imageCount:40];
}

- (IBAction)cymbalOnClick:(UIButton *)sender {
    [self tomAnimateWith:@"cymbal" imageCount:13];
}

- (IBAction)fartOnClick:(UIButton *)sender {
    [self tomAnimateWith:@"fart" imageCount:28];
}

- (IBAction)drinkOnClick:(UIButton *)sender {
    [self tomAnimateWith:@"drink" imageCount:81];
}

- (IBAction)pieOnClick:(UIButton *)sender {
    [self tomAnimateWith:@"pie" imageCount:24];
}

- (IBAction)scratch:(UIButton *)sender {
    [self tomAnimateWith:@"scratch" imageCount:56];
}

- (IBAction)knockoutOnClick:(UIButton *)sender {
    [self tomAnimateWith:@"knockout" imageCount:81];
}

- (IBAction)angryOnClick:(UIButton *)sender {
    [self tomAnimateWith:@"angry" imageCount:26];
}

- (IBAction)stomachOnClick:(UIButton *)sender {
    [self tomAnimateWith:@"stomach" imageCount:34];
}

- (IBAction)footLeft:(UIButton *)sender {
    [self tomAnimateWith:@"footRight" imageCount:30];
}

- (IBAction)footRight:(UIButton *)sender {
    [self tomAnimateWith:@"footLeft" imageCount:30];
}
#pragma mark - 动画执行方法
- (void)tomAnimateWith:(NSString *)fileName imageCount:(NSInteger)imageCount
{
    // 0.如果动画正在执行,我们就直接不执行以下代码
    if (self.tomImageView.isAnimating) {
        return;
    }
    
    // 1.首先创建图片数组
    NSMutableArray *tomImages = [NSMutableArray array];
    
    for (int i = 0; i < imageCount; i++) {
        NSString *imageName = [NSString stringWithFormat:@"%@_%02d.jpg", fileName, i];
        
        //        // 1.创建图片的第一种方法(不用)
        //        UIImage *image = [UIImage imageNamed:imageName];
        
        
        // 这种方式获取图片不会有内存溢出的问题
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:nil];
        
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
        [tomImages addObject:image];
    }
    
    // 2.设置动画过程
    
    // 2.1添加动画执行的图片数组
    [self.tomImageView setAnimationImages:tomImages];
    
    // 2.2设置动画执行的时间
    [self.tomImageView setAnimationDuration:self.tomImageView.animationImages.count * 0.1];
    
    // 2.2设置动画执行的次数
    [self.tomImageView setAnimationRepeatCount:1];
    
    // 2.3设置动画开始执行
    [self.tomImageView startAnimating];
    
    
    // 3.在动画结束之后清空数组
    //    [self performSelector:@selector(clearImages) withObject:nil afterDelay:self.tomImageView.animationDuration];
    
    [self.tomImageView performSelector:@selector(setAnimationImages:) withObject:nil afterDelay:self.tomImageView.animationDuration];
}

@end
