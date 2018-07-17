//
//  AppDelegate.h
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/11.
//  Copyright © 2018年 luck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYSocketServer.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(retain, nonatomic) BackgroundTask *bgTask; // @synthesize bgTask=_bgTask;
@property(retain, nonatomic) NSTimer *timer; // @synthesize timer=_timer;

@property(copy, nonatomic) NSString *jumpStatus; // @synthesize jumpStatus=_jumpStatus;

@property(nonatomic) __weak UIViewController *adViewController; // @synthesize adViewController=_adViewController;
@property(nonatomic, getter=isAdShowing) _Bool adShowing; // @synthesize adShowing=_adShowing;
@property(nonatomic) CGFloat adLastShowTime; // @synthesize adLastShowTime=_adLastShowTime;

@property(nonatomic,strong)  XYSocketServer *socketServer;

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,assign) BOOL isActive;

@property(nonatomic,assign) BOOL hideADs;

- (void)startServer;
- (void)configLocalHttpServer:(NSInteger)arg1;
- (void)initSever:(NSInteger)arg1;
- (void)openSafari;
- (int)isScreenLocked;
- (BOOL)isLogin;
- (BOOL)isJailBreak;
- (void)registerPushForIOS8;
- (void)registerPush;

@end

