//
//  DYYContentView.m
//  DYYPageView
//
//  Created by yang on 2018/1/30.
//  Copyright © 2018年 dingyangyang. All rights reserved.
//

#import "DYYContentView.h"

@interface DYYContentView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong)NSArray <UIViewController *> *childVCs;
@property (nonatomic, strong)UIViewController *parentVc;

@property (nonatomic, strong)UICollectionView *collectionView;

@property (nonatomic, assign)BOOL isForbidScrollDelegate;
@property (nonatomic, assign)CGFloat startOffsetX;
@end
static NSString *kContentCellID = @"kContentCellID";
@implementation DYYContentView
-(UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.scrollsToTop = false;
        collectionView.bounces = false;
        collectionView.showsHorizontalScrollIndicator = false;
        collectionView.frame = self.bounds;
        collectionView.pagingEnabled = YES;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kContentCellID];
        collectionView.backgroundColor = [UIColor clearColor];
        _collectionView = collectionView;
    }
    return _collectionView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
+(instancetype)contentViewWithFrame:(CGRect)frame childVCs:(NSArray <UIViewController *>*)childVcs parentVc:(UIViewController *)parentVc{
    DYYContentView *contentView = [[DYYContentView alloc] initWithFrame:frame];
    contentView.childVCs = childVcs;
    contentView.parentVc = parentVc;
    
    return contentView;
}


-(void)setupUI{
    
    for (UIViewController *vc in self.childVCs) {
        [self.parentVc addChildViewController:vc];
    }
    [self addSubview:self.collectionView];
}
#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.childVCs.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kContentCellID forIndexPath:indexPath];
    
    for (UIView *subView  in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    UIViewController *vc = self.childVCs[indexPath.item];
    vc.view.frame = cell.contentView.bounds;
    [cell.contentView addSubview:vc.view];
    return cell;
}
#pragma mark - UICollectionViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isForbidScrollDelegate = NO;
    
    self.startOffsetX = scrollView.contentOffset.x;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 0.判断是否是点击事件

    if (self.isForbidScrollDelegate) {
        return;
    }
    // 1.定义获取需要的数据
    CGFloat progress  = 0;
    NSInteger sourceIndex = 0;
    NSInteger targetIndex  = 0;
    // 2.判断是左滑还是右滑
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    if (currentOffsetX > self.startOffsetX) { // 左滑
        // 1.计算progress
        progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW);
        
        // 2.计算sourceIndex
    //=================================
        sourceIndex =(NSInteger)(currentOffsetX / scrollViewW);
        
        // 3.计算targetIndex
        targetIndex = sourceIndex + 1;
        if (targetIndex >= self.childVCs.count) {
            targetIndex = self.childVCs.count - 1;
        }
        
        // 4.如果完全划过去
        if (currentOffsetX - self.startOffsetX == scrollViewW ){
            progress = 1;
            targetIndex = sourceIndex;
        }
    } else { // 右滑
        // 1.计算progress
        progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
        //=================================
        // 2.计算targetIndex
        targetIndex = (NSInteger)(currentOffsetX / scrollViewW);

        // 3.计算sourceIndex
        sourceIndex = targetIndex + 1;
        if (sourceIndex >= self.childVCs.count) {
            sourceIndex = self.childVCs.count - 1;
        }
    }
    
    // 3.将progress/sourceIndex/targetIndex传递给titleView
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentView:progress:sourceIndex:targetIndex:)]) {
        [self.delegate contentView:self progress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    }
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentViewEndScroll:)]) {
        [self.delegate contentViewEndScroll:self];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(contentViewEndScroll:)]) {
            [self.delegate contentViewEndScroll:self];
        }
    }
   
}

-(void)setCurrentIndex:(NSInteger)currentIndex{
    
    // 1.记录需要进制执行代理方法
    self.isForbidScrollDelegate = true;
    
    // 2.滚动正确的位置
    CGFloat offsetX = (CGFloat)(currentIndex) * self.collectionView.frame.size.width;
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:NO];
}
@end
