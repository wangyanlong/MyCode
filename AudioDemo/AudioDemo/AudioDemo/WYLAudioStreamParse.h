//
//  WYLAudioStreamParse.h
//  AudioDemo
//
//  Created by wyl on 2017/9/11.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WYLAudioStreamParseDelegate <NSObject>

- (void)wylAudioStreamParseForPackets:(NSArray*)packetAry;

@end

@interface WYLAudioStreamParse : NSObject

@property (nonatomic, weak)id<WYLAudioStreamParseDelegate>delegate;

@end
