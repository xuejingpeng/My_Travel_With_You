//
//  PersonViewController.m
//  旅游陪伴你
//
//  Created by 薛静鹏 on 16/2/14.
//  Copyright © 2016年 薛静鹏. All rights reserved.
//

#import "PersonViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobProFile.h>
#import "MBProgressHUD+Extension.h"

@interface PersonViewController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate>{
    int isGender;
}
@property(strong,nonatomic)NSString *fileName;
@property(strong,nonatomic)NSString *isSuccess;
- (IBAction)headIconBtn:(UIButton *)sender;
- (IBAction)selectGender:(UIButton *)sender;
- (IBAction)saveMessage:(UIButton *)sender;

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isGender = 100;
    [self.headIcon setImage:[UIImage imageWithData:self.headImage]];
    self.headIcon.layer.masksToBounds = YES;
    self.headIcon.layer.cornerRadius = 50;
    if ([self.gender isEqualToString:@"男"]) {
        [self.male setBackgroundColor:[UIColor colorWithRed:86/225.0 green:196/225.0 blue:224/225.0 alpha:1.0]];
    }
    else if ([self.gender isEqualToString:@"女"]){
        [self.female setBackgroundColor:[UIColor colorWithRed:86/225.0 green:196/225.0 blue:224/225.0 alpha:1.0]];
    }
    self.userName.text = self.userNameText;
    //点击其他地方键盘收起来
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    self.userName.delegate = self;
}
-(void)viewWillAppear:(BOOL)animated{
    self.isSuccess = @"YES";
    //设置导航栏的出现
    self.navigationController.navigationBarHidden = NO;
    //设置导航栏主题字体颜色
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回键字体的颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.title = @"修改信息";
    self.tabBarController.tabBar.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.userName resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.userName resignFirstResponder];
    return YES;
}
- (IBAction)headIconBtn:(UIButton *)sender {
    self.isSuccess = @"NO";
    UIActionSheet *action;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        action = [[UIActionSheet alloc] initWithTitle:@"获取图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择",nil];
    }
    else
    {
        action = [[UIActionSheet alloc] initWithTitle:@"获取图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选择",nil];
    }
    [action showInView:self.view];
}
#pragma mark - 调用UIActionSheet iOS7使用

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        switch (buttonIndex) {
            case 0:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            default:
                return;
        }
    }
    else{
        if (buttonIndex == 0) {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        else
            return;
    }
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - 确定所选择的图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        NSString *fileName = [representation filename];
    };
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];
    [self performSelector:@selector(saveImage:) withObject:image afterDelay:0.5];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 取消所选择的图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 保存图片到相应的位置上
- (void)saveImage:(UIImage *)image{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path firstObject];
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:@"offersPhoto.jpg"];
    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:imagePath atomically:YES];
    UIImage *portrait = [UIImage imageWithContentsOfFile:imagePath];
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
//    [BmobProFile uploadFileWithFilename:@"offersPhoto.jpg" fileData:data block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url, BmobFile *file) {
//        if(isSuccessful){
//            self.fileName = filename;
//            BmobQuery *bquery = [BmobQuery queryWithClassName:@"userMessage"];
//            [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//                for (BmobObject *obj in array) {
//                    if ([[obj objectForKey:@"userID"] isEqualToString:_userID]) {
//                        [obj setObject:self.fileName forKey:@"headImage"];
//                        [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//                            [MBProgressHUD showSuccess:@"上传成功"];
//                            self.isSuccess = @"YES";
//                        }];
//                        break;
//                    }
//                }
//            }];
//            [bquery clearCachedResult];
//        }
//    } progress:nil];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"userMessage"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"userID"] isEqualToString:_userID]) {
                [obj setObject:imagePath forKey:@"headImage"];
                [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                [MBProgressHUD showSuccess:@"上传成功"];
                self.isSuccess = @"YES";
            }];
                break;
            }
    }
    }];
  
   
    [self.headIcon setImage:portrait];
    self.headIcon.layer.masksToBounds = YES;
    self.headIcon.layer.cornerRadius = 50;
    
}

- (IBAction)selectGender:(UIButton *)sender {
    if (sender.tag == 100) {
        [self.male setBackgroundColor:[UIColor colorWithRed:86/225.0 green:196/225.0 blue:224/225.0 alpha:1.0]];
        [self.female setBackgroundColor:[UIColor colorWithRed:170/225.0 green:170/225.0 blue:170/225.0 alpha:1.0]];
        isGender = (int)sender.tag;
    }
    else if (sender.tag == 200) {
        [self.female setBackgroundColor:[UIColor colorWithRed:86/225.0 green:196/225.0 blue:224/225.0 alpha:1.0]];
        [self.male setBackgroundColor:[UIColor colorWithRed:170/225.0 green:170/225.0 blue:170/225.0 alpha:1.0]];
        isGender = (int)sender.tag;
    }
}

- (IBAction)saveMessage:(UIButton *)sender {
    if ([self.userName.text isEqualToString:@""]) {
       [MBProgressHUD showError:@"网名不能为空"];
        return;
    }
    if ([self.isSuccess isEqualToString:@"NO"]) {
        [MBProgressHUD showError:@"头像正在上传"];
        return;
    }
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"userMessage"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"userID"] isEqualToString:_userID]) {
                [obj setObject:self.userName.text forKey:@"userName"];
                if (isGender ==100) {
                    [obj setObject:@"男" forKey:@"gender"];
                }
                else if(isGender == 200){
                    [obj setObject:@"女" forKey:@"gender"];
                }
               
                [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if(isSuccessful){
                            [MBProgressHUD showSuccess:@"保存成功"];
                            [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
                break;
            }
        }
    }];
}
@end
