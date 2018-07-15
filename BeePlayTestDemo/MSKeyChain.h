//
//  MSKeyChain.h
//  keyChainDemo
//
//  Created by mr.scorpion on 16/8/12.
//  Copyright © 2016年 mr.scorpion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSKeyChain : NSObject
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
