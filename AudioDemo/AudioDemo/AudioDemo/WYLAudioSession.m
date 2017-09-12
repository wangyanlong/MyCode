//
//  WYLAudioSession.m
//  AudioDemo
//
//  Created by wyl on 2017/9/11.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "WYLAudioSession.h"

@implementation WYLAudioSession

-(BOOL)wylAVAudioSessionAction:(BOOL)active{
    
    AVAudioSession *avAudioSession = [AVAudioSession sharedInstance];
    
    NSError *error = nil;
    
    //静音状态下播放
    [avAudioSession setActive:active error:&error];
    if (error) {
        NSLog(@"AVAudioSession setActive fail:%@",error);
        return NO;
    }
    
    return YES;
    
}

- (BOOL)configAVAudioSessionCategory:(NSString *)category{
    
    AVAudioSession *avAudioSession = [AVAudioSession sharedInstance];
    
    NSError *error = nil;
    
    //后台播放
    [avAudioSession setCategory:category error:&error];
    
    if (error) {
        NSLog(@"AVAudioSession setCategory fail:%@", error);
        return NO;
    }
    
    return YES;
    
}

@end
