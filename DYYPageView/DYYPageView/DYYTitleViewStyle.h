//
//  DYYTitleViewStyle.h
//  DYYPageView
//
//  Created by yang on 2018/1/30.
//  Copyright © 2018年 dingyangyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DYYTitleViewStyle : NSObject
+ (instancetype)defaultStyle;

@property (nonatomic, strong) UIColor *scrollTabBarBackgroundColor;

@property (nonatomic, strong) UIColor *itemNormalColor;
@property (nonatomic, strong) UIColor *itemSelectColor;
@property (nonatomic, strong) UIFont *itemFont;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, assign) CGFloat indicatorHeight;
@property (nonatomic, assign) CGFloat indicatorExtraW;


/// 是否是滚动的Title
@property (nonatomic, assign) BOOL isScrollEnable;
/// 普通Title颜色
@property (nonatomic, strong) UIColor *normalColor;

/// 选中Title颜色
@property (nonatomic, strong) UIColor *selectedColor;

/// Title字体大小
@property (nonatomic, strong) UIFont *font;

/// 滚动Title的字体间距
@property (nonatomic, assign) CGFloat titleMargin;

/// 设置titleView的高度
@property (nonatomic, assign) CGFloat titleHeight;

/// 是否显示底部滚动条
@property (nonatomic, assign) BOOL isShowBottomLine;

/// 底部滚动条的颜色
@property (nonatomic, strong) UIColor *bottomLineColor;

/// 底部滚动条的高度
@property (nonatomic, assign) CGFloat bottomLineH;

/// 是否进行缩放
@property (nonatomic, assign) BOOL isNeedScale;

@property (nonatomic, assign) CGFloat scaleRange;

/// 是否显示遮盖
@property (nonatomic, assign) BOOL isShowCover;

/// 遮盖背景颜色
@property (nonatomic, strong) UIColor *coverBgColor;

/// 文字&遮盖间隙
@property (nonatomic, assign) CGFloat coverMargin;

/// 遮盖的高度
@property (nonatomic, assign) CGFloat coverH;

/// 设置圆角大小
@property (nonatomic, assign) CGFloat coverRadius;


@end
