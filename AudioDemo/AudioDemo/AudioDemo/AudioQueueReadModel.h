//
//  AudioQueueReadModel.h
//  AudioDemo
//
//  Created by wyl on 2017/9/12.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

@interface AudioQueueReadModel : NSObject

@property (nonatomic, assign)AudioQueueBufferRef buffer;

@end
