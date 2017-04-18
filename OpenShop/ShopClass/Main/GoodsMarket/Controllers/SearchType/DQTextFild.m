//
//  DQTextFild.m
//  本色堂
//
//  Created by 广州玉贝网络科技有限公司 on 16/4/14.
//  Copyright © 2016年 广州天弈歌贸易有限公司. All rights reserved.
//

#import "DQTextFild.h"

@implementation DQTextFild
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
//重写左视图的位置
- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect SearchRect = [super leftViewRectForBounds:bounds];
    SearchRect.origin.x +=10;
    
    return SearchRect;
}
//重写占位符的x值
- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    CGRect placeholderRect = [super placeholderRectForBounds:bounds];
    placeholderRect.origin.x +=1;
    return placeholderRect;
}
//重写文字输入时的x值
- (CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect editingRect = [super editingRectForBounds:bounds];
    editingRect.origin.x +=10;

    return editingRect;
}
//  重写文字显示时的X值
- (CGRect)textRectForBounds:(CGRect)bounds{
    CGRect textRect = [super editingRectForBounds:bounds];
    textRect.origin.x += 10;
    return textRect;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
