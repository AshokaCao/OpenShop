//
//  EditingGoodsViewController.m
//  OpenShop
//
//  Created by yuemin3 on 2017/3/3.
//  Copyright © 2017年 hangzhou.cao. All rights reserved.
//

#import "EditingGoodsViewController.h"
#import "GoodsImageCollectionViewCell.h"
#import "SelectCategoryViewController.h"
#import "HXPhotoView.h"

#import "PictureShowCollectionViewCell.h"

#define Spacing 3 // 每个item的间距
#define LineNum 3 // 每行个数

@interface EditingGoodsViewController () <UITextFieldDelegate, HXPhotoViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;
@property (nonatomic ,assign) NSInteger photoCount;
@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;
@property (nonatomic ,strong) NSMutableArray *imageArray;
@property (nonatomic ,strong) NSString *typeNum;
@property (nonatomic ,strong) NSString *isdis;
@property (weak, nonatomic) IBOutlet UIView *bottomBtnView;
@property (nonatomic ,strong) NSString *goodID;
//
@property (nonatomic ,strong) UICollectionView *photoCollecationView;

@property (strong, nonatomic) UICollectionViewFlowLayout *flowLayout;

@end

@implementation EditingGoodsViewController


- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _flowLayout;
}

- (HXPhotoManager *)manager
{
    if (!_manager) {
        _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypePhotoAndVideo];
        _manager.photoMaxNum = 9;
        _manager.outerCamera = NO;
    }
    return _manager;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.photoCount < 4) {
        self.lineViewHeight.constant = 357 - 89;
    } else if (self.photoCount >= 4 && self.photoCount < 8) {
        self.lineViewHeight.constant = 357;
    } else {
        self.lineViewHeight.constant = 357 + 89;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ASLocalizedString(@"Edit Item Detail");
    [self leftItem];
    HXPhotoView *photoView = [[HXPhotoView alloc] initWithFrame:CGRectMake(14, 60, SCREEN_WIDTH - 28, 81) WithManager:self.manager];
    photoView.delegate = self;
    photoView.backgroundColor = [UIColor whiteColor];
//    [self.lineView addSubview:photoView];
    self.photoCount = 1;
    if (self.editModel != nil) {
        self.bottomBtnView.hidden = NO;
        self.goodID = [NSString stringWithFormat:@"%@",self.editModel.goodid];
        [self getGoodsListWithGoodID:self.goodID];
        
        NSLog(@"self.goodID  -  %@",self.goodID);
    } else {
        self.bottomBtnView.hidden = YES;
    }
    
    
//    self.flowLayout.minimumLineSpacing = Spacing;
 //   self.flowLayout.minimumInteritemSpacing = Spacing;
    self.photoCollecationView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 53, SCREEN_WIDTH, 85) collectionViewLayout:self.flowLayout];
    
    _flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 52) / 3,(SCREEN_WIDTH - 52) / 3);
    _flowLayout.minimumInteritemSpacing = 8;
    _flowLayout.minimumLineSpacing = 8;
    
    self.photoCollecationView.tag = 8888;
    self.photoCollecationView.scrollEnabled = NO;
    self.photoCollecationView.dataSource = self;
    self.photoCollecationView.delegate = self;
    self.photoCollecationView.backgroundColor = [UIColor whiteColor];
    [self.photoCollecationView registerClass:[PictureShowCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    [self.lineView addSubview:_photoCollecationView];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}


//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (SCREEN_WIDTH > 320) {
        return UIEdgeInsetsMake(8, 14, 8, 14);
    } else {
        return UIEdgeInsetsMake(8, 14, 8, 14);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PictureShowCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
//    cell.model = self.dataList[indexPath.item];
//    cell.delegate = self;
    cell.backgroundColor = [UIColor grayColor];
    return cell;
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.priceViewH = self.priceView.frame.origin.y;
    self.profitViewH = self.profitView.frame.origin.y;
//    NSLog(@"constant  -  %f",self.lineViewHeight.constant);
}

- (void)leftItem
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backToMain) image:@"nav_quxiao_icon" highImage:@""];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:ASLocalizedString(@"Done") style:UIBarButtonItemStylePlain target:self action:@selector(editDone)];
}

- (void)backToMain
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editDone
{
    [self uploadGoodsList];
}

- (void)photoViewChangeComplete:(NSArray *)allList Photos:(NSArray *)photos Videos:(NSArray *)videos Original:(BOOL)isOriginal
{
    NSLog(@"%ld - %ld - %ld",allList.count,photos.count,videos.count);
    self.photoCount = photos.count;
    self.imageArray = [NSMutableArray array];
    for (HXPhotoModel *model in allList) {
//        NSLog(@"%@",model.previewPhoto);
        [self.imageArray addObject:model.previewPhoto];
    }
}

- (void)photoViewUpdateFrame:(CGRect)frame WithView:(UIView *)view
{
//    NSLog(@"%@",NSStringFromCGRect(frame));
}

- (void)getGoodsListWithGoodID:(NSString *)goodID
{
    NSString *goodsUrl = [NSString stringWithFormat:@"http://%@/Good/GoodDetial.ashx?goodid=%@",publickUrl,goodID];
    [PPNetworkHelper GET:goodsUrl parameters:nil responseCache:^(id responseCache) {
        
        if (responseCache != nil) {
//            [self getGoodMessageWith:responseCache];
        }
    } success:^(id responseObject) {
        NSLog(@"editting - %@",responseObject);
//        [self getGoodMessageWith:responseObject];
//        [self.goodsListTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"failure");
    }];
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
    if (self.swichBtn.isSelected) {
        self.isdis = @"1";
    } else {
        self.isdis = @"2";
    }
}
- (IBAction)selectCategoryAction:(UIButton *)sender {
    SelectCategoryViewController *select = [[SelectCategoryViewController alloc] init];
    [self.navigationController pushViewController:select animated:YES];
    [select returnRoomName:^(NSString *roomName) {
        self.typeNum = roomName;
        NSLog(@"roomName - %@",roomName);
    }];
}

- (void)uploadGoodsList
{
    NSString *uploadUrl = [NSString stringWithFormat:@"http://%@/Good/AddGood.ashx",publickUrl];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"goodname"] = [NSString stringWithFormat:@"%@",self.productTitleTextField.text];
    dic[@"price"] = [NSString stringWithFormat:@"%@",self.priceTextField.text];
    dic[@"profit"] = [NSString stringWithFormat:@"%@",self.profitTextField.text];
    dic[@"type"] = self.typeNum;
    dic[@"userid"] = [NSString stringWithFormat:@"%@",[nNsuserdefaul objectForKey:@"userID"]];
    dic[@"isdis"] = self.isdis;
    dic[@"content"] = self.productListTextView.text;
    NSMutableArray *nameArray = [NSMutableArray array];
    for (int i = 0; i < self.imageArray.count; i++) {
        [nameArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"accessToken"] forHTTPHeaderField:@"accesstoken"];
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"refreshToken"] forHTTPHeaderField:@"refreshtoken"];
    
    [PPNetworkHelper uploadImagesWithURL:uploadUrl parameters:dic name:@"goods" images:self.imageArray fileNames:nil imageScale:0.1 imageType:@"png" progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        NSLog(@"上传 - %@",responseObject);
        NSDictionary *diction = responseObject;
        if ([diction[@"returncode"] isEqualToString:@"success"]) {
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:@"上传成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alerV show];
        } else {
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:@"上传失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alerV show];
        }

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}
- (IBAction)shelveAction:(UIButton *)sender {
    
}
- (IBAction)deleteAction:(UIButton *)sender {
    
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
