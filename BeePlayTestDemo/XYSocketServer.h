//
//  XYSocketServer.h
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/14.
//  Copyright © 2018年 luck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYSocketServer : NSObject<GCDAsyncSocketDelegate>
{
    NSObject<OS_dispatch_queue> *_socketQueue;

}
@property(nonatomic,strong) NSMutableArray *connectedSockets;

@property(nonatomic,assign) int port;
@property(nonatomic,strong) NSString *callback;

@property(retain, nonatomic) GCDAsyncSocket *listenSocket; // @synthesize listenSocket=_listenSocket;
@property(retain, nonatomic) NSTimer *timer; // @synthesize timer=_timer;

- (instancetype)initWithPort:(int)port;
- (void)start;
- (void)stop;
- (void)localNotification:(id)arg1 Action:(id)arg2;
- (id)parseUrl:(id)arg1 ForParams:(id *)arg2;
- (id)parseForParamsWithData:(id)arg1 ForCommond:(id *)arg2;
- (id)dictionaryToJson:(id)arg1;
- (void)commandCopyWithValue:(id)arg1;
- (void)alertView:(id)arg1 clickedButtonAtIndex:(long long)arg2;
- (void)responseBindDeviceStringtoSocket:(id)arg1;
- (void)responseBindDeviceRecevieToSocket:(id)arg1;
- (void)cancelTask:(NSString *)bundleId notice:(BOOL)notice message:(NSString *)msg;
- (void)completeTask:(id)arg1 checkFirst:(id)arg2;
- (void)openTask:(id)arg1 checkFirst:(id)arg2;
- (void)detectTaskAfteriOS11:(id)arg1;
- (void)detectTaskBeforeiOS11:(id)arg1;
- (void)detectTask:(id)arg1;
- (void)detectTaskWithoutTimer;
- (void)commandTaskcancel;
- (void)commandTaskstart;
- (void)response:(id)arg1 WithContentType:(id)arg2 ToSocket:(id)arg3;
- (void)response:(id)arg1 ToSocket:(id)arg2;
- (void)responseDictionary:(id)arg1 ToSocket:(id)arg2;
- (void)image:(id)arg1 didFinishSavingWithError:(id)arg2 contextInfo:(void *)arg3;
-(BOOL)onStartWithError:(NSError *)error;
@end
