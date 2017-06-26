//
//  ViewController2.m
//  NSURLSession
//
//  Created by wyl on 2017/6/26.
//  Copyright © 2017年 wyl. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()<NSURLSessionDelegate>

@property (nonatomic, strong) NSString  *urlImage;
@property (nonatomic, strong) NSString *fileName; // 过渡文件名（URL）
@property (nonatomic, strong) NSOutputStream *outputStream;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"%@", docPath);
    
    self.urlImage = @"http://img5.niutuku.com/phone/1301/5119/5119-niutuku.com-463190.jpg";
    
    [self loadImage];

}

- (void)loadImage{
    
    self.fileName = @"test.jpg";
    
    NSURL *url = [NSURL URLWithString:self.urlImage];
    
    //请求体
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"GET"];
    
    long dataPreLength = [self backFileLength:self.fileName];
    //起始长度-结束长度 如果结束长度没有,那么则表明没有下载长度的限制
    [request setValue:[NSString stringWithFormat:@"bytes=%ld-",dataPreLength] forHTTPHeaderField:@"Range"];
    
    BOOL isNeedBreakOperation = YES;
    if(isNeedBreakOperation){
        self.outputStream = [[NSOutputStream alloc] initToFileAtPath:[self filePathInTemp:self.fileName] append:YES];
    }else{
        self.outputStream = [[NSOutputStream alloc] initToFileAtPath:[self filePathInTemp:self.fileName] append:NO];
    }
    [self.outputStream open];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request];
    [task resume];
}

- (long)backFileLength:(NSString *)fileName{
    
    NSDictionary *fileDict = [[NSFileManager defaultManager] attributesOfItemAtPath:[self filePathInTemp:fileName] error:nil];
    
    long fileLength = (long)[[fileDict objectForKey:NSFileSize] unsignedLongLongValue];
    
    return fileLength;
    
}

- (NSString *)filePathInTemp:(NSString *)fileName{
    
    return [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    
}

- (NSString *)filePathInDocument:(NSString *)fileName{
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return  [docPath stringByAppendingPathComponent:fileName];
    
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    
    [self.outputStream write:[data bytes] maxLength:data.length];
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
    // 转移
    
    [[NSFileManager defaultManager] moveItemAtPath:[self filePathInTemp:self.fileName] toPath:[self filePathInDocument:self.fileName] error:nil];
    NSLog(@"%@", error);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
