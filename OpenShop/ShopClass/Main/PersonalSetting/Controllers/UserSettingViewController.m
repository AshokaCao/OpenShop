//
//  UserSettingViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/2/24.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "UserSettingViewController.h"
#import "ChangeUserNameViewController.h"
#import "HXPhotoViewController.h"
#import "AFNetworking.h"
#import "MainNavigationViewController.h"
#import "LoginHomeViewController.h"
#import "UIImageView+AFNetworking.h"

@interface UserSettingViewController () <HXPhotoViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *outView;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImage;
@property (weak, nonatomic) IBOutlet UILabel *headerNameLabel;
@property (strong, nonatomic) HXPhotoManager *manager;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@property (nonatomic ,strong) UIImage *selectImage;

@end

@implementation UserSettingViewController

- (HXPhotoManager *)manager
{
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhoto];
        _manager.videoMaxNum = 1;
    }
    return _manager;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showUserData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = ASLocalizedString(@"Account");
    self.accountLa.text = ASLocalizedString(@"Account");
    self.nickNameLa.text = ASLocalizedString(@"NickName");
    self.changePasswordLa.text = ASLocalizedString(@"Change Password");
    [self.outBtn setTitle:ASLocalizedString(@"Logout") forState:UIControlStateNormal];
    [self changeNickNameAction];
    [self changeHeaderImage];
    
    [self leftItem];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.userHeaderImage.layer setCornerRadius:(self.userHeaderImage.sd_height/2)];
    [self.userHeaderImage.layer setMasksToBounds:YES];
    [self.userHeaderImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.userHeaderImage setClipsToBounds:YES];
//    self.userHeaderImage.layer.shadowColor = [UIColor whiteColor].CGColor;
//    self.userHeaderImage.layer.shadowOffset = CGSizeMake(4, 4);
//    self.userHeaderImage.layer.shadowOpacity = 0.5;
//    self.userHeaderImage.layer.shadowRadius = 2.0;
//    self.userHeaderImage.layer.borderColor = [[UIColor colorWithRed:238/255.0f green:103/255.0f blue:113/255.0f alpha:1] CGColor];
//    self.userHeaderImage.layer.borderWidth = 2.0f;
    
}

- (void)leftItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    
    // 设置尺寸
    btn.size = btn.currentBackgroundImage.size;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -7;//自己设定
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space,leftItem, nil];
}

- (void)showUserData
{
    [self getUserData];
}


- (void)getUserData
{
    NSString *userUrl = [NSString stringWithFormat:@"http://%@/Account/UserDetial.ashx?userid=%@&system=1",publickUrl,[nNsuserdefaul objectForKey:@"userID"]];
    [PPNetworkHelper GET:userUrl parameters:nil success:^(id responseObject) {
        NSLog(@"userData - %@",responseObject);
        NSDictionary *userDic = responseObject;
        NSString *returnCode = userDic[@"returncode"];
        if ([returnCode isEqualToString:@"success"]) {
            NSDictionary *listDic = userDic[@"memberinfo"];
            UserModelData *model = [[UserModelData alloc] init];
            [model setValuesForKeysWithDictionary:listDic];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.selectImage != nil) {
                    self.userHeaderImage.image = self.selectImage;
                } else {
                    [self.userHeaderImage setImageWithURL:[NSURL URLWithString:model.headimgurl] placeholderImage:[UIImage imageNamed:@"touxiang_img_default"]];
                }
                self.userNameLabel.text = model.nickname;
                self.accountIDLabel.text = self.userData.userid;
            });
        }
    } failure:^(NSError *error) {
        NSLog(@"------failure");
    }];
}

- (void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeNickNameAction
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changUserName)];
    [self.nameView addGestureRecognizer:tap];
}

- (void)changeHeaderImage
{
    UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeHeaderImageClick)];
    [self.userHeaderImage addGestureRecognizer:headerTap];
}

- (void)changUserName
{
    ChangeUserNameViewController *nameView = [[ChangeUserNameViewController alloc] init];
    nameView.changeStr = @"userName";
    nameView.nameStr = self.userData.nickname;
    [self.navigationController pushViewController:nameView animated:YES];
}

- (void)changeHeaderImageClick
{
    [self choosePhoto];
}

- (void)photoViewControllerDidNext:(NSArray *)allList Photos:(NSArray *)photos Videos:(NSArray *)videos Original:(BOOL)original
{
//    NSLog(@"all - %@",allList);
//    NSLog(@"photo - %@",photos);
//    HXPhotoModel *headerImag = [photos firstObject];
//    self.userHeaderImage.image = headerImag.thumbPhoto;
//    NSLog(@"video - %@",headerImag.thumbPhoto);
//    
//    NSString *changeURL = [NSString stringWithFormat:@"http://192.168.1.160:8101/Shop/CreateShop.ashx"];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    dic[@"shopname"] = @"23";
//    dic[@"facebook"] = @"sdf";
//    dic[@"userid"] = @"1231";
//    
//    [PPNetworkHelper uploadImagesWithURL:changeURL parameters:dic name:@"good" images:@[[UIImage imageNamed:@"tupianquxiao_icon"]] fileNames:@[@"test.jpg"] imageScale:0.05 imageType:@"jpeg" progress:^(NSProgress *progress) {
//        
//    } success:^(id responseObject) {
//        NSLog(@"responseObject   %@",responseObject);
//    } failure:^(NSError *error) {
//        NSLog(@"失败了   ");
//    }];
//    
//    
//    NSMutableDictionary *par = [NSMutableDictionary dictionary];
//    par[@"shopname"] = @"323";
//    par[@"facebook"] = @"3sdf";
//    par[@"userid"] = @"31231";
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager POST:changeURL parameters:par constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"tupianquxiao_icon"], 0.01);
//        [formData appendPartWithFileData:data name:@"pic" fileName:@"test" mimeType:@"jpeg"];
////        NSLog(@"data   %@",data);
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        
//        NSLog(@"图片发送成功%@",string);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"图片发送失败%@",error);
//    }];
}

- (void)uploadUserImageWith:(UIImage *)image
{
    NSString *upload = [NSString stringWithFormat:@"http://%@/Account/UserModify.ashx",publickUrl];
    NSMutableDictionary *uploadShop = [NSMutableDictionary dictionary];
    uploadShop[@"userid"] = [nNsuserdefaul objectForKey:@"userID"];
    uploadShop[@"modify"] = @"HeadImg";
    uploadShop[@"content"] = @"";
    
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"accessToken"] forHTTPHeaderField:@"accesstoken"];
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"refreshToken"] forHTTPHeaderField:@"refreshtoken"];
    [PPNetworkHelper uploadImagesWithURL:upload parameters:uploadShop name:@"userImage" images:@[image] fileNames:@[@"userimg.png"] imageScale:0.1f imageType:@"png" progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject - %@",responseObject);
        NSDictionary *logDic = responseObject;
        NSString *returnCode = logDic[@"returncode"];
        if ([returnCode isEqualToString:@"success"]) {
            //            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            //            window.rootViewController = [[RootViewController alloc] init];
        } else {
            NSString *message = [NSString stringWithFormat:@"%@",logDic[@"msg"]];
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alerV show];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:@"接口问题" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alerV show];
    }];
}

- (void)photoViewControllerDidCancel
{
    
}
- (IBAction)logoutAction:(UIButton *)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults removeObjectForKey:@"userName"];
//    [userDefaults removeObjectForKey:@"passWord"];
    [userDefaults removeObjectForKey:@"userID"];
    [userDefaults removeObjectForKey:@"accessToken"];
    [userDefaults removeObjectForKey:@"refreshToken"];
//    [userDefaults removeObjectForKey:@"faceID"];
    [userDefaults synchronize];
    LoginHomeViewController *log = [[LoginHomeViewController alloc] init];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:log animated:YES completion:^{
        
    }];
}

- (void)choosePhoto
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:ASLocalizedString(@"cancel") destructiveButtonTitle:nil otherButtonTitles:ASLocalizedString(@"Take a photo"), ASLocalizedString(@"From Album"), nil, nil];
    self.actionSheet.tag = 1000;
    [self.actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"-- %@ - %ld",actionSheet,(long)buttonIndex);
    if (actionSheet.tag == 1000) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
        if (buttonIndex == 0) {
            sourceType = UIImagePickerControllerSourceTypeCamera;
            //跳转到相机或相册页面
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.navigationBar.translucent = NO;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = sourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];
        } else if (buttonIndex == 1) {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            //跳转到相机或相册页面
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.navigationBar.translucent = NO;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = sourceType;
            
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];
        }
    } else {
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    self.selectImage = image;
    [self uploadUserImageWith:image];
}

-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
