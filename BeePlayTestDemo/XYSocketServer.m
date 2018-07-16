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

@end
