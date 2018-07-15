//
//  XYSocketServer.h
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/14.
//  Copyright © 2018年 luck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYSocketServer : NSObject
- (instancetype)initWithPort:(NSInteger)port;
- (void)start;
@end
