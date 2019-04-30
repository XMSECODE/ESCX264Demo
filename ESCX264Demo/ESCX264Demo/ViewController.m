//
//  ViewController.m
//  ESCX264Demo
//
//  Created by xiang on 2019/4/25.
//  Copyright © 2019 xiang. All rights reserved.
//

#import "ViewController.h"
#import "ESCYUVToH264Encoder.h"

@interface ViewController () <ESCYUVToH264EncoderDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self encodeYUVFile];
    
    [self encodeYUVDataStream];
}

- (void)encodeYUVFile {
    NSString *yuvPath = [[NSBundle mainBundle] pathForResource:@"tem960_540.yuv" ofType:nil];
    NSString *h264Path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    h264Path = [NSString stringWithFormat:@"%@/tem960_540.h264",h264Path];
    [ESCYUVToH264Encoder yuvToH264EncoderWithVideoWidth:960 height:540 yuvFilePath:yuvPath h264FilePath:h264Path frameRate:5];
}

- (void)encodeYUVDataStream {
    NSString *yuvPath = [[NSBundle mainBundle] pathForResource:@"tem960_540.yuv" ofType:nil];
    NSString *h264Path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    h264Path = [NSString stringWithFormat:@"%@/tem960_540.h264",h264Path];
    
    NSData *yuvData = [NSData dataWithContentsOfFile:yuvPath];
    
    ESCYUVToH264Encoder *encoder = [[ESCYUVToH264Encoder alloc] init];
    [encoder setupVideoWidth:960 height:540 frameRate:5 delegate:self];
//    encoder.spsAndPpsIsIncludedInIframe = NO;
    int oneFrameYUVDataLength = 960 * 540 * 3 / 2;
    
    
    for (int i = 0; i < yuvData.length; i = i + oneFrameYUVDataLength) {
        NSData *oneYUVData = [yuvData subdataWithRange:NSMakeRange(i, oneFrameYUVDataLength)];
        [encoder encoderYUVData:oneYUVData];
    }
    
    [encoder endYUVDataStream];
}
#pragma mark - ESCYUVToH264EncoderDelegate
- (void)encoder:(ESCYUVToH264Encoder *)encoder h264Data:(void *)h264Data dataLenth:(NSInteger)lenth {
//    NSData *data = [NSData dataWithBytes:h264Data length:lenth > 100 ? 100 :lenth];
//    NSLog(@"编码数据：%@",data);
}

- (void)encoderEnd:(ESCYUVToH264Encoder *)encoder {
    NSLog(@"编码完成");
}

@end
