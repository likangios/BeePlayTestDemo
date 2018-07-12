//
//  AppDelegate.h
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/11.
//  Copyright © 2018年 luck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)startServer;
- (void)configLocalHttpServer:(NSInteger)arg1;
- (void)initSever:(NSInteger)arg1;

@end

