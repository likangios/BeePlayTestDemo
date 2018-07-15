//
//  TaskStatusBean.h
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/14.
//  Copyright © 2018年 luck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskStatusBean : NSObject
@property(copy, nonatomic) NSString *status; // @synthesize status=_status;
@property(copy, nonatomic) NSString *bundleid; // @synthesize bundleid=_bundleid;
- (id)initWithCoder:(id)arg1;
- (void)encodeWithCoder:(id)arg1;
@end
