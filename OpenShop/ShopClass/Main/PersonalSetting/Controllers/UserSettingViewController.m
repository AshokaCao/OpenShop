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

@interface UserSettingViewController () <HXPhotoViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *accountView;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *outView;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImage;
@property (weak, nonatomic) IBOutlet UILabel *headerNameLabel;
@property (strong, nonatomic) HXPhotoManager *manager;

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
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = ASLocalizedString(@"Account");
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
    nameView.nameStr = @"Some Thing";
    [self.navigationController pushViewController:nameView animated:YES];
}

- (void)changeHeaderImageClick
{
    HXPhotoViewController *vc = [[HXPhotoViewController alloc] init];
    vc.delegate = self;
    vc.manager = self.manager;
    [self presentViewController:[[MainNavigationViewController alloc] initWithRootViewController:vc] animated:YES completion:nil];
}

- (void)photoViewControllerDidNext:(NSArray *)allList Photos:(NSArray *)photos Videos:(NSArray *)videos Original:(BOOL)original
{
//    NSLog(@"all - %@",allList);
//    NSLog(@"photo - %@",photos);
    HXPhotoModel *headerImag = [photos firstObject];
    self.userHeaderImage.image = headerImag.thumbPhoto;
    NSLog(@"video - %@",headerImag.thumbPhoto);
    
    NSString *changeURL = [NSString stringWithFormat:@"http://192.168.1.160:8101/Shop/CreateShop.ashx"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"shopname"] = @"23";
    dic[@"facebook"] = @"sdf";
    dic[@"userid"] = @"1231";
    
    [PPNetworkHelper uploadImagesWithURL:changeURL parameters:dic name:@"good" images:@[[UIImage imageNamed:@"tupianquxiao_icon"]] fileNames:@[@"test.jpg"] imageScale:0.05 imageType:@"jpeg" progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject   %@",responseObject);
    } failure:^(NSError *error) {
        NSLog(@"失败了   ");
    }];
    
    
    NSMutableDictionary *par = [NSMutableDictionary dictionary];
    par[@"shopname"] = @"323";
    par[@"facebook"] = @"3sdf";
    par[@"userid"] = @"31231";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:changeURL parameters:par constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImageJPEGRepresentation([UIImage imageNamed:@"tupianquxiao_icon"], 0.01);
        [formData appendPartWithFileData:data name:@"pic" fileName:@"test" mimeType:@"jpeg"];
//        NSLog(@"data   %@",data);
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"图片发送成功%@",string);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"图片发送失败%@",error);
    }];


    self.userHeaderImage.sd_width = SCREEN_WIDTH * 0.2;
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
