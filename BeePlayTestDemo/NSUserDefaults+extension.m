//
//  NSUserDefaults+extension.m
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/14.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "NSUserDefaults+extension.h"

@implementation NSUserDefaults (extension)
@dynamic  updateURL;
@dynamic  firstAdHideStatus;
@dynamic  adHideStatus;
@dynamic  guidePics;
@dynamic  function;
@dynamic  guideStatus;
@dynamic  mainURL;
@dynamic  certURL;
@dynamic  directURL;
@dynamic lastTask;
@dynamic currentTask;
//@property(strong, nonatomic) TaskStatusBean *lastTask;
//@property(strong, nonatomic) TaskBean *currentTask;
@dynamic  shareStatus;
@dynamic  port;
@dynamic  v4_token_tag;
@dynamic  uid;
@dynamic  apply_tmout;
- (NSString *)apply_tmout{
    id obj = [self objectForKey:@"apply_tmout"];
    if (obj) {
        NSString *value =  [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        return value;
    }
    return nil;
}
- (void)setApply_tmout:(NSString *)apply_tmout{
    if (apply_tmout) {
        [self setValue:[NSKeyedArchiver  archivedDataWithRootObject:apply_tmout] forKey:@"apply_tmout"];
    }
    else{
        [self removeObjectForKey:@"apply_tmout"];
    }
    [self synchronize];
}
- (NSString *)uid{
    id obj = [self objectForKey:@"uid"];
    if (obj) {
        NSString *value =  [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        return value;
    }
    return nil;
}
-(void)setUid:(NSString *)uid{
    if (uid) {
        [self setValue:[NSKeyedArchiver  archivedDataWithRootObject:uid] forKey:@"uid"];
    }
    else{
        [self removeObjectForKey:@"uid"];
    }
    [self synchronize];
}
- (NSString *)v4_token_tag{
    id obj = [self objectForKey:@"v4_token_tag"];
    if (obj) {
        NSString *value =  [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        return value;
    }
    return nil;
}
- (void)setV4_token_tag:(NSString *)v4_token_tag{
    if (v4_token_tag) {
        [self setValue:[NSKeyedArchiver  archivedDataWithRootObject:v4_token_tag] forKey:@"v4_token_tag"];
    }
    else{
        [self removeObjectForKey:@"v4_token_tag"];
    }
    [self synchronize];
}
- (NSString *)port{
    id obj = [self objectForKey:@"port"];
    if (obj) {
        NSString *value =  [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        return value;
    }
    return nil;
}
- (void)setPort:(NSString *)port{
    if (port) {
        [self setValue:[NSKeyedArchiver  archivedDataWithRootObject:port] forKey:@"port"];
    }
    else{
        [self removeObjectForKey:@"port"];
    }
    [self synchronize];
}
- (NSDictionary *)shareStatus{
    id obj = [self objectForKey:@"shareStatus"];
    if (obj) {
        NSDictionary *value =  [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        return value;
    }
    return nil;
}
- (void)setShareStatus:(NSDictionary *)shareStatus{
    if (shareStatus) {
        [self setValue:[NSKeyedArchiver  archivedDataWithRootObject:shareStatus] forKey:@"shareStatus"];
    }
    else{
        [self removeObjectForKey:@"shareStatus "];
    }
    [self synchronize];
}
- (TaskStatusBean *)lastTask{
    id obj = [self objectForKey:@"lastTask"];
    if (obj) {
        TaskStatusBean *value =  [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        return value;
    }
    return nil;
}
- (void)setLastTask:(TaskStatusBean *)lastTask{
    if (lastTask) {
        [self setValue:[NSKeyedArchiver  archivedDataWithRootObject:lastTask] forKey:@"lastTask"];
    }
    else{
        [self removeObjectForKey:@"lastTask"];
    }
    [self synchronize];
}
- (NSString *)directURL{
    id obj = [self objectForKey:@"directURL"];
    if (obj) {
        NSString *value =  [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        return value;
    }
    return nil;
}
- (void)setDirectURL:(NSString *)directURL{
    if (directURL) {
        [self setValue:[NSKeyedArchiver  archivedDataWithRootObject:directURL] forKey:@"directURL"];
    }
    else{
        [self removeObjectForKey:@"directURL"];
    }
    [self synchronize];
}
- (NSString *)certURL{
    id obj = [self objectForKey:@"certURL"];
    if (obj) {
        NSString *value =  [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        return value;
    }
    return nil;
}
- (void)setCertURL:(NSString *)certURL{
    if (certURL) {
        [self setValue:[NSKeyedArchiver  archivedDataWithRootObject:certURL] forKey:@"certURL"];
    }
    else{
        [self removeObjectForKey:@"certURL"];
    }
    [self synchronize];
}
- (NSString *)mainURL{
    id obj = [self objectForKey:@"mainURL"];
    if (obj) {
        NSString *value =  [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        return value;
    }
    return nil;
}
- (void)setMainURL:(NSString *)mainURL{
    if (mainURL) {
        [self setValue:[NSKeyedArchiver  archivedDataWithRootObject:mainURL] forKey:@"mainURL"];
    }
    else{
        [self removeObjectForKey:@"mainURL"];
    }
    [self synchronize];
}
- (NSString *)guideStatus{
    id obj = [self objectForKey:@"guideStatus"];
    if (obj) {
        NSString *value =  [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        return value;
    }
    return nil;
}
- (void)setGuideStatus:(NSString *)guideStatus{
    if (guideStatus) {
        [self setValue:[NSKeyedArchiver  archivedDataWithRootObject:guideStatus] forKey:@"guideStatus"];
    }
    else{
        [self removeObjectForKey:@"guideStatus"];
    }
    [self synchronize];
}
- (NSDictionary *)function{
    id obj = [self objectForKey:@"function"];
    if (obj) {
        NSDictionary *value =  [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        return value;
    }
    return nil;
}
- (void)setFunction:(NSDictionary *)function{
    if (function) {
        [self setValue:[NSKeyedArchiver  archivedDataWithRootObject:function] forKey:@"function"];
    }
    else{
        [self removeObjectForKey:@"function"];
    }
    [self synchronize];
}
- (NSArray *)guidePics{
    id obj = [self objectForKey:@"guidePics"];
    if (obj) {
        NSArray *value =  [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        return value;
    }
    return nil;
}
- (void)setGuidePics:(NSArray *)guidePics{
    if (guidePics) {
        [self setValue:[NSKeyedArchiver  archivedDataWithRootObject:guidePics] forKey:@"guidePics"];
    }
    else{
        [self removeObjectForKey:@"guidePics"];
    }
    [self synchronize];
}
- (NSString *)adHideStatus{
    id obj = [self objectForKey:@"adHideStatus"];
    if (obj) {
        NSString *value =  [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        return value;
    }
    return nil;
}
- (void)setAdHideStatus:(NSString *)adHideStatus{
    if (adHideStatus) {
        [self setValue:[NSKeyedArchiver  archivedDataWithRootObject:adHideStatus] forKey:@"adHideStatus"];
    }
    else{
        [self removeObjectForKey:@"adHideStatus"];
    }
    [self synchronize];
}
- (NSString *)firstAdHideStatus{
    id obj = [self objectForKey:@"firstAdHideStatus"];
    if (obj) {
        NSString *value =  [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        return value;
    }
    return nil;
}
- (void)setFirstAdHideStatus:(NSString *)firstAdHideStatus{
    if (firstAdHideStatus) {
        [self setValue:[NSKeyedArchiver  archivedDataWithRootObject:firstAdHideStatus] forKey:@"firstAdHideStatus"];
    }
    else{
        [self removeObjectForKey:@"firstAdHideStatus"];
    }
    [self synchronize];
}
- (NSString *)updateURL{
    id obj = [self objectForKey:@"updateURL"];
    if (obj) {
        NSString *value =  [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        return value;
    }
    return nil;
}
- (void)setUpdateURL:(NSString *)updateURL{
    if (updateURL) {
        [self setValue:[NSKeyedArchiver  archivedDataWithRootObject:updateURL] forKey:@"updateURL"];
    }
    else{
        [self removeObjectForKey:@"updateURL"];
    }
    [self synchronize];
}
- (TaskBean *)currentTask{
    id obj = [self objectForKey:@"TaskBean"];
    if (obj) {
        TaskBean *value =  [NSKeyedUnarchiver unarchiveObjectWithData:obj];
        return value;
    }
    return nil;
}
- (void)setCurrentTask:(TaskBean *)currentTask{
    if (currentTask) {
        [self setValue:[NSKeyedArchiver  archivedDataWithRootObject:currentTask] forKey:@"TaskBean"];
    }
    else{
        [self removeObjectForKey:@"TaskBean"];
    }
    [self synchronize];
}

@end
