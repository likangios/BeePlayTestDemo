//
//  LKProxyDetection.h
//  BeePlayTestDemo
//
//  Created by perfay on 2018/7/17.
//  Copyright © 2018年 luck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKProxyDetection : NSObject

/**
 代理状态

 @return YES  没有设置代理 NO 设置代理
 */
-(BOOL)getProxyStatus;

@end
