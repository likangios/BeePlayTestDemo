//
//  XYSocketServer.m
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/14.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "XYSocketServer.h"

@implementation XYSocketServer
- (instancetype)initWithPort:(int)port{
    self =[super init];
    if (self) {
        self.port = port;
    }
    return self;
}
- (void)start{
    NSString *url = [NSString stringWithFormat:@"http://127.0.0.1:%d/%@",self.port,@"xyping"];
    [[DTDSNetworkManager noBaseUrlShareInstance] requestGET:url parameters:nil success:^(id responseObject) {
        if (self.listenSocket.isDisconnected) {
            NSLog(@"服务启动失败，端口被占用");
        }
    } failure:^(NSError *error) {
        NSLog(@"服务启动失败，请重启应用");
    }];
}
- (void)stop{
    [self.listenSocket disconnect];
    
}
-(BOOL)onStartWithError:(NSError *)error{
    self.connectedSockets = [NSMutableArray arrayWithCapacity:1];
    _socketQueue =  dispatch_queue_create("socketQueue", 0);
   self.listenSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_socketQueue];
    NSError *err;
    
    if ( [self.listenSocket acceptOnPort:self.port error:&err]) {
        [self commandTaskstart];
        return YES;
    }
    else{
        return NO;
    }
}
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    [self.connectedSockets addObject:sock];
    NSString * connectedHost = [sock connectedHost];
    if ([connectedHost isEqualToString:@"127.0.0.1"]) {
        [sock readDataWithTimeout:0 tag:-1];
    }
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    [sock readDataWithTimeout:0 tag:tag];
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0) {
        [self afteriOS11Socket:sock didReadData:data withTag:tag];
    }
    else{
        [self beforiOS11Socket:sock didReadData:data withTag:tag];
    }
}
- (void)afteriOS11Socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
}
- (void)beforiOS11Socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    if (self.listenSocket != sock) {
        [self.connectedSockets removeObject:sock];
    }
}
- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length{
    return 0.0;
}
- (void)image:(id)arg1 didFinishSavingWithError:(NSError *)error contextInfo:(void *)arg3{
    
}
- (void)responseDictionary:(NSDictionary *)dic ToSocket:(GCDAsyncSocket *)sock{
    NSString *jsonstring =  [self dictionaryToJson:dic];
    [self response:jsonstring ToSocket:sock];
}
- (void)response:(NSString *)reponse ToSocket:(GCDAsyncSocket *)sock{
    
    if (self.callback) {
        reponse = [NSString stringWithFormat:@"%@(%@)",self.callback,reponse];
    }
    [self response:reponse WithContentType:@"text/plain" ToSocket:sock];
}
- (void)response:(NSString *)reponse WithContentType:(NSString *)type ToSocket:(GCDAsyncSocket *)sock{
    NSData *fileData = [reponse dataUsingEncoding:NSUnicodeStringEncoding];
    CFHTTPMessageRef response =
    CFHTTPMessageCreateResponse(
                                kCFAllocatorDefault, 200, NULL, kCFHTTPVersion1_1);
    CFHTTPMessageSetHeaderFieldValue(
                                     response, (CFStringRef)@"Content-Type", (CFStringRef)@"text/plain");
    CFHTTPMessageSetHeaderFieldValue(
                                     response, (CFStringRef)@"Connection", (CFStringRef)@"close");
    CFHTTPMessageSetHeaderFieldValue(
                                     response,
                                     (CFStringRef)@"Content-Length",
                                     (__bridge CFStringRef)[NSString stringWithFormat:@"%ld", [fileData length]]);
    NSData *headerData = (__bridge NSData *)CFHTTPMessageCopySerializedMessage(response);
    
    [sock writeData:headerData withTimeout:0 tag:-1];
    [sock writeData:fileData withTimeout:0 tag:-1];
}
- (void)commandTaskstart{
    [self.timer invalidate];
    TaskBean *bean = [NSUserDefaults standardUserDefaults].currentTask;
    if (bean) {
        NSDate *date = [NSDate date];
        if (date.timeIntervalSince1970 < bean.expiredAt.longLongValue) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:25.0 target:self selector:@selector(detectTask:) userInfo:nil repeats:YES];
        }
    }
}
- (void)detectTask:(NSTimer *)timer{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0) {
        [self detectTaskAfteriOS11:timer];
    }
    else{
        [self detectTaskBeforeiOS11:timer];
    }
}
- (void)detectTaskAfteriOS11:(NSTimer *)arg1{
    
}
- (void)detectTaskBeforeiOS11:(NSTimer *)arg1{
    TaskBean *task =  [NSUserDefaults standardUserDefaults].currentTask;
    if (!arg1 || task) {
        
        if ([NSDate date].timeIntervalSince1970 >= task.expiredAt.longLongValue) {
            [NSUserDefaults standardUserDefaults].currentTask = nil;
            return;
        }
        LSAP_model *lsap_model =  [[LSAP_model alloc]initWithId:task.bundleId];
        LSAW_model *lsaw_model= [[LSAW_model alloc]init];
        if (lsap_model.isNowInstalling || lsap_model.isNowInstalled) {
            if (![task.isFirst isEqualToString:@"1"]) {
                [lsaw_model appsDataAppend:task.bundleId];
                [self cancelTask:task notice:YES message:@"非首次安装，任务取消"];
                return;
            }
            task.isFirst = @"1";
            [NSUserDefaults standardUserDefaults].currentTask = task;

        }
        
    }
}
- (void)commandTaskcancel{
    [self.timer invalidate];
    [NSUserDefaults standardUserDefaults].currentTask = nil;
}
- (void)detectTaskWithoutTimer{
    [self detectTask:self.timer];
}
@end
