//
//  SY_AVFView.h
//  ChaTo
//
//  Created by yxy on 17/6/15.
//  Copyright © 2017年 霜月. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SY_RecordEncoder.h"

@protocol SY_AVFViewDelegate <NSObject>

- (void)recordProgress:(CGFloat)progress;

@end

@interface SY_AVFView : NSObject

@property (nonatomic, assign) BOOL isCapturing;//正在录制

@property (atomic, assign) BOOL discont;//是否中断

@property (nonatomic, assign) CGFloat currentRecordTime;//当前录制时间
@property (nonatomic, assign) CGFloat maxRecordTime;//录制最长时间
@property (nonatomic, weak) id<SY_AVFViewDelegate>delegate;
@property (nonatomic, strong) NSString *videoPath;//视频路径

//捕获到的视频呈现的layer
- (AVCaptureVideoPreviewLayer *)previewLayer;
//启动录制功能
- (void)startUp;
//关闭录制功能
- (void)shutdown;
//开始录制
- (void) startCapture;

//停止录制 写入相册
- (void) stopCaptureHandler:(void (^)(UIImage *movieImage))handler;
////继续录制
//- (void) resumeCapture;
//切换前后置摄像头
- (void)changeCameraInputDeviceisFront:(BOOL)isFront;
//将mov的视频转成mp4
- (void)changeMovToMp4:(NSURL *)mediaURL dataBlock:(void (^)(UIImage *movieImage))handler;

@end
