//
//  WYLAudioStreamPacketBuffersPool.h
//  AudioDemo
//
//  Created by wyl on 2017/9/11.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioModel.h"
#import <AVFoundation/AVFoundation.h>

@interface WYLAudioStreamPacketBuffersPool : NSObject{
    
    NSMutableArray *_packetBufferAry;
    
    NSLock *_opLock;
    
    
}

@property (nonatomic, assign)UInt32 bufferSize;

- (void)enqueuePoolStreamPacketsAry:(NSArray*)packets;

- (NSData*)dequeuePoolStreamPacketDataSize:(UInt32)dataSize packetCount:(UInt32*)packetCount audioStreamPacketDescription:(AudioStreamPacketDescription**)packetDescription;


@end
