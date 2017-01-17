//
//  ZFJSegmentedControl.m
//  TextDemo
//
//  Created by ZFJ on 2016/12/28.
//  Copyright © 2016年 ZFJ. All rights reserved.
//

#import "ZFJSegmentedControl.h"

@interface ZFJSegmentedControl ()<UICollectionViewDelegate>

@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSArray *iconArr;
@property (nonatomic,assign) ZFJSegmentedControlType SCType;   //类型
@property (nonatomic,strong) UIScrollView *scrollView;         //底部滚动视图
@property (nonatomic,assign) NSInteger btnCount;               //按钮的数量
@property (nonatomic,strong) NSMutableArray *titleArray;       //存放按钮的数组
@property (nonatomic,strong) UIView *stateView;                //按钮下面的伴随状态按钮
@property (nonatomic,assign) BOOL isSetWID;                //是否是默认宽度

@end

@implementation ZFJSegmentedControl

- (instancetype)initwithTitleArr:(NSArray *)titleArr iconArr:(NSArray *)iconArr SCType:(ZFJSegmentedControlType)SCType{
    if(self == [super init]){
        self.titleArr = titleArr;
        self.iconArr = iconArr;
        self.SCType = SCType;
        [self initValue];
        [self uiConfig];
    }
    return self;
}

- (void)initValue{
    self.clipsToBounds = YES;
    _edgeInsetsStyle = ZFJButtonEdgeInsetsStyleTop;
    _animateDuration = 0.01;
    _selectBtnWID = 0;
    _selectBtnSpace = 0;
    _selectIndex = 0;//默认选中第一个
    _SCType_Underline_HEI = 2;
    _btnCount = self.titleArr.count!=0 ? self.titleArr.count : self.iconArr.count;
    _titleColor = [UIColor blackColor];
    _selectTitleColor = [UIColor colorWithRed:0.933 green:0.204 blue:0.035 alpha:1.00];//RGB:238 52 9
    _ellipseBackColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:0.2];
    _titleBtnBackColor = [UIColor clearColor];
    _cornerRadius = 2;
    _edgeInsetsSpace = 0;
    _titleFont = [UIFont systemFontOfSize:16];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    _selectBtnWID = _isSetWID == NO ? (frame.size.width - (_btnCount - 1) * _selectBtnSpace)/_btnCount : _selectBtnWID;
    [self uiConfig];
}

- (void)setSelectBtnWID:(CGFloat)selectBtnWID{
    _isSetWID = YES;
    _selectBtnWID = selectBtnWID;
    [self uiConfig];
}

- (void)setSelectBtnSpace:(CGFloat)selectBtnSpace{
    _selectBtnSpace = selectBtnSpace;
    _selectBtnWID = _isSetWID == NO ? (self.frame.size.width - (_btnCount - 1) * _selectBtnSpace)/_btnCount : _selectBtnWID;
    [self uiConfig];
}

- (void)uiConfig{
    if(_btnCount==0) return;//如果没有值 直接返回
    
    if(self.scrollView == nil){
        self.scrollView = [[UIScrollView alloc]init];
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.delegate = self;
    }
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    self.scrollView.frame = self.bounds;
    self.scrollView.contentSize = CGSizeMake(_selectBtnWID * _btnCount + _selectBtnSpace * (_btnCount - 1), 0);
    [self addSubview:self.scrollView];
    
    //清空数组
    [self.titleArray removeAllObjects];
    
    for (int i= 0; i<_btnCount; i++) {
        UIButton *titleBtn = [[UIButton alloc]init];
        titleBtn.backgroundColor = _titleBtnBackColor;
        titleBtn.frame = CGRectMake((_selectBtnWID + _selectBtnSpace) * i, 0, _selectBtnWID, self.frame.size.height);
        if(self.titleArr.count>0){
            [titleBtn setTitle:_titleArr[i] forState:UIControlStateNormal];
        }
        if(self.iconArr.count>0){
            [titleBtn setImage:[UIImage imageNamed:_iconArr[i]] forState:UIControlStateNormal];
        }
        
        if(self.titleArr.count>0 && self.iconArr.count>0){
            [self layoutButtonWithEdgeInsetsStyle:_edgeInsetsStyle imageTitleSpace:_edgeInsetsSpace button:titleBtn];
        }
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [titleBtn setTitleColor:_titleColor forState:UIControlStateNormal];
        [titleBtn setTitleColor:_selectTitleColor forState:UIControlStateSelected];
        titleBtn.titleLabel.font = _titleFont;
        [self.scrollView addSubview:titleBtn];
        [self.titleArray addObject:titleBtn];
        if(_selectIndex == i){
            titleBtn.titleLabel.font = _selectBtnFont;
            titleBtn.selected = YES;
        }
    }
    [self setSCTypeUI];
}

#pragma mark - 根据SCType设置相关的风格
- (void)setSCTypeUI{
    UIButton *selectBtn = _titleArray[_selectIndex];
    if(self.SCType == SCType_Underline){
        if(self.stateView==nil){
            self.stateView = [[UIView alloc]init];
        }
        self.stateView.frame = CGRectMake(selectBtn.frame.origin.x, self.frame.size.height - _SCType_Underline_HEI, _selectBtnWID, _SCType_Underline_HEI);
        self.stateView.backgroundColor = _selectTitleColor;
        [self.scrollView addSubview:self.stateView];
    }else if(self.SCType == SCType_Dot){
        if(self.stateView==nil){
            self.stateView = [[UIView alloc]init];
        }
        self.stateView.frame = CGRectMake(selectBtn.frame.origin.x + (_selectBtnWID - _SCType_Underline_HEI)/2, self.frame.size.height - _SCType_Underline_HEI, _SCType_Underline_HEI, _SCType_Underline_HEI);
        self.stateView.backgroundColor = _selectTitleColor;
        self.stateView.layer.masksToBounds = YES;
        self.stateView.layer.cornerRadius = _SCType_Underline_HEI/2;
        [self.scrollView addSubview:self.stateView];
    }else if(self.SCType == SCType_Ellipse){
        if(self.stateView==nil){
            self.stateView = [[UIView alloc]init];
        }
        self.stateView.frame = CGRectMake(selectBtn.frame.origin.x, 0, _selectBtnWID, self.frame.size.height);
        self.stateView.backgroundColor = _ellipseBackColor;
        self.stateView.layer.masksToBounds = YES;
        self.stateView.layer.cornerRadius = _cornerRadius;
        [self.scrollView insertSubview:self.stateView belowSubview:selectBtn];
        self.layer.cornerRadius = _cornerRadius;
    }else if (self.SCType == SCType_SelectChange){
        
    }else if (self.SCType == SCType_BorderStyle){
        for (int i = 0; i<self.titleArray.count; i++) {
            UIButton *titleBtn = self.titleArray[i];
            titleBtn.backgroundColor = _titleColor;
        }
    }else if (self.SCType == SCType_None){
        
    }
}

#pragma mark - 头部按钮点击事件
- (void)titleBtnClick:(UIButton *)button{
    [self refreshUIWithSelectBtn:button];
}

- (void)refreshUIWithSelectBtn:(UIButton *)button{
    for (UIButton *titleBtn in self.titleArray) {
        titleBtn.selected = NO;
        titleBtn.titleLabel.font = _titleFont;
        titleBtn.backgroundColor = _titleBtnBackColor;
    }
    button.selected = YES;
    if(_selectBtnFont!=nil){
        button.titleLabel.font = _selectBtnFont;
    }
    _selectIndex = [self.titleArray indexOfObject:button];
    if(self.selectType){
        self.selectType(_selectIndex,button.currentTitle);
    }
    
    CGFloat offsetx = (button.frame.origin.x + _selectBtnWID + _selectBtnSpace) - self.scrollView.frame.size.width + _selectBtnWID;
    CGFloat offsetMax = self.scrollView.contentSize.width - self.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    CGPoint offset = CGPointMake(offsetx, self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:offset animated:YES];
    
    if(self.SCType == SCType_Underline){
        //下划线
        [UIView animateWithDuration:_animateDuration animations:^{
            self.stateView.frame = CGRectMake(button.frame.origin.x, self.frame.size.height - _SCType_Underline_HEI, _selectBtnWID, _SCType_Underline_HEI);
        }];
    }else if(self.SCType == SCType_Dot){
        [UIView animateWithDuration:_animateDuration animations:^{
            self.stateView.frame = CGRectMake(button.frame.origin.x + (_selectBtnWID - _SCType_Underline_HEI)/2, self.frame.size.height - _SCType_Underline_HEI, _SCType_Underline_HEI, _SCType_Underline_HEI);
        }];
    }else if(self.SCType == SCType_Ellipse){
        [UIView animateWithDuration:_animateDuration animations:^{
            self.stateView.frame = CGRectMake(button.frame.origin.x, 0, _selectBtnWID, self.frame.size.height);
        }];
    }else if (self.SCType == SCType_SelectChange){
        
    }else if (self.SCType == SCType_BorderStyle){
        [UIView animateWithDuration:_animateDuration animations:^{
            button.backgroundColor = _titleColor;
        }];
    }else if (self.SCType == SCType_None){
        
    }
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    for (UIButton *button in self.titleArray) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
}

- (void)setSelectTitleColor:(UIColor *)selectTitleColor{
    _selectTitleColor = selectTitleColor;
    for (UIButton *button in self.titleArray) {
        [button setTitleColor:selectTitleColor forState:UIControlStateSelected];
    }
}

- (void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    for (UIButton *button in self.titleArray) {
        button.titleLabel.font = titleFont;
    }
}

- (void)setSelectBtnFont:(UIFont *)selectBtnFont{
    _selectBtnFont = selectBtnFont;
    UIButton *selectBtn = self.titleArray[_selectIndex];
    selectBtn.titleLabel.font = _selectBtnFont;
}

- (void)setAnimateDuration:(CGFloat)animateDuration{
    _animateDuration = animateDuration;
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    if(borderWidth < 0) return;
    _borderWidth = borderWidth;
    self.selectBtnSpace = borderWidth;
    self.backgroundColor = _titleColor;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = _titleColor.CGColor;
    self.layer.cornerRadius = borderWidth;
}

- (void)setTitleBtnBackColor:(UIColor *)titleBtnBackColor{
    _titleBtnBackColor = titleBtnBackColor;
    UIButton *selectBtn = self.titleArray[_selectIndex];
    for (UIButton *button in self.titleArray) {
        button.backgroundColor = titleBtnBackColor;
        if(selectBtn == button){
            button.backgroundColor = _titleColor;
        }
    }
}

- (void)setSCType_Underline_HEI:(CGFloat)SCType_Underline_HEI{
    _SCType_Underline_HEI = SCType_Underline_HEI;
    UIButton *selectBtn = (UIButton *)self.scrollView.subviews[_selectIndex];
    if(self.SCType == SCType_Underline){
        self.stateView.frame = CGRectMake(selectBtn.frame.origin.x, self.frame.size.height - _SCType_Underline_HEI, _selectBtnWID, _SCType_Underline_HEI);
    }else if(self.SCType == SCType_Dot){
        self.stateView.frame = CGRectMake(selectBtn.frame.origin.x + (_selectBtnWID - _SCType_Underline_HEI)/2, self.frame.size.height - _SCType_Underline_HEI, _SCType_Underline_HEI, _SCType_Underline_HEI);
        self.stateView.layer.cornerRadius = _SCType_Underline_HEI/2;
    }else if(self.SCType == SCType_Ellipse){
        self.stateView.layer.cornerRadius = _cornerRadius;
        self.layer.cornerRadius = _cornerRadius;
    }
}

- (void)setEllipseBackColor:(UIColor *)ellipseBackColor{
    _ellipseBackColor = ellipseBackColor;
    if(self.SCType == SCType_Ellipse){
        self.stateView.backgroundColor = _ellipseBackColor;
    }
}

- (NSMutableArray *)titleArray{
    if(_titleArray==nil){
        _titleArray = [[NSMutableArray alloc]init];
    }
    return _titleArray;
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    _cornerRadius = cornerRadius;
    if(self.SCType == SCType_Ellipse){
        self.stateView.layer.cornerRadius = _cornerRadius;
        self.layer.cornerRadius = _cornerRadius;
    }
}

- (void)setEdgeInsetsStyle:(ZFJButtonEdgeInsetsStyle)edgeInsetsStyle{
    _edgeInsetsStyle = edgeInsetsStyle;
    for (UIButton *button in self.titleArray) {
        if(self.titleArr.count>0 && self.iconArr.count>0){
            [self layoutButtonWithEdgeInsetsStyle:_edgeInsetsStyle imageTitleSpace:_edgeInsetsSpace button:button];
        }
    }
}

- (void)setEdgeInsetsSpace:(CGFloat)edgeInsetsSpace{
    _edgeInsetsSpace = edgeInsetsSpace;
    for (UIButton *button in self.titleArray) {
        if(self.titleArr.count>0 && self.iconArr.count>0){
            [self layoutButtonWithEdgeInsetsStyle:_edgeInsetsStyle imageTitleSpace:_edgeInsetsSpace button:button];
        }
    }
}

- (void)setImageEdgeInsets:(UIEdgeInsets)imageEdgeInsets{
    _imageEdgeInsets = imageEdgeInsets;
    for (UIButton *button in self.titleArray) {
        if(self.titleArr.count>0 && self.iconArr.count>0){
            [self layoutButtonWithEdgeInsetsStyle:_edgeInsetsStyle imageTitleSpace:_edgeInsetsSpace button:button];
        }
    }
}

- (void)setLabelEdgeInsets:(UIEdgeInsets)labelEdgeInsets{
    _labelEdgeInsets = labelEdgeInsets;
    for (UIButton *button in self.titleArray) {
        if(self.titleArr.count>0 && self.iconArr.count>0){
            [self layoutButtonWithEdgeInsetsStyle:_edgeInsetsStyle imageTitleSpace:_edgeInsetsSpace button:button];
        }
    }
}

- (void)layoutButtonWithEdgeInsetsStyle:(ZFJButtonEdgeInsetsStyle)style imageTitleSpace:(CGFloat)space button:(UIButton *)button{
    //得到imageView和titleLabel的宽、高
    CGFloat imageWith = button.imageView.frame.size.width;
    CGFloat imageHeight = button.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        //由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = button.titleLabel.intrinsicContentSize.width;
        labelHeight = button.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = button.titleLabel.frame.size.width;
        labelHeight = button.titleLabel.frame.size.height;
    }
    
    //声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    //根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    //top, left, bottom, right
    switch (style) {
        case ZFJButtonEdgeInsetsStyleTop:
        {
            //这里面要是值不合适 可以自己手动调
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case ZFJButtonEdgeInsetsStyleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case ZFJButtonEdgeInsetsStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case ZFJButtonEdgeInsetsStyleRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        case ZFJButtonEdgeInsetsStyleNone:{
            imageEdgeInsets = _imageEdgeInsets;
            labelEdgeInsets = _labelEdgeInsets;
        }
            break;
        default:
            break;
    }
    button.titleEdgeInsets = labelEdgeInsets;
    button.imageEdgeInsets = imageEdgeInsets;
}

- (void)setSelectIndex:(NSInteger)selectIndex{
    if(selectIndex >self.titleArray.count || selectIndex<0) return;
    _selectIndex = selectIndex;
    UIButton *button = self.titleArray[selectIndex];
    [self refreshUIWithSelectBtn:button];
}

#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == self.scrollView){
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
