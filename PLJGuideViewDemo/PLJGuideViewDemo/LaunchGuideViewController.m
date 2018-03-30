//
//  LaunchGuideViewController.m
//  PLJGuideViewDemo
//
//  Created by Edward on 2018/3/30.
//  Copyright © 2018年 coolpeng. All rights reserved.
//

#import "LaunchGuideViewController.h"
#import "YFGIFImageView.h"

#define kScreenW [[UIScreen mainScreen] bounds].size.width
#define kScreenH [[UIScreen mainScreen] bounds].size.height

static NSString *LOCAL_CURRENT_VERSION = @"LocalCurrentVersion";

@interface LaunchGuideViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView  *launchScrollView;
@property (nonatomic,strong) NSMutableArray *imagePathsArr;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIButton *skipBtn;

@end

@implementation LaunchGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imagePathsArr = [NSMutableArray array];
    for (int i=1;i<5;i++) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%02d",i] ofType:@"jpg"];
        [self.imagePathsArr addObject:path];
    }
    
    [self createSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Outsdide Methods
/*
 判断是否需要展示引导页
 */
+ (BOOL)shouldShowGuideViewController {
    
    // 读取版本信息
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *localVersion = [user objectForKey:LOCAL_CURRENT_VERSION];
    NSString *currentVersion =[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if (localVersion == nil || ![currentVersion isEqualToString:localVersion]) {
        return YES;
    }else {
        return NO;
    }
}

#pragma mark UI
- (void)createSubviews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self createScrollView];
    [self createPageControlView];
    [self createSkipBtn];
}

- (void)createScrollView {
    
    self.launchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    self.launchScrollView.showsHorizontalScrollIndicator = NO;
    self.launchScrollView.bounces = NO;
    self.launchScrollView.pagingEnabled = YES;
    self.launchScrollView.delegate = self;
    self.launchScrollView.contentSize = CGSizeMake(kScreenW * self.imagePathsArr.count, kScreenH);
    [self.view addSubview:self.launchScrollView];
    
    if (self.imageType == LaunchGuideViewImageTypeGif) {
        for (int i = 0; i < self.imagePathsArr.count; i++) {
            YFGIFImageView *imageView = [[YFGIFImageView alloc] initWithFrame:CGRectMake(i*kScreenW, 0, kScreenW, kScreenH)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.gifPath = self.imagePathsArr[i];
            [imageView startGIF];
            [self.launchScrollView addSubview:imageView];
            
            if (i == self.imagePathsArr.count - 1) {
                imageView.userInteractionEnabled = YES;
                [imageView addSubview:[self addEnterBtn]];
            }
        }
    }
    
    if (self.imageType == LaunchGuideViewImageTypeNormal) {
        for (int i = 0; i < self.imagePathsArr.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kScreenW, 0, kScreenW, kScreenH)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.image = [UIImage imageWithContentsOfFile:self.imagePathsArr[i]];
            [self.launchScrollView addSubview:imageView];
            if (i == self.imagePathsArr.count - 1) {
                imageView.userInteractionEnabled = YES;
                [imageView addSubview:[self addEnterBtn]];
            }
        }
    }
}

- (void)createPageControlView {
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreenH-33-13, kScreenW, 13)];
    self.pageControl.numberOfPages = self.imagePathsArr.count;
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.pageControl.currentPage = 0;
    self.pageControl.defersCurrentPageDisplay = YES;
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    [self.view addSubview:self.pageControl];
}

- (void)createSkipBtn {
    self.skipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    CGFloat width = 33;
    CGFloat height = 15;
    CGFloat x = kScreenW-width-18;
    CGFloat y = 48;
    self.skipBtn.frame = CGRectMake(x, y, width, height);
    self.skipBtn.backgroundColor = [UIColor clearColor];
    self.skipBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.skipBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.skipBtn addTarget:self action:@selector(skipGuideViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.skipBtn];
    [self.view bringSubviewToFront:self.skipBtn];
}

- (UIButton *)addEnterBtn {
    
    CGFloat w = 132;
    CGFloat h = 38;
    CGFloat x = (kScreenW-w)/2;
    CGFloat y = kScreenH-82-h;
    UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, w, h)];
    [enterButton setTitle:@"立即体验" forState:UIControlStateNormal];
    enterButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
    [enterButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    enterButton.layer.cornerRadius = 18.0;
    enterButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    enterButton.layer.borderWidth = 1;
    [enterButton addTarget:self action:@selector(skipGuideViewController) forControlEvents:UIControlEventTouchUpInside];
    return enterButton;
}

#pragma mark Event
- (void)skipGuideViewController {
    if (self.didFinishLaunchingGuideViewBlock) {
        self.didFinishLaunchingGuideViewBlock();
        [LaunchGuideViewController saveCurrentVersion];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.launchScrollView) {
        int cuttentIndex = (int)(scrollView.contentOffset.x + kScreenW/2)/kScreenW;
        self.pageControl.currentPage = cuttentIndex;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    int cuttentIndex = (int)(scrollView.contentOffset.x + kScreenW/2)/kScreenW;
    if (cuttentIndex == self.imagePathsArr.count - 1) {
        if ([self isScrollToLeft:scrollView]) {
            [self skipGuideViewController];
        }
    }
}

#pragma mark Private Method
// 判断滚动方向
- (BOOL)isScrollToLeft:(UIScrollView *)scrollView {
    //返回YES为向左反动，NO为右滚动
    if ([scrollView.panGestureRecognizer translationInView:scrollView.superview].x < 0) {
        return YES;
    }else{
        return NO;
    }
}

/*
 保存版本信息
 */
+ (void)saveCurrentVersion
{
    NSString *version =[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:version forKey:LOCAL_CURRENT_VERSION];
    [user synchronize];
}

@end
