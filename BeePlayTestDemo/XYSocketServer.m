//
//  XYSocketServer.m
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/14.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "XYSocketServer.h"
#import "AppDelegate.h"
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
    [[DTDSNetworkManager noBaseUrlShareInstance] requestGET:url parameters:@{} success:^(id responseObject) {
        if (self.listenSocket.isDisconnected) {
            NSLog(@"服务启动失败，端口被占用");
        }
    } failure:^(NSError *error) {
        if (![self onStartWithError:error]) {
            NSLog(@"服务启动失败，请重启应用");
        }
        
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
        NSLog(@"error.domain %@",err.domain);
        return NO;
    }
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
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    if (self.listenSocket != sock) {
        [self.connectedSockets removeObject:sock];
    }
}
//- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length{
//    return 10.0;
//}
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
    
    [sock writeData:headerData withTimeout:-1 tag:0];
    [sock writeData:fileData withTimeout:-1 tag:0];

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
    TaskBean *task =  [NSUserDefaults standardUserDefaults].currentTask;
    if (!arg1 || task) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        LSAP_model *lsap_model =  [[LSAP_model alloc]initWithId:task.bundleId];
        LSAW_model *lsaw_model= [[LSAW_model alloc]init];
        if ([NSDate date].timeIntervalSince1970 >= task.expiredAt.longLongValue) {
            [NSUserDefaults standardUserDefaults].currentTask = nil;
        }
        else{
            task.isFirst = @"1";

            if (!task.openTime.length) {
                if (delegate.isScreenLocked == 1 ) {
                    return;
                }
                [lsaw_model openAppWithIdentifier:task.bundleId];
                if(![lsaw_model openAppWithIdentifier:task.bundleId]){
                    [self openTask:task.bundleId checkFirst:task.checkFirst];
                    return;
                }
            }
            if (task.openTime.longLongValue < task.trialTime.longLongValue) {
                if (task.lastOpen.length) {
                    if (task.lastOpen.longLongValue <= task.timeInterval.longLongValue) {
                        return;
                    }
                }
                else{
                    task.lastOpen = [NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSince1970];
                    [NSUserDefaults standardUserDefaults].currentTask = task;
                    [lsaw_model openAppWithIdentifier:task.bundleId];
                    [self completeTask:task.bundleId checkFirst:task.checkFirst];
                    return;
                }
            }
            [self completeTask:task.bundleId checkFirst:task.checkFirst];
   
        }
    }
    [arg1 invalidate];
}
- (void)detectTaskBeforeiOS11:(NSTimer *)arg1{
    TaskBean *task =  [NSUserDefaults standardUserDefaults].currentTask;
    if (!arg1 || task) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

        if ([NSDate date].timeIntervalSince1970 >= task.expiredAt.longLongValue) {
            [NSUserDefaults standardUserDefaults].currentTask = nil;
            return;
        }
        LSAP_model *lsap_model =  [[LSAP_model alloc]initWithId:task.bundleId];
        LSAW_model *lsaw_model= [[LSAW_model alloc]init];
        if (lsap_model.isNowInstalling || lsap_model.isNowInstalled) {
            if (![task.isFirst isEqualToString:@"1"]) {
                if ([lsap_model isNotFirstInstalled]) {
                    [lsaw_model appsDataAppend:task.bundleId];
                    [self cancelTask:task.bundleId notice:YES message:@"非首次安装，任务取消"];
                    return;
                }
             
            }
            task.isFirst = @"1";
            [NSUserDefaults standardUserDefaults].currentTask = task;

        }
        if ([lsap_model isNowInstalled]) {
            if (![lsap_model isAppStoreInstalled]) {
                NSLog(@"非AppStore下载安装，任务已取消");
                return ;
            }
            if (!task.openTime.length) {
                if (delegate.isScreenLocked == 1 ) {
                    return;
                }
                [lsaw_model openAppWithIdentifier:task.bundleId];
                [self openTask:task.bundleId checkFirst:task.checkFirst];
                return;
            }
            if (task.openTime.longLongValue >= task.trialTime.longLongValue) {
                [self completeTask:task.bundleId checkFirst:task.checkFirst];
                return;
            }
            if (!task.lastOpen.length ||task.lastOpen.longLongValue > task.timeInterval.longLongValue) {
                task.lastOpen = [NSString stringWithFormat:@"%f",[NSDate date].timeIntervalSince1970];
                [NSUserDefaults standardUserDefaults].currentTask = task;
                [lsaw_model openAppWithIdentifier:task.bundleId];
                return;
            }
        }
    }
    [arg1 invalidate];
}
- (void)commandTaskcancel{
    [self.timer invalidate];
    [NSUserDefaults standardUserDefaults].currentTask = nil;
}
- (void)detectTaskWithoutTimer{
    [self detectTask:self.timer];
}
- (void)openTask:(NSString *)bundleId checkFirst:(NSString *)isfirst{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:bundleId,@"bundleId",@"open",@"method",@"1",@"status",isfirst,@"checkFirst", nil];
    [[DTDSNetworkManager shareInstance] requestPOST:@"/api/auth/checkapp" parameters:dic success:^(id responseObject) {
        NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        if ([dic isKindOfClass:[NSDictionary class]]) {
            TaskBean *task =  [NSUserDefaults standardUserDefaults].currentTask;
            if ([dic[@"push"] isEqualToString:@"1"]) {
                
                if (!task.displayName || !task.displayName.length) {
                    NSLog(@"开始计时");
                    [self localNotification:@"开始计时" Action:@"继续"];
                }
                else{
                    NSString *content = dic[@"content"];
                    [self localNotification:content Action:@"继续"];
                    if (task) {
                        NSDate *nowData = [NSDate date];
                        task.openTime = [NSString stringWithFormat:@"%f",nowData.timeIntervalSince1970];
                        task.lastOpen = [NSString stringWithFormat:@"%f",nowData.timeIntervalSince1970];
                        [NSUserDefaults standardUserDefaults].currentTask = task;
                    }
                }
            }
            else
            {
                [NSUserDefaults standardUserDefaults].currentTask = nil;
            }
        }
        else{
            [NSUserDefaults standardUserDefaults].currentTask = nil;
        }
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)completeTask:(NSString *)bundleId checkFirst:(NSString *)isfirst{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:bundleId,@"bundleId",@"open",@"method",@"1",@"status",isfirst,@"checkFirst", nil];
    [[DTDSNetworkManager shareInstance] requestPOST:@"/api/auth/checkapp" parameters:dic success:^(id responseObject) {
        NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        if ([dic isKindOfClass:[NSDictionary class]] && dic[@"push"]) {
            if ([dic[@"push"] isEqualToString:@"1"]) {
                NSString *content = dic[@"content"];
                if (content) {
                    [self localNotification:content Action:@"打开"];
                }
            }
            else{
                TaskStatusBean *statusBean = [[TaskStatusBean alloc]init];
                statusBean.status = @"1";
                statusBean.bundleid = bundleId;
                [NSUserDefaults standardUserDefaults].lastTask = statusBean;
                [NSUserDefaults standardUserDefaults].currentTask = nil;
                [self.timer invalidate];
            }
        }
        else{
            TaskBean *task =  [NSUserDefaults standardUserDefaults].currentTask;
            if (task.displayName.length) {
                NSString *tip = [NSString stringWithFormat:@"你 （%@）的【%@】已完成，快去领取奖励吧~",[NSUserDefaults standardUserDefaults].uid,task.displayName];
                [self localNotification:tip Action:@"打开"];
            }
            else{
                [self localNotification:@"当前任务已完成" Action:@"打开"];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)cancelTask:(NSString *)bundleId notice:(BOOL)notice message:(NSString *)msg{
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:bundleId,@"bundleId",@"open",@"method",@"1",@"status", nil];
    [[DTDSNetworkManager shareInstance] requestPOST:@"/api/auth/checkapp" parameters:dic success:^(id responseObject) {
        NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        if ([dic isKindOfClass:[NSDictionary class]] && dic[@"push"]) {
            if ([dic[@"push"] isEqualToString:@"1"]) {
                NSString *content = dic[@"content"];
                if (content) {
                    [self localNotification:content Action:@"打开"];
                }
                else{
                    [NSUserDefaults standardUserDefaults].currentTask = nil;
                    [NSUserDefaults standardUserDefaults].lastTask = nil;
                    [self.timer invalidate];
                }
            }
          
        }
        else{
            [self localNotification:msg Action:@"打开"];
            [NSUserDefaults standardUserDefaults].currentTask = nil;
            [NSUserDefaults standardUserDefaults].lastTask = nil;
            [self.timer invalidate];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)responseBindDeviceRecevieToSocket:(GCDAsyncSocket *)sock{
    
    NSData *fileData = [@"" dataUsingEncoding:NSUnicodeStringEncoding];
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
    
    [sock writeData:headerData withTimeout:-1 tag:0];
    [sock writeData:fileData withTimeout:-1 tag:0];
}
- (void)responseBindDeviceStringtoSocket:(GCDAsyncSocket *)sock{
    NSString *string = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>     <!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">     <plist version=\"1.0\">     <dict>     <key>PayloadContent</key>     <dict>     <key>URL</key>     <string>http://aso.allfree.cc/event/receive</string>     <key>DeviceAttributes</key>     <array>     <string>UDID</string>     <string>IMEI</string>     <string>ICCID</string>     <string>VERSION</string>     <string>PRODUCT</string>     </array>     </dict>     <key>PayloadOrganization</key>     <string>小鱼赚钱</string>     <key>PayloadDisplayName</key>     <string>设备绑定</string>  <!--安装时显示的标题-->     <key>PayloadVersion</key>     <integer>1</integer>     <key>PayloadUUID</key>     <string>3C4DC7D2-E475-3375-489C-0379887737A756</string>  <!--自己随机填写的唯一字符串-->     <key>PayloadIdentifier</key>     <string>com.xiaoyu.dev</string>     <key>PayloadDescription</key>     <string>本文件仅用来获取设备ID</string>   <!--描述-->     <key>PayloadType</key>     <string>Profile Service</string>     </dict>     </plist>";
    NSData *fileData = [string dataUsingEncoding:NSUnicodeStringEncoding];
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
    
    [sock writeData:headerData withTimeout:-1 tag:0];
    [sock writeData:fileData withTimeout:-1 tag:0];
}
- (void)commandCopyWithValue:(NSString *)url{
    UIPasteboard *pastBoart = [UIPasteboard generalPasteboard];
    pastBoart.string = [url URLDecode];
}
- (NSString *)dictionaryToJson:(NSDictionary *)dic{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:1 error:nil];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
- (id)parseForParamsWithData:(NSData *)data ForCommond:(NSError * _Nullable __autoreleasing *)error{
    NSMutableDictionary *muDic = [NSMutableDictionary dictionary];
    NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *array =  [string componentsSeparatedByString:@"\r\n"];
    if (array.count) {
        [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj hasPrefix:@"POST"]) {
               obj =  [obj stringByReplacingOccurrencesOfString:@"POST" withString:@"GET"];
            }
            NSString *subStr =  [obj substringFromIndex:5];
            NSRange  range = [subStr rangeOfString:@" HTTP/"];
            NSString *subsubStr =  [subStr substringToIndex:range.location];
            if ([subsubStr rangeOfString:@"?"].location != NSNotFound) {
//                NSString *v31 =  [subsubStr substringToIndex:[subsubStr rangeOfString:@"?"].location];
                NSString *v18 =  [subsubStr substringFromIndex:[subsubStr rangeOfString:@"?"].location +1];
                NSArray *array =  [v18 componentsSeparatedByString:@"&"];
                [array enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSArray *ar = [obj componentsSeparatedByString:@"="];
                    if (ar.count == 2) {
                        [muDic setObject:ar[0] forKey:[ar[1] URLDecode]];
                    }
                }];
            }
            else{
                
            }
        }];
    }
    self.callback = muDic[@"callback"];
    [muDic removeObjectForKey:@"callback"];
    [muDic removeObjectForKey:@"-"];
    if (!muDic.count) {
        return @"xyping";
    }
    return muDic;
}

#pragma mark - delegate
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket{
    [self.connectedSockets addObject:newSocket];
    NSString * connectedHost = [newSocket connectedHost];
    if ([connectedHost isEqualToString:@"127.0.0.1"]) {
        [newSocket readDataWithTimeout:-1 tag:0];
    }
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0) {
        [self afteriOS11Socket:sock didReadData:data withTag:tag];
    }
    else{
        [self beforiOS11Socket:sock didReadData:data withTag:tag];
    }
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    [sock readDataWithTimeout:-1 tag:tag];
}
- (void)afteriOS11Socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
}
- (void)beforiOS11Socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    AppDelegate *appdele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (!appdele.isLogin) {
        [self responseDictionary:@{@"result":@"4001",@"msg":@"钥匙初始化失败"} ToSocket:sock];
        return;
    }
    
    NSError *error;
   NSString *v11 = [self parseForParamsWithData:data ForCommond:&error];
    if ([v11 isEqualToString:@"xyping"]) {
        NSLog(@"dic ===========%@",v11);
    }
}
- (id)parseUrl:(NSString *)url ForParams:(NSError * _Nullable __autoreleasing *)error{
    return nil;
}


/**
 * Called when a socket has read in data, but has not yet completed the read.
 * This would occur if using readToData: or readToLength: methods.
 * It may be used to for things such as updating progress bars.
 **/
- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
    
}

/**
 * Called when a socket has written some data, but has not yet completed the entire write.
 * It may be used to for things such as updating progress bars.
 **/
- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag{
    
}
#pragma mark - notication
- (void)localNotification:(NSString *)content Action:(NSString *)action{
    AppDelegate *appdele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdele.jumpStatus = @"2";
    UILocalNotification *localNoti =  [[UILocalNotification alloc] init];
    localNoti.alertBody = content;
    localNoti.alertAction = action;
    localNoti.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNoti];
}
@end
