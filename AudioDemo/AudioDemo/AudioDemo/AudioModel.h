//
//  AudioModel.h
//  AudioDemo
//
//  Created by wyl on 2017/9/12.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioModel : NSObject

- (instancetype)initWithPacketData:(NSData*)data packetDescription:(AudioStreamPacketDescription)packetDes;

@property (nonatomic, strong)NSData *data;
@property (nonatomic, assign)AudioStreamPacketDescription packetDes;

@end
