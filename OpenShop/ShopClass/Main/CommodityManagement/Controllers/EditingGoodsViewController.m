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
#import "UIImageView+AFNetworking.h"

#import "PictureShowCollectionViewCell.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "TZTestCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"

#define Spacing 8 // 每个item的间距
#define LineNum 4 // 每行个数

@interface EditingGoodsViewController () <UITextFieldDelegate, HXPhotoViewDelegate,TZImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate, UITextViewDelegate>
{
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
    CGFloat _margin;
    CGFloat _collectH;
}
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;

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
@property (nonatomic ,strong) UITextField *maxCountTF;  ///< 照片最大可选张数，设置为1即为单选模式

@property (weak, nonatomic) IBOutlet UITextField *columnNumberTF;
@property (weak, nonatomic) IBOutlet UISwitch *allowCropSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *needCircleCropSwitch;

@property (nonatomic ,strong) NSMutableArray *goodsImageArray;
@property (nonatomic ,strong) NSMutableArray *goodsImageID;
@property (nonatomic ,assign) NSInteger urlImageCount;
@property (nonatomic ,strong) NSMutableArray *deleteImageID;
@property (weak, nonatomic) IBOutlet UIView *backContView;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;

@end

@implementation EditingGoodsViewController

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    /*
    if (self.goodsImageArray.count + _selectedPhotos.count < 4) {
        self.lineViewHeight.constant = 357 - 89;
    } else if (self.goodsImageArray.count + _selectedPhotos.count >= 4 && self.goodsImageArray.count + _selectedPhotos.count < 8) {
        self.lineViewHeight.constant = 357;
    } else {
        self.lineViewHeight.constant = 357 + 89;
    }
    */
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ASLocalizedString(@"Edit Item Detail");
    [self leftItem];
    self.photoCount = 1;
    if (self.editModel != nil) {
        self.bottomBtnView.hidden = NO;
        self.goodID = [NSString stringWithFormat:@"%@",self.editModel.goodid];
        [self oldGoodList];
        [self getGoodsListWithGoodID:self.goodID andUserID:[nNsuserdefaul objectForKey:@"userID"]];
        NSLog(@"self.goodID  -  %@",self.goodID);
    } else {
        [self configCollectionView];
        self.bottomBtnView.hidden = YES;
    }
    self.isdis = @"0";
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    self.deleteImageID = [NSMutableArray array];
    
}

#pragma mark  原始商品数据
- (void)oldGoodList
{
    self.productTitleTextField.text = [NSString stringWithFormat:@"%@",self.editModel.goodname];
    self.profitTextField.text = [NSString stringWithFormat:@"%@",self.editModel.profit];
    self.priceTextField.text = [NSString stringWithFormat:@"%@",self.editModel.price];
    NSString *strHtml = [NSString stringWithFormat:@"%@",self.editModel.introduction];
    NSAttributedString * strAtt = [[NSAttributedString alloc] initWithData:[strHtml dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.productListTextView.attributedText = strAtt;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}
#pragma mark 布局
- (void)configCollectionView {
    self.maxCountTF.text = @"10";
    self.columnNumberTF.text = @"4";
    if (self.goodsImageArray.count < 4) {
        _collectH = 90;
        self.lineViewHeight.constant = _collectH + 177;
        self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    } else if (self.goodsImageArray.count >= 4 && self.goodsImageArray.count < 8) {
        _collectH = 190;
        self.lineViewHeight.constant = _collectH + 177;
        self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    } else if (self.goodsImageArray.count >= 8 && self.goodsImageArray.count < 12) {
        _collectH = 190 + 100;
        self.lineViewHeight.constant = _collectH + 177;
        self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + SCREEN_WIDTH * 0.13);
    } else {
        _collectH = 190 + 197;
        self.lineViewHeight.constant = _collectH + 177;
        self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _collectH + 177 + SCREEN_WIDTH * 0.565);
//        self.backViewHeight.constant = _collectH + 177 + SCREEN_WIDTH * 0.565;
    }
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _margin = 8;
    
    CGFloat width = SCREEN_WIDTH - 28;
    
    CGFloat itemW = (width - Spacing * (LineNum - 1)) / LineNum;
    layout.itemSize = CGSizeMake(itemW, itemW);
    layout.minimumInteritemSpacing = Spacing;
    layout.minimumLineSpacing = Spacing;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(14, 60, SCREEN_WIDTH - 28, _collectH) collectionViewLayout:layout];
//    CGFloat rgb = 244 / 255.0;
    _collectionView.alwaysBounceVertical = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
//    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = FALSE;
    _collectionView.showsHorizontalScrollIndicator = FALSE;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.backContView addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.goodsImageArray.count + _selectedPhotos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (indexPath.row == _selectedPhotos.count + self.goodsImageArray.count) {
        cell.imageView.image = [UIImage imageNamed:@"tianjiatipian_btn"];
        cell.deleteBtn.hidden = YES;
        cell.gifLable.hidden = YES;
    } else {
        if (indexPath.row < self.goodsImageArray.count) {
            [cell.imageView setImageWithURL:[NSURL URLWithString:self.goodsImageArray[indexPath.row]]];
            cell.deleteBtn.hidden = NO;
        } else {
            cell.imageView.image = _selectedPhotos[indexPath.row - self.urlImageCount];
            NSLog(@"_selectedAssets - - %ld  -- %ld --- %ld",_selectedAssets.count,indexPath.row,self.urlImageCount);
            cell.asset = _selectedAssets[indexPath.row - self.urlImageCount];
            cell.deleteBtn.hidden = NO;
        }
    }
    
    cell.gifLable.hidden = YES;
    
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
#pragma mark  deletePhoto
- (void)deleteBtnClik:(UIButton *)sender {
    
    if (sender.tag < self.goodsImageArray.count) {
        [self.goodsImageArray removeObjectAtIndex:sender.tag];
        [self.deleteImageID addObject:self.goodsImageID[sender.tag]];
        [self.goodsImageID removeObjectAtIndex:sender.tag];
        self.urlImageCount --;
    } else {
        [_selectedPhotos removeObjectAtIndex:sender.tag - self.urlImageCount];
        [_selectedAssets removeObjectAtIndex:sender.tag - self.urlImageCount];
    }
    
    if (_selectedPhotos.count + self.goodsImageArray.count < 4) {
        self.collectionView.sd_height = 90;
        self.lineViewHeight.constant = 357 - 89;
        self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    } else if (_selectedPhotos.count + self.goodsImageArray.count >= 4 && _selectedPhotos.count + self.goodsImageArray.count < 8) {
        self.collectionView.sd_height = 190;
        self.lineViewHeight.constant = 357;
        self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    } else if (_selectedPhotos.count + self.goodsImageArray.count >= 8 && _selectedPhotos.count + self.goodsImageArray.count < 12) {
        _collectH = 190 + 100;
        self.collectionView.sd_height = _collectH;
        self.lineViewHeight.constant = _collectH + 177;
        self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + SCREEN_WIDTH * 0.13);
//        self.backViewHeight.constant = _collectH + 177 + 202;
    } else {
        _collectH = 190 + 197;
        self.collectionView.sd_height = _collectH;
        self.lineViewHeight.constant = _collectH + 177;
//        self.backViewHeight.constant = _collectH + 177 + 202;
    }
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        NSLog(@"sender - %ld",sender.tag);
        NSLog(@"sender - %@",indexPath);
        [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [_collectionView reloadData];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _selectedPhotos.count + self.goodsImageArray.count) {
        BOOL showSheet = NO;
        if (showSheet) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
            [sheet showInView:self.view];
        } else {
            [self pushImagePickerController];
        }
    } /*else { // preview photos or video / 预览照片或者视频
        id asset = _selectedAssets[indexPath.row - self.urlImageCount];
        BOOL isVideo = NO;
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = asset;
            isVideo = phAsset.mediaType == PHAssetMediaTypeVideo;
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = asset;
            isVideo = [[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        }
        if ([[asset valueForKey:@"filename"] containsString:@"GIF"]) {
            TZGifPhotoPreviewController *vc = [[TZGifPhotoPreviewController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypePhotoGif timeLength:@""];
            vc.model = model;
            [self presentViewController:vc animated:YES completion:nil];
        } else if (isVideo) { // perview video / 预览视频
            TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
            TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
            vc.model = model;
            [self presentViewController:vc animated:YES completion:nil];
        } else { // preview photos / 预览照片
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_selectedAssets selectedPhotos:_selectedPhotos index:indexPath.row];
            imagePickerVc.maxImagesCount = self.maxCountTF.text.integerValue;
            imagePickerVc.allowPickingOriginalPhoto = YES;
            imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
                if (_selectedPhotos != nil) {
                    [_selectedPhotos addObjectsFromArray:photos];
                } else {
                    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
                    _selectedAssets = [NSMutableArray arrayWithArray:assets];
                    _isSelectOriginalPhoto = isSelectOriginalPhoto;
                }
                [_collectionView reloadData];
                _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
       }
       */
}
#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
//    if (self.maxCountTF.text.integerValue <= 0) {
//        return;
//    }
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:10 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    
    if (_selectedAssets.count > 0) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
   imagePickerVc.navigationBar.barTintColor = [UIColor grayColor];
   imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
   imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
   imagePickerVc.navigationBar.translucent = NO;
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = YES;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = YES;
    
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = YES;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = self.allowCropSwitch.isOn;
    imagePickerVc.needCircleCrop = self.needCircleCropSwitch.isOn;
    imagePickerVc.circleCropRadius = 100;
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        _selectedPhotos = [NSMutableArray arrayWithArray:photos];
        _selectedAssets = [NSMutableArray arrayWithArray:assets];

        if (_selectedPhotos.count + self.goodsImageArray.count < 4) {
            self.collectionView.sd_height = 90;
            self.lineViewHeight.constant = 357 - 89;
            self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        } else if (_selectedPhotos.count + self.goodsImageArray.count >= 4 && _selectedPhotos.count + self.goodsImageArray.count < 8) {
            self.collectionView.sd_height = 190;
            self.lineViewHeight.constant = 357;
            self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        } else {
            self.collectionView.sd_height = 190 + 100;
            self.lineViewHeight.constant = 357 + 90;
            self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + SCREEN_WIDTH * 0.13);
        }
        
        [_collectionView reloadData];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark 计算林View高度
- (void)getLineViewHeightFromePicture
{
    if (_selectedPhotos.count + self.goodsImageArray.count < 4) {
        self.collectionView.sd_height = 90;
        self.lineViewHeight.constant = 357 - 89;
//        self.backViewHeight.constant = SCREEN_HEIGHT;
    } else if (_selectedPhotos.count + self.goodsImageArray.count >= 4 && _selectedPhotos.count + self.goodsImageArray.count < 8) {
        self.collectionView.sd_height = 190;
//        self.backViewHeight.constant = _collectH + 177 + 202;
    } else {
        self.collectionView.sd_height = 190 + 100;
        self.lineViewHeight.constant = 357 + 90;
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.priceViewH = self.priceView.frame.origin.y;
    self.profitViewH = self.profitView.frame.origin.y;
    NSLog(@"imageCount -- %@",self.imageCount);
    /*
    if ([self.imageCount intValue] < 4) {
        _collectH = 90;
        self.lineViewHeight.constant = _collectH + 177;
        self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    } else if ([self.imageCount intValue] >= 4 && [self.imageCount intValue] < 8) {
        _collectH = 190;
        self.lineViewHeight.constant = _collectH + 177;
//        self.backContView.sd_height = _collectH + 180 + SCREEN_WIDTH * 0.565;
        self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    } else if ([self.imageCount intValue] >= 8 && [self.imageCount intValue] < 12) {
        _collectH = 190 + 100;
        self.lineViewHeight.constant = _collectH + 177;
        self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + SCREEN_WIDTH * 0.2);
        //        self.backViewHeight.constant = _collectH + 177 + SCREEN_WIDTH * 0.565;
    } else {
        _collectH = 190 + 197;
        self.lineViewHeight.constant = _collectH + 177;
        self.backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, _collectH + 177 + SCREEN_WIDTH * 0.565);
        //        self.backViewHeight.constant = _collectH + 177 + SCREEN_WIDTH * 0.565;
    }
     */
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
    if (self.editModel != nil) {
        [self channgeGoodList];
    } else {
        [self uploadGoodsList];
    }
}
#pragma mark  有模型获取模型详情
- (void)getGoodsListWithGoodID:(NSString *)goodID andUserID:(NSString *)userID
{
    NSString *goodsUrl = [NSString stringWithFormat:@"http://%@/Good/GoodDetial.ashx?goodid=%@&userid=%@",publickUrl,goodID,userID];
    [PPNetworkHelper GET:goodsUrl parameters:nil responseCache:^(id responseCache) {
        
        if (responseCache != nil) {
//            [self getGoodMessageWith:responseCache];
        }
    } success:^(id responseObject) {
        NSLog(@"editting - %@",responseObject);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getGoodMessageWith:responseObject];
        });
    } failure:^(NSError *error) {
        NSLog(@"failure");
    }];
}
- (void)getGoodMessageWith:(id)some
{
    NSMutableDictionary *goodsList = some;
    self.goodsImageArray = [NSMutableArray array];
    self.goodsImageID = [NSMutableArray array];
    NSDictionary *goodDetial = goodsList[@"gooddetial"];
    if (goodDetial != nil) {
        NSArray *array = goodDetial[@"goodimg"];
        for (NSDictionary *dic in array) {
            [self.goodsImageID addObject:dic[@"imgid"]];
            [self.goodsImageArray addObject:dic[@"path"]];
        }
        self.urlImageCount = self.goodsImageArray.count;
        //        _selectedPhotos = [NSMutableArray arrayWithArray:self.goodsImageArray];
        [self configCollectionView];
        NSLog(@"tupian shi  -%@",goodDetial);
    }
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
    [self.productListTextView resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.priceTextField resignFirstResponder];
    [self.profitTextField resignFirstResponder];
    [self.productListTextView resignFirstResponder];
    [self.view endEditing:YES];
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 64, self.view.sd_width, self.view.sd_height);
    self.view.frame = rect;
    [UIView commitAnimations];
    return YES;
}

- (IBAction)isSwichAction:(UIButton *)sender {
    self.swichBtn.selected = !self.swichBtn.selected;
    if (self.swichBtn.isSelected) {
        self.isdis = @"1";
    } else {
        self.isdis = @"0";
    }
}
- (IBAction)selectCategoryAction:(UIButton *)sender {
    SelectCategoryViewController *select = [[SelectCategoryViewController alloc] init];
    [self.navigationController pushViewController:select animated:YES];
    [select returnRoomName:^(NSString *roomName) {
        switch ([roomName intValue]) {
            case 1:
                [self.categoryBtn setTitle:ASLocalizedString(@"未分类") forState:UIControlStateNormal];
                break;
            case 2:
                [self.categoryBtn setTitle:ASLocalizedString(@"男人") forState:UIControlStateNormal];
                break;
            case 3:
                [self.categoryBtn setTitle:ASLocalizedString(@"女人") forState:UIControlStateNormal];
                break;
            case 4:
                [self.categoryBtn setTitle:ASLocalizedString(@"儿童") forState:UIControlStateNormal];
                break;
            case 5:
                [self.categoryBtn setTitle:ASLocalizedString(@"化妆品") forState:UIControlStateNormal];
                break;
            case 6:
                [self.categoryBtn setTitle:ASLocalizedString(@"其他") forState:UIControlStateNormal];
                break;
                
            default:
                break;
        }
        self.typeNum = roomName;
        NSLog(@"roomName - %@",roomName);
    }];
}
#pragma mark  上传
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
    NSLog(@"imageArray - %@",_selectedPhotos);
    [PPNetworkHelper uploadImagesWithURL:uploadUrl parameters:dic name:@"goods" images:_selectedPhotos fileNames:nil imageScale:0.1 imageType:@"png" progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        NSLog(@"上传 - %@",responseObject);
        NSDictionary *diction = responseObject;
        if ([diction[@"returncode"] isEqualToString:@"success"]) {
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:@"上传成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alerV show];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSString *mess = diction[@"msg"];
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:mess delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alerV show];
        }

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark 修改
- (void)channgeGoodList
{
    NSString *uploadUrl = [NSString stringWithFormat:@"http://%@/Good/UpdateGoodByGoodID.ashx",publickUrl];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"goodname"] = [NSString stringWithFormat:@"%@",self.productTitleTextField.text];
    dic[@"price"] = [NSString stringWithFormat:@"%@",self.priceTextField.text];
    dic[@"profit"] = [NSString stringWithFormat:@"%@",self.profitTextField.text];
    dic[@"type"] = self.typeNum;
    dic[@"userid"] = [NSString stringWithFormat:@"%@",[nNsuserdefaul objectForKey:@"userID"]];
    dic[@"goodid"] = self.goodID;
    dic[@"isdis"] = self.isdis;
    dic[@"content"] = self.productListTextView.text;
    dic[@"imglist"] = [self.deleteImageID componentsJoinedByString:@","];
    NSMutableArray *nameArray = [NSMutableArray array];
    for (int i = 0; i < self.imageArray.count; i++) {
        [nameArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"accessToken"] forHTTPHeaderField:@"accesstoken"];
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"refreshToken"] forHTTPHeaderField:@"refreshtoken"];
    
    [PPNetworkHelper uploadImagesWithURL:uploadUrl parameters:dic name:@"goods" images:_selectedPhotos fileNames:nil imageScale:0.1 imageType:@"png" progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        NSLog(@"上传 - %@",responseObject);
        NSDictionary *diction = responseObject;
        if ([diction[@"returncode"] isEqualToString:@"success"]) {
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:@"上传成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alerV show];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:@"上传失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alerV show];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    }];
}
#pragma mark  下架
- (IBAction)shelveAction:(UIButton *)sender {
    NSString *shelvrUrl = [NSString stringWithFormat:@"http://%@/Good/ShelfGood.ashx",publickUrl];
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    diction[@"goodid"] = self.goodID;
    diction[@"userid"] = [nNsuserdefaul objectForKey:@"userID"];
    NSLog(@"goutongshib - %@",self.goodID);
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"accessToken"] forHTTPHeaderField:@"accesstoken"];
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"refreshToken"] forHTTPHeaderField:@"refreshtoken"];
    [PPNetworkHelper POST:shelvrUrl parameters:diction success:^(id responseObject) {
        NSLog(@"xiajia   %@",responseObject);
        NSDictionary *dic = responseObject;
        if ([dic[@"returncode"] isEqualToString:@"success"]) {
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:@"success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alerV show];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSString *mess = dic[@"msg"];
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:mess delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alerV show];
        }
    } failure:^(NSError *error) {
        NSLog(@"goutongshib");
        UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:@"链接失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alerV show];
    }];
}
#pragma mark  删除
- (IBAction)deleteAction:(UIButton *)sender {
    NSString *shelvrUrl = [NSString stringWithFormat:@"http://%@/Good/UpdateGood.ashx",publickUrl];
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    diction[@"modify"] = @"Delete";
    diction[@"goodid"] = self.goodID;
    diction[@"content"] = @"1";
    diction[@"userid"] = [nNsuserdefaul objectForKey:@"userID"];
    
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"accessToken"] forHTTPHeaderField:@"accesstoken"];
    [PPNetworkHelper setValue:[nNsuserdefaul objectForKey:@"refreshToken"] forHTTPHeaderField:@"refreshtoken"];
    
    [PPNetworkHelper POST:shelvrUrl parameters:diction success:^(id responseObject) {
        NSLog(@"shanchu   %@",responseObject);
        NSDictionary *dic = responseObject;
        if ([dic[@"returncode"] isEqualToString:@"success"]) {
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:@"success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alerV show];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSString *mess = dic[@"msg"];
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:mess delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alerV show];
        }

    } failure:^(NSError *error) {
        NSLog(@"goutongshib  -  %@",error);
        UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"" message:@"链接失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alerV show];
    }];
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
