//
//  WYLAudioQueueRead.m
//  AudioDemo
//
//  Created by wyl on 2017/9/11.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "WYLAudioQueueRead.h"

static void WYLAudioQueueOutputCallback(
void * __nullable       inUserData,
AudioQueueRef           inAQ,
                                     AudioQueueBufferRef     inBuffer){

    WYLAudioQueueRead *queueRead = (__bridge WYLAudioQueueRead *)inUserData;
    
    [queueRead wylAudioQueueOutputCallback:inBuffer];
    
}

@implementation WYLAudioQueueRead

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _bufferQueue = [NSMutableArray array];
        _reuserBufferQueue = [NSMutableArray array];
        [self _mutexInit];

    }
    
    return self;
}

- (void)wylAudioQueueOutputCallback:(AudioQueueBufferRef)inBuffer{
    
    for (int i = 0; i < _bufferQueue.count; i++) {
        
        AudioQueueReadModel *model = _bufferQueue[i];
        
        if (model.buffer == inBuffer) {
            //重新利用
            [_reuserBufferQueue addObject:model];
            break;
        }
        
    }
    
    // 有新的可以利用了
    [self _mutexSignal];

}

- (BOOL)playerAudioQueue:(NSData*)audioData numPackets:(UInt32)numPackets packetDescription:(AudioStreamPacketDescription*)packetDescs{
    
    if (_reuserBufferQueue.count == 0) {
        [self _mutexWait];
    }
    
    AudioQueueReadModel *queueReadModel = [_reuserBufferQueue firstObject];
    
    [_reuserBufferQueue removeObject:queueReadModel];
    
    memcpy(queueReadModel.buffer->mAudioData, [audioData bytes], audioData.length);
    queueReadModel.buffer->mAudioDataByteSize = (UInt32)audioData.length;
    OSStatus status = AudioQueueEnqueueBuffer(_audioQueue, queueReadModel.buffer, numPackets, packetDescs);
    
    if (status != noErr) {
        NSLog(@"AudioQueueEnqueueBuffer error");
        return NO;
    }else{
        if (_reuserBufferQueue.count == 0)
        {
            if (!_started && ![self _start])
            {
                return NO;
            }
        }
    }
    return YES;
    
}

- (void)handleAudioPropertyStatus:(AudioQueuePropertyID)inID{
    
    
    if(inID == kAudioQueueProperty_IsRunning){
        
        UInt32 running = 0;
        UInt32 size = sizeof(running);
        AudioQueueGetProperty(_audioQueue, inID, &running, &size);
        NSLog(@"kAudioQueueProperty_IsRunning:%d", running);
        
    }
    
}

- (BOOL)_start{
    
    OSStatus status =  AudioQueueStart(_audioQueue, NULL);
    _started = status == noErr;
    return _started;
}

- (BOOL)createQueue:(AudioStreamBasicDescription)basicDescription bufferSize:(UInt32)buffeSize{
    
    _baiseDescription = basicDescription;
    
    OSStatus status = AudioQueueNewOutput(&basicDescription, WYLAudioQueueOutputCallback, (__bridge void*)self, NULL, NULL, 0, &_audioQueue);
    
    if (status != noErr) {
        NSLog(@"AudioQueueNewOutput error");
        _audioQueue = nil;
        return NO;
    }
    
    status = AudioQueueStart(_audioQueue, NULL);
    if (status != noErr) {
        AudioQueueDispose(_audioQueue, YES);
        _audioQueue = nil;
        return NO;
    }
    
    _bufferSize = buffeSize;
    
    if (_bufferQueue.count == 0) {
        
        for (int i = 0; i < EOCNumAQBufs; i++) {
            
            AudioQueueBufferRef buffer;
            status = AudioQueueAllocateBuffer(_audioQueue, buffeSize, &buffer);
            AudioQueueReadModel *model = [[AudioQueueReadModel alloc] init];
            model.buffer = buffer;
            
            [_bufferQueue addObject:model];
            [_reuserBufferQueue addObject:model];
            
        }
        
    }

    return YES;
}

- (void)_mutexInit{
    
    pthread_mutex_init(&_mutex, NULL);
    pthread_cond_init(&_cond, NULL);
    
}

- (void)_mutexDestory
{
    pthread_mutex_destroy(&_mutex);
    pthread_cond_destroy(&_cond);
}

- (void)_mutexWait{
    
    pthread_mutex_lock(&_mutex);
    NSLog(@"我在等待");
    pthread_cond_wait(&_cond, &_mutex);
    pthread_mutex_unlock(&_mutex);
    
}

- (void)_mutexSignal{
    
    pthread_mutex_lock(&_mutex);
    NSLog(@"不用等待了");
    pthread_cond_signal(&_cond);
    pthread_mutex_unlock(&_mutex);
    
}

@end
