//
//  AudioModel.m
//  AudioDemo
//
//  Created by wyl on 2017/9/12.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "AudioModel.h"

@implementation AudioModel

- (instancetype)initWithPacketData:(NSData*)data packetDescription:(AudioStreamPacketDescription)packetDes{
    
    self = [super init];
    
    if (self) {
        
        _data = data;
        _packetDes = packetDes;
        
    }
    
    return self;

}

@end
