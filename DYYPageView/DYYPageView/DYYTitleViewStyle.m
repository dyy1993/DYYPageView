//
//  DYYTitleViewStyle.m
//  DYYPageView
//
//  Created by yang on 2018/1/30.
//  Copyright © 2018年 dingyangyang. All rights reserved.
//

#import "DYYTitleViewStyle.h"
#import "DYYPageViewHeader.h"
@implementation DYYTitleViewStyle
+ (instancetype)defaultStyle{
    DYYTitleViewStyle *style = [[DYYTitleViewStyle alloc] init];
    /// 是否是滚动的Title
    style.isScrollEnable = NO;
    /// 普通Title颜色
    style.normalColor  = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    /// 选中Title颜色
    style.selectedColor = [UIColor colorWithRed:255/255.0 green:127/255.0 blue:0/255.0 alpha:1];
    /// Title字体大小
    style.font = [UIFont systemFontOfSize:14];
    /// 滚动Title的字体间距
    style.titleMargin = 20;
    /// 设置titleView的高度
    style.titleHeight  = 44;
    
    /// 是否显示底部滚动条
    style.isShowBottomLine = NO;
    /// 底部滚动条的颜色
    style.bottomLineColor = [UIColor orangeColor];
    /// 底部滚动条的高度
    style.bottomLineH  = 2;
    
    
    /// 是否进行缩放
    style.isNeedScale = NO;
    style.scaleRange = 1.2;
    
    
    /// 是否显示遮盖
    style.isShowCover = NO;
    /// 遮盖背景颜色
    style.coverBgColor = [UIColor lightGrayColor];
    /// 文字&遮盖间隙
    style.coverMargin = 5;
    /// 遮盖的高度
    style.coverH = 25;
    /// 设置圆角大小
    style.coverRadius = 12;
    
    return style;
}

@end
