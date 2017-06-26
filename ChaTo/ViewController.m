//
//  ViewController.m
//  ChaTo
//
//  Created by yxy on 17/6/16.
//  Copyright © 2017年 霜月. All rights reserved.
//

#import "ViewController.h"
#import <GPUImage.h>
#import "SY_AVFView.h"
#import "SY_ProgressView.h"

#define sy_width [UIScreen mainScreen].bounds.size.width
#define sy_height [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<SY_AVFViewDelegate>
@property (nonatomic, strong)UIButton                *changeCameraBT;
@property (nonatomic, strong)UIButton                *recordBt;
@property (nonatomic, strong)SY_ProgressView         *progressView;
@property (nonatomic, strong)SY_AVFView              *recordEngine;
@property (nonatomic, assign)BOOL                    allowRecord;//允许;

@end

@implementation ViewController

#pragma mark - set、get方法
//必须设置 不设置则不显示
- (SY_AVFView *)recordEngine {
    if (_recordEngine == nil) {
        _recordEngine = [[SY_AVFView alloc] init];
        _recordEngine.delegate = self;
    }
    return _recordEngine;
}

-(UIButton *)recordBt{
    if (!_recordBt) {
        _recordBt = [[UIButton alloc]initWithFrame:CGRectMake(sy_width/2-40, sy_height-90, 80, 80)];
        [_recordBt setImage:[UIImage imageNamed:@"videoRecord"] forState:UIControlStateNormal];
        [_recordBt addTarget:self action:@selector(recordAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _recordBt;
}

-(UIButton *)changeCameraBT{
    if (!_changeCameraBT) {
        _changeCameraBT = [[UIButton alloc]initWithFrame:CGRectMake(sy_width-100, sy_height-70, 50, 50)];
        [_changeCameraBT setImage:[UIImage imageNamed:@"changeCamera"] forState:UIControlStateNormal];
        [_changeCameraBT addTarget:self action:@selector(changeCameraAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeCameraBT;
}

#pragma mark -----  点击事件
-(void)recordAction:(UIButton *)sender {
    if (self.allowRecord) {
        self.recordBt.selected = !self.recordBt.selected;
        if (self.recordBt.selected) {
            //            NSLog(@"点击了录制");
            [self.recordBt setImage:[UIImage imageNamed:@"videoPause"] forState:UIControlStateNormal];
            [self.recordEngine startCapture];
        }else {
            
            [self.recordBt setImage:[UIImage imageNamed:@"videoRecord"] forState:UIControlStateNormal];
            [self.recordEngine stopCaptureHandler:nil];
            NSLog(@"⚠️录制完成");
            
        }
    }
}

//切换前后摄像头
- (void)changeCameraAction:(UIButton*)sender {
    self.changeCameraBT.selected = !self.changeCameraBT.selected;
    if (self.changeCameraBT.selected == YES) {
        //前置摄像头
        [self.recordEngine changeCameraInputDeviceisFront:YES];
    }else {
        [self.recordEngine changeCameraInputDeviceisFront:NO];
    }
}

#pragma mark - SY_AVFViewDelegate
- (void)recordProgress:(CGFloat)progress {
    if (progress >= 1) {
        [self recordAction:self.recordBt];
        self.allowRecord = NO;
    }
    self.progressView.progress = progress;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allowRecord = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_recordEngine == nil) {
        [self.recordEngine previewLayer].frame = self.view.bounds;
        [self.view.layer insertSublayer:[self.recordEngine previewLayer] atIndex:0];
    }
    [self.recordEngine startUp];
    [self.view addSubview:self.recordBt];
    [self.view addSubview:self.changeCameraBT];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.recordEngine shutdown];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    _recordEngine = nil;
}

@end
