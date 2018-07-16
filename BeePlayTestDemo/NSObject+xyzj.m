//
//  NSObject+xyzj.m
//  BeePlayTestDemo
//
//  Created by perfay on 2018/7/16.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "NSObject+xyzj.h"
#import <Foundation/Foundation.h>
@implementation NSObject (xyzj)
- (void)webView:(id)unuse didCreateJavaScriptContext:(JSContext *)ctx forFrame:(id)frame{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidCreateContextNotification" object:ctx];
}
@end
