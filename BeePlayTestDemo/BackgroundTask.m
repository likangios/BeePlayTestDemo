//
//  BackgroundTask.m
//  BeePlayTestDemo
//
//  Created by perfay on 2018/7/17.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "BackgroundTask.h"

@implementation BackgroundTask

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    }
    return self;
}
- (void)startBackgroundTask{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioInterrupted:) name:AVAudioSessionInterruptionNotification object:nil];
    [self playAudio];
}

- (void)stopBackgroundTask{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:nil];
    [self stopAudio];
}
- (void)audioInterrupted:(NSNotification *)noti{
    if (self.backgroundTaskIdentifier == UIBackgroundTaskInvalid) {
        [self startTask];
    }
}
- (void)startTask{
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    [self playAudio];
}
- (void)playAudio{
    
    if ([self.player isPlaying]|| !self.player) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [paths.firstObject stringByAppendingString:@"background.wav"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSData *data = [NSData dataWithBytes:"RIFF&" length:46];
            [data writeToFile:filePath atomically:YES];
        }
        NSURL *url = [NSURL fileURLWithPath:filePath];
        AVAudioSession *session =  [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback withOptions:1 error:nil];
        [session setActive:YES error:nil];
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        [self.player setVolume:0];
        self.player.numberOfLoops = -1;
        [self.player prepareToPlay];
        [self.player play];
    }
    
}
- (void)stopAudio{
    if ([self.player isPlaying]) {
        [self.player stop];
    }
    [[UIApplication sharedApplication] endBackgroundTask:UIBackgroundTaskInvalid];
}
@end
