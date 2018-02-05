//
//  ViewController.m
//  DYYPageView
//
//  Created by yang on 2018/1/30.
//  Copyright © 2018年 dingyangyang. All rights reserved.
//

#import "ViewController.h"
#import "DYYPageView.h"
#import "TestViewController.h"
@interface ViewController ()
@property (nonatomic, strong) DYYPageView *pageView;

@end

@implementation ViewController
-(DYYPageView *)pageView{
    if (_pageView == nil) {
        DYYPageView *pageView = [[DYYPageView alloc] init];
        [self.view addSubview:pageView];
        _pageView = pageView;
    }
    return _pageView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
  
    TestViewController *vc1 = [[TestViewController alloc] init];
    TestViewController *vc2 = [[TestViewController alloc] init];
    TestViewController *vc3 = [[TestViewController alloc] init];
    TestViewController *vc4 = [[TestViewController alloc] init];
    TestViewController *vc5 = [[TestViewController alloc] init];
    TestViewController *vc6 = [[TestViewController alloc] init];
    TestViewController *vc7 = [[TestViewController alloc] init];
    DYYTitleViewStyle *style = [DYYTitleViewStyle defaultStyle];
    style.isScrollEnable = YES;
    style.isShowBottomLine = YES;
    style.isNeedScale = YES;
    style.isShowCover = YES;
//    style.selectedColor = [UIColor colorWithRed:1/255.0 green:190/255.0 blue:1/255.0 alpha:1];
//    style.normalColor = [UIColor colorWithRed:1/255.0 green:1/255.0 blue:1/255.0 alpha:1];
    

    [self.pageView setUpWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height) titles:@[@"英雄联盟",@"守望先锋",@"暗黑",@"美颜",@"野外直播",@"娱乐天地",@"营养师"] childVCs:@[vc1,vc2,vc3,vc4,vc5,vc6,vc7] parentVc:self style:style];
   
//    self.pageView.titleView.frame = CGRectMake(0, 0, 300, 40);
//    self.navigationItem.titleView = self.pageView.titleView;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
