//
//  NSString+base64.h
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/14.
//  Copyright © 2018年 luck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (base64)
- (NSString *)base64Decode;
- (NSString *)base64Encode;
- (NSString *)replaceString;
- (NSString *)URLDecode;
@end
