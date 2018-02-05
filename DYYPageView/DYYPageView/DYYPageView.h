//
//  DYYPageView.h
//  DYYPageView
//
//  Created by yang on 2018/1/30.
//  Copyright © 2018年 dingyangyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYYTitleViewStyle.h"
#import "DYYTitleView.h"

@interface DYYPageView : UIView
@property (nonatomic, strong)DYYTitleView *titleView;

- (void)setUpWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles childVCs:(NSArray <UIViewController *>*)childVcs parentVc:(UIViewController *)parentVc style:(DYYTitleViewStyle *)style;

@end
