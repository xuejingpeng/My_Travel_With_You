//
//  ProductCollectionViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/14.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "ProductCollectionViewController.h"
#import "Product.h"
#import "ProductCollectionViewCell.h"

@interface ProductCollectionViewController ()

@property (nonatomic,strong) NSArray *products;

@end

@implementation ProductCollectionViewController

static NSString * const reuseIdentifier = @"Product-Cell";
-(NSArray *)products{
    
    if (_products == nil) {
        
        //获得JSON文件路径
        NSString *path = [[NSBundle mainBundle] pathForResource:@"more_project.json" ofType:nil];
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSMutableArray *productArray = [NSMutableArray array];
        
        for (NSDictionary *dict in array) {
            Product *product = [Product productWithDict:dict];
            [productArray addObject:product];
        }
        _products = productArray;
    }
    return _products;
}
- (instancetype)init{
    
    //设置了流布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    //每个CELL的尺寸
    layout.itemSize = CGSizeMake(80, 80); //定义CELL的大小
    
    //设置CELL的水平间距
    layout.minimumInteritemSpacing = 0;
    //设置CELL的垂直间距
    layout.minimumLineSpacing = 10;
    
    layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    //NSLog(@"%@",self.products);
    
    return [super initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"ProductCollectionViewCell" bundle:nil]; //读取一个nib文件到内存
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier]; //到这个xib文件中去获取一个重用标识叫做Product-Cell的view
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
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
    self.title = @"产品推荐";
    self.tabBarController.tabBar.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.products.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    //cell.backgroundColor = [UIColor redColor];
    cell.product = self.products[indexPath.row];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
