//
//  WYLAudioStreamParse.h
//  AudioDemo
//
//  Created by wyl on 2017/9/11.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol WYLAudioStreamParseDelegate <NSObject>

- (void)wylAudioStreamParseForPackets:(NSArray*)packetAry;

@end

@interface WYLAudioStreamParse : NSObject{
    
    AudioFileStreamID _audioFileStreamID;//
    AudioFileTypeID _audioFileTypeID; // 文件类型
    BOOL _isContinue; //是否连续
    UInt32 _fileSize;
    
    UInt32 _audioDataOffset;
    UInt32 _biteRate;
    UInt32 _audioDataByteCount;
    
    BOOL isReadyProductPacket;
    float _duration;// 时间长度
    
}

@property (nonatomic, weak)id<WYLAudioStreamParseDelegate>delegate;
@property (nonatomic, assign) AudioStreamBasicDescription audioStreamBasicDescription;

/**
 初始化方法

 @param fileType 音频文件类型
 @param filesize 文件大小
 @return 返回实例
 */
- (instancetype)initWithFile:(AudioFileTypeID)fileType filezize:(UInt32)filesize;
- (BOOL)isReadyProductPacket;
- (BOOL)parserAudioStream:(NSData *)data;
- (void)handleAudioFileStream_PropertyListenerProc:(AudioFileStreamPropertyID)inPropertyID;
- (void)handleAudioFileStream_PacketsProc:(UInt32)inNumberBytes Packets:(UInt32)inNumberPackets PacketData:(NSData*)packetData PacketDescription:(AudioStreamPacketDescription*)inPacketDescriptions;

@end
