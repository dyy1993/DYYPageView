//
//  DYYPageView.m
//  DYYPageView
//
//  Created by yang on 2018/1/30.
//  Copyright © 2018年 dingyangyang. All rights reserved.
//

#import "DYYPageView.h"
#import "DYYContentView.h"
@interface DYYPageView()<DYYTitleViewDelegate,DYYContentViewDelegate>
@property (nonatomic, strong)NSArray <NSString *> *titles;
@property (nonatomic, strong)NSArray <UIViewController *> *childVCs;
@property (nonatomic, strong)UIViewController *parentVc;
@property (nonatomic, strong)DYYTitleViewStyle *style;
@property (nonatomic, strong)DYYContentView *contentView;

@end
@implementation DYYPageView
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)setUpWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles childVCs:(NSArray <UIViewController *>*)childVcs parentVc:(UIViewController *)parentVc style:(DYYTitleViewStyle *)style{
    self.frame = frame;
    self.titles = titles;
    self.childVCs = childVcs;
    self.parentVc = parentVc;
    self.style = style;
    parentVc.automaticallyAdjustsScrollViewInsets = NO;

    [self setupUI];
}

-(void)setupUI{
    self.titleView.delegate = self;
    self.contentView.delegate = self;
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"布局pageview");
    if (self.titleView.superview != self) {
        self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
}
#pragma mark - contentviewDelegate
-(void)contentView:(DYYContentView *)contentView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex{
    NSLog(@"%f",progress);
    [self.titleView setTitleWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
}
-(void)contentViewEndScroll:(DYYContentView *)contentView{
    [self.titleView contentViewDidEndScroll];
}
#pragma mark - titleviewDelegate
-(void)titleView:(DYYTitleView *)titleView selectedIndex:(NSInteger)selectedIndex{
    [self.contentView setCurrentIndex:selectedIndex];
}

#pragma mark - lazy
-(DYYTitleView *)titleView{
    if (_titleView == nil) {
        DYYTitleView * titleView = [DYYTitleView titleViewWithFrame: CGRectMake(0, 0, self.frame.size.width, self.style.titleHeight) titles:self.titles style:self.style];
        [self addSubview:titleView];
        _titleView = titleView;
    }
    return _titleView;
}
-(DYYContentView *)contentView{
    if (_contentView == nil) {
        DYYContentView * contentView = [DYYContentView contentViewWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), self.frame.size.width, self.frame.size.height - CGRectGetMaxY(self.titleView.frame)) childVCs:self.childVCs parentVc:self.parentVc];
        [self addSubview:contentView];
        _contentView = contentView;
    }
    return _contentView;
}

@end
