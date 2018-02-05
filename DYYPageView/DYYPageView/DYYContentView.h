//
//  DYYContentView.h
//  DYYPageView
//
//  Created by yang on 2018/1/30.
//  Copyright © 2018年 dingyangyang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DYYContentView;
@protocol DYYContentViewDelegate <NSObject>
-(void)contentView:(DYYContentView *)contentView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;
@optional
-(void)contentViewEndScroll:(DYYContentView *)contentView;
@end
@interface DYYContentView : UIView
@property (nonatomic, weak)id<DYYContentViewDelegate> delegate;

+(instancetype)contentViewWithFrame:(CGRect)frame childVCs:(NSArray <UIViewController *>*)childVcs parentVc:(UIViewController *)parentVc;
-(void)setCurrentIndex:(NSInteger)currentIndex;

@end
