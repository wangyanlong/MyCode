//
//  ViewController.m
//  AudioDemo
//
//  Created by wyl on 2017/9/8.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "ViewController.h"
#import "WYLAudioSession.h"
#import "WYLAudioStreamParse.h"
#import "WYLAudioStreamPacketBuffersPool.h"
#import "WYLAudioQueueRead.h"

@interface ViewController ()<WYLAudioStreamParseDelegate>{
    NSInteger _fileSize;
    NSInteger _fileOffset;
    NSInteger _bufferSize;
}

@property (nonatomic, strong)NSFileHandle *fileHandle;
@property (nonatomic, strong)NSThread *audioThread;

@property (nonatomic, strong)WYLAudioSession *wylAudioSession;//音频会话
@property (nonatomic, strong)WYLAudioStreamParse *wylAudioStreamParse;//音频解析
@property (nonatomic, strong)WYLAudioStreamPacketBuffersPool *wylBuffersPool;//音频缓冲池
@property (nonatomic, strong)WYLAudioQueueRead *wylAudioQueueRead;//音频读取

@property (nonatomic, assign) BOOL  playing;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MP3Sample" ofType:@"mp3"];
    _fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
    _fileOffset = 0;
    _bufferSize = _fileSize/500.0f;
    
    self.audioThread = [[NSThread alloc] initWithTarget:self selector:@selector(audioThreadMethod) object:nil];
    
    self.wylAudioSession = [[WYLAudioSession alloc] init];
    self.wylAudioStreamParse = [[WYLAudioStreamParse alloc] init];
    self.wylAudioStreamParse.delegate = self;
    self.wylBuffersPool = [[WYLAudioStreamPacketBuffersPool alloc] init];
    self.wylAudioQueueRead = [[WYLAudioQueueRead alloc] init];
    
}

- (void)audioThreadMethod{
    
    //建立会话
    BOOL isSuccess = [self.wylAudioSession wylAVAudioSessionAction:YES];
    
    if (!isSuccess) {
        return;
    }
    
    isSuccess = [self.wylAudioSession configAVAudioSessionCategory:AVAudioSessionCategoryAmbient];
    if (!isSuccess) {
        return;
    }
    
    BOOL isEOF = NO;
    
    while (_fileSize > 0) {
    
        // 2 读音频文件 500字节
        NSData *data = nil;
        if (!isEOF) {
            
            data = [_fileHandle readDataOfLength:500];
            
            _fileOffset += data.length;
            
            if (_fileOffset >= _fileSize) {
                isEOF = YES;
                NSLog(@"finish EOF");
            }
            
        }
        
        if (_playing && data) {
        
            // 3. 解析
            isSuccess = [self.wylAudioStreamParse parserAudioStream:data];
            if (!isSuccess) {
                NSLog(@"解析数据出问题了");
                break;
            }
            
        }
        
    }

}

- (void)wylAudioStreamParseForPackets:(NSArray *)packetAry{
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
