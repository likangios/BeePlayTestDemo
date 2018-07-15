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

@property(nonatomic,strong)  XYSocketServer *socketServer;

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,assign) BOOL isActive;

- (void)startServer;
- (void)configLocalHttpServer:(NSInteger)arg1;
- (void)initSever:(NSInteger)arg1;

@end

