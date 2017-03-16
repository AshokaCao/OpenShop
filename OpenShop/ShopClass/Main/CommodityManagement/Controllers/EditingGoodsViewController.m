//
//  EditingGoodsViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/3/3.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "EditingGoodsViewController.h"
#import "GoodsImageCollectionViewCell.h"
#import "HXPhotoView.h"

@interface EditingGoodsViewController () <UITextFieldDelegate, HXPhotoViewDelegate>
@property (strong, nonatomic) HXPhotoManager *manager;
@property (weak, nonatomic) IBOutlet UITextField *productTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *productListTextView;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *profitTextField;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic ,strong) UITextField *name;
@property (weak, nonatomic) IBOutlet UIView *priceView;
@property (nonatomic ,assign) CGFloat priceViewH;
@property (nonatomic ,assign) CGFloat profitViewH;
@property (weak, nonatomic) IBOutlet UIView *profitView;
@property (weak, nonatomic) IBOutlet UIButton *swichBtn;

@end

@implementation EditingGoodsViewController

- (HXPhotoManager *)manager
{
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.photoMaxNum = 9;
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ASLocalizedString(@"Edit Item Detail");
    [self leftItem];
    HXPhotoView *photoView = [[HXPhotoView alloc] initWithFrame:CGRectMake(14, 151, SCREEN_WIDTH - 28, 55) WithManager:self.manager];
    photoView.delegate = self;
    photoView.backgroundColor = [UIColor whiteColor];
    [self.lineView addSubview:photoView];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.priceViewH = self.priceView.frame.origin.y;
    self.profitViewH = self.profitView.frame.origin.y;
}

- (void)leftItem
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    // 设置
    [rightBtn setTitle:ASLocalizedString(@"Done") forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"] forState:UIControlStateNormal];
    // 设置尺寸
    rightBtn.size = CGSizeMake(70, 44);
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_quxiao_icon"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    
    // 设置尺寸
    btn.size = btn.currentBackgroundImage.size;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -7;//自己设定
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:space,leftItem, nil];
//    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backToMain) image:@"nav_quxiao_icon" highImage:@""];
}

- (void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)photoViewChangeComplete:(NSArray *)allList Photos:(NSArray *)photos Videos:(NSArray *)videos Original:(BOOL)isOriginal
{
    NSLog(@"%ld - %ld - %ld",allList.count,photos.count,videos.count);
    NSLog(@"%@",photos);
}

- (void)photoViewUpdateFrame:(CGRect)frame WithView:(UIView *)view
{
    NSLog(@"%@",NSStringFromCGRect(frame));
}



#pragma mark   键盘弹出事件
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGFloat heights;
    if ([textField isEqual:self.priceTextField]) {
        heights = self.priceViewH;
    } else if ([textField isEqual:self.profitTextField]) {
        heights = self.profitViewH;
    }
    
    // 当前点击textfield的坐标的Y值 + 当前点击textFiled的高度 - （屏幕高度- 键盘高度 - 键盘上tabbar高度）
    
    // 在这一部 就是了一个 当前textfile的的最大Y值 和 键盘的最全高度的差值，用来计算整个view的偏移量
    
    int offset = heights + 42 - ( self.view.sd_height - 216.0-35.0);//键盘高度216
    NSLog(@" offset   %d",offset);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    
    if(offset > 0) {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesBegan");
    [self.view endEditing:YES];
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 64, self.view.sd_width, self.view.sd_height);
    self.view.frame = rect;
    [UIView commitAnimations];
}
- (IBAction)isSwichAction:(UIButton *)sender {
    self.swichBtn.selected = !self.swichBtn.selected;
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
