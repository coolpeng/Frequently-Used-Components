//
//  YFGIFImageView.h
//  UIImageView-PlayGIF
//
//  Created by Yang Fei on 14-3-26.
//  Copyright (c) 2014年 yangfei.me. All rights reserved.
//

/*******************************************************
 *  Dependencies:
 *      - QuartzCore.framework
 *      - ImageIO.framework
 *  Parameters:
 *      Pass value to one of them:
 *      - gifData NSData from a GIF
 *      - gifPath local path of a GIF
 
 *      - unRepeat              Unrepeat playing.
 *      - playingComplete       Invoked after playing done.
 *  Usage:
 *      - startGIF
 *      - stopGIF
 *      - isGIFPlaying
 *******************************************************/

@interface YFGIFImageView : UIImageView
@property (nonatomic, strong) NSString          *gifPath;
@property (nonatomic, strong) NSData            *gifData;
@property (nonatomic, assign, readonly) CGSize  gifPixelSize;
@property (nonatomic, assign) BOOL              unRepeat;
@property (copy, nonatomic) void(^playingComplete)(void);
- (void)startGIF;
- (void)startGIFWithRunLoopMode:(NSString * const)runLoopMode andImageDidLoad:(void(^)(CGSize imageSize))didLoad;
- (void)stopGIF;
- (BOOL)isGIFPlaying;
@end
