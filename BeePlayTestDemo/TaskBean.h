//
//  TaskBean.h
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/14.
//  Copyright © 2018年 luck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskBean : NSObject

@property(retain, nonatomic) NSString *checkFirst; // @synthesize checkFirst=_checkFirst;
@property(retain, nonatomic) NSString *lastOpen; // @synthesize lastOpen=_lastOpen;
@property(retain, nonatomic) NSString *openTime; // @synthesize openTime=_openTime;
@property(retain, nonatomic) NSString *timeInterval; // @synthesize timeInterval=_timeInterval;
@property(retain, nonatomic) NSString *isFirst; // @synthesize isFirst=_isFirst;
@property(retain, nonatomic) NSString *trialTime; // @synthesize trialTime=_trialTime;
@property(retain, nonatomic) NSString *expiredAt; // @synthesize expiredAt=_expiredAt;
@property(retain, nonatomic) NSString *bundleId; // @synthesize bundleId=_bundleId;
@property(retain, nonatomic) NSString *displayName; // @synthesize displayName=_displayName;
//- (id)initWithCoder:(id)arg1;
//- (void)encodeWithCoder:(id)arg1;

@end
