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
    _fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];

    _fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
    _fileOffset = 0;
    _bufferSize = _fileSize/500.0f;
    
    self.audioThread = [[NSThread alloc] initWithTarget:self selector:@selector(audioThreadMethod) object:nil];
    
    self.wylAudioSession = [[WYLAudioSession alloc] init];
    self.wylAudioStreamParse = [[WYLAudioStreamParse alloc] initWithFile:kAudioFileMP3Type filezize:(UInt32)_fileSize];
    self.wylAudioStreamParse.delegate = self;
    self.wylBuffersPool = [[WYLAudioStreamPacketBuffersPool alloc] init];
    self.wylAudioQueueRead = [[WYLAudioQueueRead alloc] init];
    
    _playing = YES;
    [self.audioThread start];
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
            
            // 5 读数据（从缓冲区里读）
            // 5.1 需要判断是否已经解析完文件头
            if ([self.wylAudioStreamParse isReadyProductPacket]) {
                
                //5.2 读音频数据
                if (!self.wylAudioQueueRead.audioQueue){
                    isSuccess = [self.wylAudioQueueRead createQueue:self.wylAudioStreamParse.audioStreamBasicDescription bufferSize:(UInt32)_bufferSize];
                    
                    if (!isSuccess) {
                        NSLog(@"createQueue出问题了");
                        break;
                    }
                    
                }
                
                // 从缓冲区里读
                if (self.wylBuffersPool.bufferSize < _bufferSize) {
                    // pool数据不够，那么继续解析文件数据
                    continue;
                }
                
                UInt32 packetCount = 0;
                AudioStreamPacketDescription *packetDescription;
                
                NSData *streamData = [self.wylBuffersPool dequeuePoolStreamPacketDataSize:(UInt32)_bufferSize packetCount:&packetCount audioStreamPacketDescription:&packetDescription];
                
                if (streamData) {
                    isSuccess = [self.wylAudioQueueRead playerAudioQueue:streamData numPackets:packetCount packetDescription:packetDescription];
                    if (!isSuccess) {
                        NSLog(@"playerAudioQueue fail");
                        break;
                    }
                    
                }else {
                    
                    NSLog(@"dequeuePoolStream fail");
                    break;
                    
                }
                
            }
            
        }
        
    }

}

// 4 数据缓存区
- (void)wylAudioStreamParseForPackets:(NSArray *)packetAry{
    
    [self.wylBuffersPool enqueuePoolStreamPacketsAry:packetAry];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
