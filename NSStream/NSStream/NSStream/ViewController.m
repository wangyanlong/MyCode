//
//  ViewController.m
//  NSStream
//
//  Created by wyl on 2017/6/26.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSStreamDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self doTestInputStream];
}


- (void)doTestInputStream {
    
    NSString *path = @"/Users/apple/Desktop/stream.txt";
    
    NSInputStream *readStream = [[NSInputStream alloc]initWithFileAtPath:path];
    
    [readStream setDelegate:self];
    
    [readStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    [readStream open]; //调用open开始读文件
    
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    
    switch (eventCode) {
            
        case NSStreamEventHasBytesAvailable:{
            
            uint8_t buf[1024];
            
            NSInputStream *reads = (NSInputStream *)aStream;
            
            NSInteger blength = [reads read:buf maxLength:sizeof(buf)]; //把流的数据放入buffer
            
            NSData *data = [NSData dataWithBytes:(void *)buf length:blength];
            
            NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            NSLog(@"%@",string);
            
        }
            
            break;
            
            //错误和无事件处理
            
        case NSStreamEventErrorOccurred:{
            
        }
            
            break;
            
        case NSStreamEventNone:
            
            break;
            
            //打开完成
            
        case NSStreamEventOpenCompleted: {
            
            NSLog(@"NSStreamEventOpenCompleted");
            
        }
            
            break;
        case  NSStreamEventEndEncountered:{
            
            NSLog(@"NSStreamEventEndEncountered");
            
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
            aStream = nil;
            break;
            
        }
            
        default:
            
            break;
            
    }
    
}

@end
