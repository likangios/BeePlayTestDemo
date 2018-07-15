//
//  NSUserDefaults+extension.h
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/14.
//  Copyright © 2018年 luck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskStatusBean.h"
#import "TaskBean.h"
@interface NSUserDefaults (extension)
@property(copy, nonatomic) NSString *updateURL;
@property(copy, nonatomic) NSString *firstAdHideStatus;
@property(copy, nonatomic) NSString *adHideStatus;
@property(strong, nonatomic) NSArray *guidePics;
@property(strong, nonatomic) NSDictionary *function;
@property(strong, nonatomic) NSString *guideStatus;
@property(copy, nonatomic) NSString *mainURL;
@property(copy, nonatomic) NSString *certURL;
@property(copy, nonatomic) NSString *directURL;
@property(strong, nonatomic) TaskStatusBean *lastTask;
@property(strong, nonatomic) TaskBean *currentTask;
@property(strong, nonatomic) NSDictionary *shareStatus;
@property(copy, nonatomic) NSString *port;
@property(copy, nonatomic) NSString *v4_token_tag;
@property(copy, nonatomic)  NSString *uid;
@property(copy, nonatomic) NSString *apply_tmout;

@end
