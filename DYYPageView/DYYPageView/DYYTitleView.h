//
//  DYYTitleView.h
//  DYYPageView
//
//  Created by yang on 2018/1/30.
//  Copyright © 2018年 dingyangyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYYTitleViewStyle.h"
@class DYYTitleView;
@protocol DYYTitleViewDelegate <NSObject>
-(void)titleView:(DYYTitleView *)titleView selectedIndex:(NSInteger)selectedIndex;

@end
@interface DYYTitleView : UIView
@property (nonatomic, weak)id<DYYTitleViewDelegate> delegate;

+(instancetype)titleViewWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles style:(DYYTitleViewStyle *)style;

-(void)setTitleWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;
-(void)contentViewDidEndScroll;
@end
