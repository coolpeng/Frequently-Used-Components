//
//  LaunchGuideViewController.h
//  PLJGuideViewDemo
//
//  Created by Edward on 2018/3/30.
//  Copyright © 2018年 coolpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LaunchGuideViewImageType) {
    LaunchGuideViewImageTypeNormal = 0,
    LaunchGuideViewImageTypeGif = 1
};

@interface LaunchGuideViewController : UIViewController

@property (nonatomic,copy) void (^didFinishLaunchingGuideViewBlock)(void);
@property (nonatomic,assign) LaunchGuideViewImageType imageType;

+ (BOOL)shouldShowGuideViewController;

@end
