//
//  WYLAudioStreamParse.m
//  AudioDemo
//
//  Created by wyl on 2017/9/11.
//  Copyright © 2017年 wyl. All rights reserved.
//
#import "AudioModel.h"
#import "WYLAudioStreamParse.h"

static void WYLAudioFileStream_PacketsProc(
void *							inClientData,
UInt32							inNumberBytes,
UInt32							inNumberPackets,
const void *					inInputData,
                                           AudioStreamPacketDescription	*inPacketDescriptions){
    
    WYLAudioStreamParse *wylAudioStreamParse = (__bridge WYLAudioStreamParse *)inClientData;

    NSData *data = [NSData dataWithBytes:inInputData length:inNumberBytes];
    
    [wylAudioStreamParse handleAudioFileStream_PacketsProc:inNumberBytes Packets:inNumberPackets PacketData:data PacketDescription:inPacketDescriptions];
    
}

static void WYLAudioFileStream_PropertyListenerProc(void *							inClientData,
                                                    AudioFileStreamID				inAudioFileStream,
                                                    AudioFileStreamPropertyID		inPropertyID,
                                                    AudioFileStreamPropertyFlags *	ioFlags){

    WYLAudioStreamParse *wylAudioStreamParse = (__bridge WYLAudioStreamParse *)inClientData;
    
    [wylAudioStreamParse handleAudioFileStream_PropertyListenerProc:inPropertyID];
    
}



@implementation WYLAudioStreamParse

- (instancetype)initWithFile:(AudioFileTypeID)fileType filezize:(UInt32)filesize{
    
    if (self = [super init]) {
        
        _audioFileTypeID = fileType;
        _fileSize = filesize;
        _isContinue = YES;
        
        [self createAudioSessionStream];
        
    }
    
    return self;
    
}

- (BOOL)parserAudioStream:(NSData *)data{
    
    OSStatus status = AudioFileStreamParseBytes(_audioFileStreamID, (UInt32)data.length, [data bytes], _isContinue?0:kAudioFileStreamParseFlag_Discontinuity);
    
    if (status != noErr) {
        return NO;
    }
    
    return YES;
    
}

- (BOOL)isReadyProductPacket{
    
    return isReadyProductPacket;
    
}

- (BOOL)createAudioSessionStream{
    
    AudioFileStreamOpen((__bridge void*)self, WYLAudioFileStream_PropertyListenerProc, WYLAudioFileStream_PacketsProc, _audioFileTypeID, &_audioFileStreamID);
    
    return YES;
    
}


/**
 音频帧的处理
 */
- (void)handleAudioFileStream_PacketsProc:(UInt32)inNumberBytes Packets:(UInt32)inNumberPackets PacketData:(NSData*)packetData PacketDescription:(AudioStreamPacketDescription*)inPacketDescriptions{

    if (inNumberBytes == 0 || inNumberPackets == 0){
        return;
    }
    
    if (!_isContinue) {
        _isContinue = YES;
    }
    
    if (inPacketDescriptions == NULL) {
        
        NSLog(@"inPacketDescriptions 是空");
        AudioStreamPacketDescription *des = malloc(sizeof(AudioStreamPacketDescription)*inNumberBytes);
        
        UInt32 packSize = inNumberBytes/inNumberPackets;
        for (int i = 0; i < inNumberPackets; i++) {
            
            UInt32 packeOffset = packSize * i;
            AudioStreamPacketDescription packetDes = inPacketDescriptions[i];
            packetDes.mStartOffset = packeOffset;
            packetDes.mVariableFramesInPacket = 0;
            
            if (i == inNumberPackets - 1) {
                packetDes.mDataByteSize = inNumberBytes - packeOffset;
            }else{
                packetDes.mDataByteSize = packSize;
            }
            
        }
        
        inPacketDescriptions = des;
        
    }
    
    NSMutableArray *packetAry = [NSMutableArray array];
    
    for (int i = 0; i < inNumberPackets; i++) {
        
        AudioStreamPacketDescription packetDes = inPacketDescriptions[i];
        
        SInt64 startOffset = packetDes.mStartOffset;
        SInt64 dataSize = packetDes.mDataByteSize;
        
        NSData *data = [packetData subdataWithRange:NSMakeRange(startOffset, dataSize)];
        
        AudioModel *model = [[AudioModel alloc] initWithPacketData:data packetDescription:packetDes];
        [packetAry addObject:model];
        
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wylAudioStreamParseForPackets:)]) {
        
        [self.delegate wylAudioStreamParseForPackets:packetAry];
        
    }
    
}


/**
 文件处理
 */
- (void)handleAudioFileStream_PropertyListenerProc:(AudioFileStreamPropertyID)inPropertyID{

    if (inPropertyID == kAudioFileStreamProperty_DataOffset){
        
        UInt32 size = sizeof(_audioDataOffset);
        AudioFileStreamGetProperty(_audioFileStreamID, inPropertyID, &size, &_audioDataOffset);
        
    }
    
    if (inPropertyID == kAudioFileStreamProperty_BitRate) {
        
        UInt32 size = sizeof(_biteRate);
        AudioFileStreamGetProperty(_audioFileStreamID, inPropertyID, &size, &_biteRate);
        
    }
    
    if (inPropertyID == kAudioFileStreamProperty_AudioDataByteCount) {
        
        UInt32 size = sizeof(_audioDataByteCount);
        AudioFileStreamGetProperty(_audioFileStreamID, inPropertyID, &size, &_audioDataByteCount);
        
    }
    
    if (inPropertyID == kAudioFileStreamProperty_DataFormat) {
        
        UInt32 size = sizeof(_audioStreamBasicDescription);
        AudioFileStreamGetProperty(_audioFileStreamID, inPropertyID, &size, &_audioStreamBasicDescription);
    }
    
    if (inPropertyID == kAudioFileStreamProperty_ReadyToProducePackets) {
        // 文件属性解析完了
        isReadyProductPacket = YES;
        _isContinue = NO;
        
        [self calcultateDuration];
    }
    
}

- (void)calcultateDuration{
    
    if (_biteRate > 0 && _fileSize > 0) {
        _duration = (_fileSize-_audioDataOffset)*8.0/_biteRate;
    }
}

@end
