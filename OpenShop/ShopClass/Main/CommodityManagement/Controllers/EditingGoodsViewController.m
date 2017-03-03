//
//  EditingGoodsViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/3/3.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "EditingGoodsViewController.h"

@interface EditingGoodsViewController () <UITextFieldDelegate>
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

@end

@implementation EditingGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ASLocalizedString(@"Edit Item Detail");
    [self leftItem];
    
    // 键盘通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // Do any additional setup after loading the view from its nib.
    UITextField *nameTitle = [[UITextField alloc] initWithFrame:CGRectMake(14, 30, SCREEN_WIDTH - 14, SCREEN_WIDTH *0.1146)];
    nameTitle.delegate = self;
    [self.lineView addSubview:nameTitle];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.priceViewH = self.priceView.frame.origin.y;
    self.profitViewH = self.profitView.frame.origin.y;
}

- (void)leftItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    // 设置图片
    [btn setBackgroundImage:[UIImage imageNamed:@"nav_quxiao_icon"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    
    // 设置尺寸
    btn.size = btn.currentBackgroundImage.size;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = 14;//自己设定
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    // 设置
    [rightBtn setTitle:ASLocalizedString(@"Done") forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithHexString:@"#a0a0a0"] forState:UIControlStateNormal];
    // 设置尺寸
    rightBtn.size = CGSizeMake(70, 44);
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:space,rightItem, nil]];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:space,leftItem, nil]];
}

- (void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}
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
    
    if(offset > 0)
    {
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
