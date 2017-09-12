//
//  WYLAudioSession.h
//  AudioDemo
//
//  Created by wyl on 2017/9/11.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface WYLAudioSession : NSObject

- (BOOL)wylAVAudioSessionAction:(BOOL)active;
- (BOOL)configAVAudioSessionCategory:(NSString *)category;

@end
