//
//  MovieViewController.m
//  iOSLiveKitPushStreamTest
//
//  Created by sunkai on 16/10/26.
//  Copyright © 2016年 imo. All rights reserved.
//

#import "MovieViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MovieViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic, strong) AVCaptureAudioDataOutput *audioOutput;

@property (nonatomic, strong) dispatch_queue_t videoQueue;
@property (nonatomic, strong) dispatch_queue_t audioQueue;

@property (nonatomic, strong) AVCaptureConnection *videoConnection;
@property (nonatomic, strong) AVCaptureConnection *audioConnection;

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSession];
    [self showPlayer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.session startRunning];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.session stopRunning];
}

- (void)initSession {
    // 初始化 session
    _session = [[AVCaptureSession alloc] init];
    
    // 配置采集输入源（摄像头）
    NSError *error = nil;
    // 获得一个采集设备, 默认后置摄像头
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    // 用设备初始化一个采集的输入对象
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
    if (error) {
        NSLog(@"Error getting  input device: %@", error.description);
        return;
    }
    
    if ([_session canAddInput:videoInput]) {
        [_session addInput:videoInput]; // 添加到Session
    }
    if ([_session canAddInput:audioInput]) {
        [_session addInput:audioInput]; // 添加到Session
    }
    // 配置采集输出，即我们取得视频图像的接口
    _videoQueue = dispatch_queue_create("Video Capture Queue", DISPATCH_QUEUE_SERIAL);
    _audioQueue = dispatch_queue_create("Audio Capture Queue", DISPATCH_QUEUE_SERIAL);
    
    _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    _audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    
    //必须是串行队列
    [_videoOutput setSampleBufferDelegate:self queue:_videoQueue];
    [_audioOutput setSampleBufferDelegate:self queue:_audioQueue];
    
    // 配置输出视频图像格式
    NSDictionary *captureSettings = @{(NSString*)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_32BGRA)};
    _videoOutput.videoSettings = captureSettings;
    _videoOutput.alwaysDiscardsLateVideoFrames = YES;
    if ([_session canAddOutput:_videoOutput]) {
        [_session addOutput:_videoOutput];  // 添加到Session
    }
    
    if ([_session canAddOutput:_audioOutput]) {
        [_session addOutput:_audioOutput]; // 添加到Session
    }
    // 保存Connection，用于在SampleBufferDelegate中判断数据来源（Video/Audio）
    _videoConnection = [_videoOutput connectionWithMediaType:AVMediaTypeVideo];
    _audioConnection = [_audioOutput connectionWithMediaType:AVMediaTypeAudio];
    
}

- (void)showPlayer {
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill; // 设置预览时的视频缩放方式
    [[_previewLayer connection] setVideoOrientation:AVCaptureVideoOrientationPortrait]; // 设置视频的朝向
    _previewLayer.frame = self.view.layer.bounds;
    [self.view.layer addSublayer:_previewLayer];
}

#pragma mark 获取 AVCapture Delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    // 这里的sampleBuffer就是采集到的数据了,根据connection来判断，是Video还是Audio的数据
    if (connection == self.videoConnection) {  // Video
        NSLog(@"这里获的 video sampleBuffer，做进一步处理（编码H.264）");
    } else if (connection == self.audioConnection) {  // Audio
        NSLog(@"这里获得 audio sampleBuffer，做进一步处理（编码AAC）");
    }
}

@end