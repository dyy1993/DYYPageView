//
//  DYYTitleView.m
//  DYYPageView
//
//  Created by yang on 2018/1/30.
//  Copyright © 2018年 dingyangyang. All rights reserved.
//

#import "DYYTitleView.h"

@interface DYYTitleView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)NSArray <NSString *> *titles;
@property (nonatomic, strong)DYYTitleViewStyle *style;
@property (nonatomic, assign)NSInteger currentIndex;

@property (nonatomic, strong)NSMutableArray <UILabel *> *titleLabels;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIView *splitLineView;
@property (nonatomic, strong)UIView *bottomLine;
@property (nonatomic, strong)UIView *coverView;
@end
@implementation DYYTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
+(instancetype)titleViewWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles style:(DYYTitleViewStyle *)style{
    DYYTitleView *titleView = [[DYYTitleView alloc] initWithFrame:frame];
    titleView.titles = titles;
    titleView.style = style;
    [titleView setupUI];

    return titleView;
}

-(void)setupUI{
    
    // 1.添加Scrollview
    [self addSubview:self.scrollView];
    // 2.添加底部分割线
    [self addSubview:self.splitLineView];
    
    // 3.设置所有的标题Label

    [self setupTitleLabels];
    
    // 4.设置Label的位置
    [self setupTitleLabelsPosition];
    
    // 5.设置底部的滚动条

    if (self.style.isShowBottomLine) {
        [self setupBottomLin];
    }
//
//    // 6.设置遮盖的View
    if (self.style.isShowCover) {
        [self setupCoverView];
    }
    
}

-(void)setupTitleLabels{
    for (int i = 0; i < self.titles.count ; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.tag = i;
        label.text = self.titles[i];
        label.textColor = i == 0 ? self.style.selectedColor : self.style.normalColor;
        label.font = self.style.font;
        label.textAlignment = NSTextAlignmentCenter;
        
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)];
        [label addGestureRecognizer:tapGes];
        
        [self.titleLabels addObject:label];
        
        [self.scrollView addSubview:label];
    }
}
-(void)setupTitleLabelsPosition{
    CGFloat titleX = 0.0;
    CGFloat titleW = 0.0;
    CGFloat titleY = 0.0;
    CGFloat titleH = self.frame.size.height;
    
    NSUInteger count = self.titles.count;
    
    for (int index = 0 ; index < self.titleLabels.count; index ++) {
        UILabel *label = self.titleLabels[index];

        if (self.style.isScrollEnable) {
            
            CGRect rect = [label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.style.font} context:nil];
            
           
            titleW = rect.size.width;
            if (index == 0) {
                titleX = self.style.titleMargin * 0.5;
            } else {
                UILabel *preLabel = self.titleLabels[index - 1];
                titleX = CGRectGetMaxX(preLabel.frame) + self.style.titleMargin;
            }
            
        } else {
            titleW = self.frame.size.width / (CGFloat)(count);
            titleX = titleW * (CGFloat)(index);
        }
        
        label.frame = CGRectMake(titleX, titleY, titleW, titleH);
        
        // 放大的代码
        if (index == 0) {
            CGFloat scale = self.style.isNeedScale ? self.style.scaleRange : 1.0;
            label.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
    
    if (self.style.isScrollEnable) {
        self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(self.titleLabels.lastObject.frame) + self.style.titleMargin * 0.5 , 0);
    }
}
-(void)setupBottomLin{
    [self.scrollView addSubview:self.bottomLine];
    
    self.bottomLine.frame = CGRectMake(self.titleLabels.firstObject.frame.origin.x, self.bounds.size.height - self.style.bottomLineH, self.titleLabels.firstObject.frame.size.width, self.style.bottomLineH);
 
}
-(void)setupCoverView{
    [self.scrollView insertSubview:self.coverView atIndex:0];
    UILabel *firstLabel = self.titleLabels[0];
    CGFloat coverW = firstLabel.frame.size.width;
    CGFloat coverH = self.style.coverH;
    CGFloat coverX = firstLabel.frame.origin.x;
    CGFloat coverY = (self.bounds.size.height - coverH) * 0.5;
    
    if (self.style.isScrollEnable) {
        coverX -= self.style.coverMargin;
        coverW += self.style.coverMargin * 2;
    }
    self.coverView.frame = CGRectMake(coverX, coverY, coverW, coverH);
    
    self.coverView.layer.cornerRadius = self.style.coverRadius;
    self.coverView.layer.masksToBounds = YES;
}
-(void)titleLabelClick:(UITapGestureRecognizer *)tap{
    // 0.获取当前Label
    UILabel *currentLabel = (UILabel *)tap.view;
    
    // 1.如果是重复点击同一个Title,那么直接返回
    if (currentLabel.tag == self.currentIndex) { return; }
    
    // 2.获取之前的Label
    UILabel *oldLabel = self.titleLabels[self.currentIndex];
    
    // 3.切换文字的颜色
    currentLabel.textColor = self.style.selectedColor;
    oldLabel.textColor = self.style.normalColor;
    
    // 4.保存最新Label的下标值
    self.currentIndex = currentLabel.tag;
    
    // 5.通知代理
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleView:selectedIndex:)]) {
        [self.delegate titleView:self selectedIndex:self.currentIndex];
    }
    
    // 6.居中显示
    [self contentViewDidEndScroll];
    
    // 7.调整bottomLine
    if (self.style.isShowBottomLine) {
        [UIView animateWithDuration:0.15 animations:^{
           self.bottomLine.frame = CGRectMake(currentLabel.frame.origin.x, self.bottomLine.frame.origin.y, currentLabel.frame.size.width, self.bottomLine.frame.size.height);
        }];
      
    }
    
    // 8.调整比例
    if (self.style.isNeedScale) {
        oldLabel.transform = CGAffineTransformIdentity;
        currentLabel.transform = CGAffineTransformMakeScale(self.style.scaleRange, self.style.scaleRange);
    }
    
    // 9.遮盖移动
    if (self.style.isShowCover) {
        CGFloat coverX = self.style.isScrollEnable ? (currentLabel.frame.origin.x - self.style.coverMargin) : currentLabel.frame.origin.x;
        CGFloat coverW = self.style.isScrollEnable ? (currentLabel.frame.size.width + self.style.coverMargin * 2) : currentLabel.frame.size.width;
        [UIView animateWithDuration:0.15 animations:^{
            self.coverView.frame = CGRectMake(coverX, self.coverView.frame.origin.y, coverW, self.coverView.frame.size.height);
        }];
      
    }

}
-(void)contentViewDidEndScroll{
    
    // 0.如果是不需要滚动,则不需要调整中间位置
    if (!self.style.isScrollEnable){
        return;
    }
    
    // 1.获取获取目标的Label
    UILabel *targetLabel = self.titleLabels[self.currentIndex];
    
    // 2.计算和中间位置的偏移量
    CGFloat offSetX = targetLabel.center.x - self.bounds.size.width * 0.5;
    if (offSetX < 0) {
        offSetX = 0;
    }
    
    CGFloat maxOffset = self.scrollView.contentSize.width - self.bounds.size.width;
    if (offSetX > maxOffset) {
        offSetX = maxOffset;
    }
    
    // 3.滚动UIScrollView
    [self.scrollView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
}

- (NSArray<NSNumber *>*)getRGBWithColor:(UIColor *)color
{
    if (color == nil) {
        return @[@(255), @( 255), @(255), @(1)];
    }
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return @[@(red * 255), @(green * 255), @(blue * 255), @(alpha)];
}
#pragma mark - 外部设置
-(void)setTitleWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex{
    // 1.取出sourceLabel/targetLabel
    UILabel *sourceLabel = self.titleLabels[sourceIndex];
    UILabel *targetLabel = self.titleLabels[targetIndex];
    
    // 3.颜色的渐变(复杂)
    // 3.1.取出变化的范围
    NSArray<NSNumber*> *selectedColorRGB = [self getRGBWithColor:self.style.selectedColor];
    NSArray<NSNumber*> *normalColorRGB = [self getRGBWithColor:self.style.normalColor];
    
    NSArray<NSNumber*> *colorDelta = @[@(selectedColorRGB[0].floatValue - normalColorRGB[0].floatValue),@(selectedColorRGB[1].floatValue - normalColorRGB[1].floatValue),@(selectedColorRGB[2].floatValue - normalColorRGB[2].floatValue)];
    
    // 3.2.变化sourceLabel
    sourceLabel.textColor = [UIColor colorWithRed:(selectedColorRGB[0].floatValue - colorDelta[0].floatValue * progress)/ 255.0 green:(selectedColorRGB[1].floatValue - colorDelta[1].floatValue * progress)/255.0 blue:(selectedColorRGB[2].floatValue - colorDelta[2].floatValue * progress)/255.0 alpha:1];
//
//    // 3.2.变化targetLabel
      targetLabel.textColor = [UIColor colorWithRed:(normalColorRGB[0].floatValue + colorDelta[0].floatValue * progress)/255.0 green:(normalColorRGB[1].floatValue + colorDelta[1].floatValue * progress)/255.0 blue:(normalColorRGB[2].floatValue + colorDelta[2].floatValue * progress)/255.0 alpha:1];
    
    // 4.记录最新的index
    self.currentIndex = targetIndex;
    
    
    CGFloat moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
    CGFloat moveTotalW = targetLabel.frame.size.width - sourceLabel.frame.size.width;
    
    // 5.计算滚动的范围差值
    if (self.style.isShowBottomLine) {
        self.bottomLine.frame = CGRectMake(sourceLabel.frame.origin.x + moveTotalX * progress, self.bottomLine.frame.origin.y, sourceLabel.frame.size.width + moveTotalW * progress, self.bottomLine.frame.size.height);
    }
    
    // 6.放大的比例
    if (self.style.isNeedScale) {
        CGFloat scaleDelta = (self.style.scaleRange - 1.0) * progress;
        sourceLabel.transform = CGAffineTransformMakeScale(self.style.scaleRange - scaleDelta, self.style.scaleRange - scaleDelta);
        targetLabel.transform = CGAffineTransformMakeScale(1.0 + scaleDelta, 1.0 + scaleDelta);
        
    }
    
    // 7.计算cover的滚动
    if (self.style.isShowCover) {
        CGFloat w = self.style.isScrollEnable ? (sourceLabel.frame.size.width + 2 * self.style.coverMargin + moveTotalW * progress) : (sourceLabel.frame.size.width + moveTotalW * progress);
        CGFloat x = self.style.isScrollEnable ? (sourceLabel.frame.origin.x - self.style.coverMargin + moveTotalX * progress) : (sourceLabel.frame.origin.x + moveTotalX * progress);
        self.coverView.frame = CGRectMake(x, self.coverView.frame.origin.y, w, self.coverView.frame.size.height);
     
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"布局子控件");
    self.scrollView.frame = self.bounds;
    CGFloat h = 0.5;
    self.splitLineView.frame = CGRectMake(0, self.frame.size.height - h, self.frame.size.width, h);
}
#pragma mark - lazy
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scrollV = [[UIScrollView alloc] init];
        scrollV.frame = self.bounds;
        scrollV.showsHorizontalScrollIndicator = false;
        scrollV.scrollsToTop = false;
        _scrollView = scrollV;
    }
    return _scrollView;
}
-(UIView *)splitLineView{
    if (!_splitLineView) {
        UIView *splitView = [[UIView alloc] init];
        splitView.backgroundColor = [UIColor lightGrayColor];
        CGFloat h = 0.5;
        splitView.frame = CGRectMake(0, self.frame.size.height - h, self.frame.size.width, h);
        _splitLineView = splitView;
    }
    return _splitLineView;
}
-(UIView *)bottomLine{
    if (!_bottomLine) {
        UIView *bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = self.style.bottomLineColor;
        _bottomLine = bottomLine;
    }
    return _bottomLine;
}
-(UIView *)coverView{
    if (!_coverView) {
        UIView *coverView = [[UIView alloc] init];
        coverView.backgroundColor = self.style.coverBgColor;
        coverView.alpha = 0.7;
        _coverView = coverView;
    }
    return _coverView;
}
-(NSMutableArray<UILabel *> *)titleLabels{
    if (!_titleLabels) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}
@end
