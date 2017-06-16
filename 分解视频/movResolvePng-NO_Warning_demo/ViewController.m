//
//  ViewController.m
//  movResolvePng-NO_Warning_demo
//
//  Created by 王颜龙 on 13-12-16.
//  Copyright (c) 2013年 longyan. All rights reserved.
//

#import "UniversalMethod.h"
#import "MBProgressHUD.h"
#import "ViewController.h"

@interface ViewController ()
{

    CGRect imageRect;
    __block dispatch_queue_t writeQueue;

}

@property(nonatomic, strong)NSString*                               videoPath;
@property (nonatomic,strong)NSURL *url;
@property(nonatomic, strong)AVAssetWriter*                          videoWriter;
@property(nonatomic, strong)AVAssetWriterInput*                     writerInput;
@property(nonatomic, strong)AVAssetWriterInputPixelBufferAdaptor*   adaptor;
@property(nonatomic, assign)BOOL                                    firstImgAdded;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(50, 50, 100, 100);
    [button setTitle:@"分解视频" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(resolve) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame = CGRectMake(50, 150, 100, 100);
    [button2 setTitle:@"播放原视频" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button3.frame = CGRectMake(50, 250, 100, 100);
    [button3 setTitle:@"播放新视频" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(playNew) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];

    
    NSString *str = [[NSBundle mainBundle]pathForResource:@"no" ofType:@"MOV"];
    self.url = [NSURL fileURLWithPath:str];

}

- (void)playNew{
    [self initRecord];
    [self startCamera];
}

- (void)play{
    MPMoviePlayerViewController *vc = [[MPMoviePlayerViewController alloc]initWithContentURL:self.url];
    [self presentViewController:vc animated:YES completion:NULL];

}

- (void)resolve{
    [self resolveMovWithUrl:self.url];
}


#pragma mark - 分解和合成的方法

//分解视频
- (void)resolveMovWithUrl:(NSURL *)movUrl{
    
    //得到url的资源,转为asset
    AVAsset *myAsset = [[AVURLAsset alloc] initWithURL:movUrl options:nil];
    NSParameterAssert(myAsset);
    
    //初始化AVAssetImageGenerator
    self.imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:myAsset] ;
    self.imageGenerator.appliesPreferredTrackTransform = YES;//加这句话,取出的是正确方向的图片
    self.imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    self.imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    
    //得到秒数
    Float64 _durationSeconds = CMTimeGetSeconds([myAsset duration]);
    
    __block float Second = 0.0;
    __block int num = 0;
    
    NSString *path = [self backPath];
    NSLog(@"%@",path);
    
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        });
        
        while ((_durationSeconds - Second)>0) {

            NSLog(@"%f",_durationSeconds - Second);
            CMTime rTime = CMTimeMakeWithSeconds(Second, NSEC_PER_SEC);
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                @autoreleasepool
                {
                    //根据帧数取出图片
                    CGImageRef image= [self.imageGenerator copyCGImageAtTime:rTime actualTime:NULL error:NULL];
                    if (image)
                    {
                        UIImage *img = [[UIImage alloc] initWithCGImage:image];
                        NSData *imageData = UIImagePNGRepresentation(img);
                        
                        
                        NSString *pathNum = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.png",num]];
                        [imageData writeToFile:pathNum atomically:NO];
                        
                        
                        CGImageRelease(image);
                        
                        NSString *actualTimeString =CFBridgingRelease(CMTimeCopyDescription(NULL, rTime));
                        NSLog(@"photo:%d",num);
                        NSLog(@"%@",actualTimeString);
                        
                        //调用dispatch_semaphore_signal函数，使计数器+1
                        dispatch_semaphore_signal(sem);
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            
                        });
                    }
                    
                }
            });
            Second +=0.083;
            //一直等待，直到信号量计数器大于等于1
            dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
            num+=1;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            num = 0;
            Second = 0.0;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
    });

}


//分解视频
- (void)resolveMovWithUrl2:(NSURL *)movUrl{
    
    //得到url的资源,转为asset
    AVAsset *myAsset = [[AVURLAsset alloc] initWithURL:movUrl options:nil];
    NSParameterAssert(myAsset);
    
    //初始化AVAssetImageGenerator
    self.imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:myAsset] ;
    self.imageGenerator.appliesPreferredTrackTransform = YES;//加这句话,取出的是正确方向的图片
    self.imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    self.imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    
    //得到秒数
    Float64 _durationSeconds = CMTimeGetSeconds([myAsset duration]);
    
    __block float Second = 0.0;
    __block int num = 0;
    
    NSString *path = [self backPath];
    NSLog(@"%@",path);
    
    NSMutableArray *CMTimeArr = [[NSMutableArray alloc]initWithCapacity:0];
    
    float time = 0;
    
    while (_durationSeconds - time) {
//        CMTime timeFile =
    }
}

//返回保存图片的路径
-(NSString *)backPath{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *path = [UniversalMethod backDocumentDirectoryPath];
    
    NSString *imageDirectory = [path stringByAppendingPathComponent:@"Normal"];
    
    [fileManager createDirectoryAtPath:imageDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    return imageDirectory;
}

- (NSString*)getLibarayPath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
														 NSUserDomainMask, YES);
	NSString* path = [paths objectAtIndex:0];
	return path;
}

- (void)initRecord
{
    //是否是第一次添加图片
    self.firstImgAdded = FALSE;
    
    //video路径
    NSString* fileName = [NSString stringWithFormat:@"%d.mov", (int)[[NSDate date] timeIntervalSince1970]];
    self.videoPath = [NSString stringWithFormat:@"%@/%@", [self getLibarayPath], fileName];
    NSLog(@"输出== %@",self.videoPath);
    //设置一个gcd队列
    writeQueue = dispatch_queue_create("recording_queue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    
    //设置图片大小
    imageRect = CGRectMake(0, 0, 1280, 1280);
    
    CGSize frameSize = imageRect.size;
    
    NSError* error = nil;
    
    //创建写入对象
    self.videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:self.videoPath] fileType:AVFileTypeQuickTimeMovie error:&error];
    
    //如果出错,打印错误内容
    if(error)
    {
        NSLog(@"error creating AssetWriter: %@",[error description]);
        self.videoWriter = nil;
        return;
    }
    
    //设置参数
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:frameSize.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:frameSize.height], AVVideoHeightKey,
                                   nil];
    
    //输入对象
    self.writerInput = [AVAssetWriterInput
                        assetWriterInputWithMediaType:AVMediaTypeVideo
                        outputSettings:videoSettings];
    
    //属性设置
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:[NSNumber numberWithUnsignedInt:kCVPixelFormatType_32ARGB] forKey:(NSString*)kCVPixelBufferPixelFormatTypeKey];
    [attributes setObject:[NSNumber numberWithUnsignedInt:frameSize.width] forKey:(NSString*)kCVPixelBufferWidthKey];
    [attributes setObject:[NSNumber numberWithUnsignedInt:frameSize.height] forKey:(NSString*)kCVPixelBufferHeightKey];
    
    //通过属性和writerInput 创建一个新的Adaptor
    self.adaptor = [AVAssetWriterInputPixelBufferAdaptor
                    assetWriterInputPixelBufferAdaptorWithAssetWriterInput:self.writerInput
                    sourcePixelBufferAttributes:attributes];
    
    //添加输入,必须在开始写入之前
    [self.videoWriter addInput:self.writerInput];
    
    self.writerInput.expectsMediaDataInRealTime = YES;
    
    //开始写入
    [self.videoWriter startWriting];
    [self.videoWriter startSessionAtSourceTime:kCMTimeZero];
}

#pragma mark - 视频合成
static int count = 0;
- (void)startCamera
{
    
    NSMutableArray *arr = [self allFilesAtPath:[self backPath]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        });
        
        while (arr.count -count) {
            UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%d.png",[self backPath],count]];
            CGImageRef image1 = image.CGImage;
            [self writeImage:image1 withIndex:count];
            NSLog(@"%d",count);
            count ++;
        }

        
        [self.writerInput markAsFinished];
        [self.videoWriter finishWriting];
        
//        [self combineWithAudio:num];
        dispatch_async(dispatch_get_main_queue(), ^{
            count = 0;
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        });
        
    });
}

- (void)writeImage:(CGImageRef)img withIndex:(NSInteger)curCount
{
    CVPixelBufferRef buffer = NULL;
    if (self.videoWriter == nil)
    {
        NSLog(@"error~~~~~~~~~~~");
    }
    if (self.firstImgAdded == FALSE)
    {
        buffer = [self pixelBufferFromCGImage:img];
        BOOL result = [self.adaptor appendPixelBuffer:buffer withPresentationTime:kCMTimeZero];
        if (result == NO) //failes on 3GS, but works on iphone 4
        {
            NSLog(@"failed to append buffer");
        }
        if(buffer)
        {
            CVBufferRelease(buffer);
        }
        self.firstImgAdded = TRUE;
    }
    else
    {
        if (self.adaptor.assetWriterInput.readyForMoreMediaData)
        {
            CMTime frameTime = CMTimeMake(1, FramePerSec);
            CMTime lastTime = CMTimeMake(curCount, FramePerSec);
            CMTime presentTime = CMTimeAdd(lastTime, frameTime);
            
            buffer = [self pixelBufferFromCGImage:img];
            BOOL result = [self.adaptor appendPixelBuffer:buffer withPresentationTime:presentTime];
            
            if (result == NO) //failes on 3GS, but works on iphone 4
            {
                NSLog(@"failed to append buffer");
                NSLog(@"The error is %@", [self.videoWriter error]);
            }
            else
            {
                NSLog(@"write ok");
            }
            if(buffer)
            {
                CVBufferRelease(buffer);
            }
        }
        else
        {
            NSLog(@"error");
        }
    }
    
}

- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:TRUE], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:TRUE],kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];//是否兼容
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, imageRect.size.width,
                                          imageRect.size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options,
                                          &pxbuffer);//返回kCVReturnSuccess kCFAllocatorDefault = nil
    status=status;
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);//判断类型
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);//访问地址
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, imageRect.size.width,
                                                 imageRect.size.height, 8, 4*imageRect.size.width, rgbColorSpace,
                                                 kCGImageAlphaNoneSkipFirst);
    NSParameterAssert(context);
    
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    
    CGContextDrawImage(context, CGRectMake(0, 0, imageRect.size.width, imageRect.size.height), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

- (NSMutableArray*) allFilesAtPath:(NSString*) dirString {
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:10];
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:dirString error:nil];
    for (NSString* fileName in tempArray) {
        BOOL flag = YES;
        NSString* fullPath = [dirString stringByAppendingPathComponent:fileName];
        if ([fileMgr fileExistsAtPath:fullPath isDirectory:&flag]) {
            if (!flag) {
                [array addObject:fullPath];
            }
        }
    }
    return array;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
