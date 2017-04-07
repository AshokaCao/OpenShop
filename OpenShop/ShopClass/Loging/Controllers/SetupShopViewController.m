//
//  SetupShopViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/2/23.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "SetupShopViewController.h"
#import "UIView+Help.h"
#import "RootViewController.h"

@interface SetupShopViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerBackView;
@property (weak, nonatomic) IBOutlet UIImageView *heaserImageView;
@property (weak, nonatomic) IBOutlet UITextField *shopNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *facebookTextField;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@end

@implementation SetupShopViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.heaserImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.heaserImageView.clipsToBounds = YES;
    self.heaserImageView.layer.cornerRadius = self.headerBackView.sd_width / 2;
    self.heaserImageView.layer.masksToBounds = YES;
    NSLog(@"%f",self.heaserImageView.sd_width);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    
    [self addChosePhoto];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:ASLocalizedString(@"Done") style:UIBarButtonItemStyleDone target:self action:@selector(editImage)];
}

- (void)editImage
{
    NSString *upload = [NSString stringWithFormat:@"http://%@/Shop/CreateShop.ashx",publickUrl];
    NSMutableDictionary *uploadShop = [NSMutableDictionary dictionary];
    uploadShop[@"userid"] = [nNsuserdefaul objectForKey:@"userID"];
    uploadShop[@"shopname"] = self.shopNameTextField.text;
    uploadShop[@"facebook"] = self.facebookTextField.text;
    
    [PPNetworkHelper uploadImagesWithURL:upload parameters:uploadShop name:@"shopImage" images:@[self.heaserImageView.image] fileNames:@[@"shopimg.png"] imageScale:0.1f imageType:@"png" progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        NSLog(@"responseObject - %@",responseObject);
        NSDictionary *logDic = responseObject;
        NSString *returnCode = logDic[@"returncode"];
        if ([returnCode isEqualToString:@"success"]) {
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = [[RootViewController alloc] init];
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
    [self.shopNameTextField resignFirstResponder];
    [self.facebookTextField resignFirstResponder];
}

- (void)addChosePhoto
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePhoto)];
    [self.heaserImageView addGestureRecognizer:tap];
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
        } else if (buttonIndex == 1) {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        //跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.navigationBar.translucent = NO;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;

        [self presentViewController:imagePickerController animated:YES completion:^{

        }];
    } else {
        
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.heaserImageView.image = [self OriginImage:image scaleToSize:CGSizeMake(image.size.width * 0.1, image.size.height * 0.1)];
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
