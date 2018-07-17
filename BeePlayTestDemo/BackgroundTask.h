//
//  BackgroundTask.h
//  BeePlayTestDemo
//
//  Created by perfay on 2018/7/17.
//  Copyright © 2018年 luck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface BackgroundTask : NSObject

@property(retain, nonatomic) AVAudioPlayer *player; // @synthesize player;
@property(copy, nonatomic) void (^expirationHandler)(void) ; // @synthesize expirationHandler;
@property(nonatomic)  long long backgroundTaskIdentifier; // @synthesize backgroundTaskIdentifier;
- (void)stopAudio;
- (void)playAudio;
- (void)startTask;
- (void)audioInterrupted:(id)arg1;
- (void)stopBackgroundTask;
- (void)startBackgroundTask;
- (instancetype)init;

@end
