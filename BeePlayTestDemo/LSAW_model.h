//
//  LSAW_model.h
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/15.
//  Copyright © 2018年 luck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSAW_model : NSObject
{
    NSObject *_LSAW_model_instance;
    NSDictionary *_dictionary;
}
- (id)toJSON:(id)arg1;
- (void)upload:(id)arg1;
- (void)appsDataAppend:(id)arg1;
- (void)appsDataUpdate;
- (BOOL)openAppWithIdentifier:(id)arg1;
- (NSArray *)allInstalledItems;
- (NSArray *)allItems;
- (id)init;

@end
