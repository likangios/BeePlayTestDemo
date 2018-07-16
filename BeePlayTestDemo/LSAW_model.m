//
//  LSAW_model.m
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/15.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "LSAW_model.h"
#import <objc/runtime.h>
#import "LSAP_model.h"

@implementation LSAW_model
//- (id)toJSON:(id)arg1;
//- (void)upload:(id)arg1;
//- (void)appsDataAppend:(id)arg1;
//- (void)appsDataUpdate;
//- (_Bool)openAppWithIdentifier:(id)arg1;
//- (id)allInstalledItems;
//- (id)allItems;
- (instancetype)init{
    self =  [super init];
    if (self) {
        NSDictionary *funcation = [NSUserDefaults standardUserDefaults].function;
        _dictionary = funcation;
        NSString*ls_aw =  [funcation[@"LS_A_W"] base64Decode];
        NSString*default_W =  [funcation[@"default_W"] base64Decode];
        Class v7 = NSClassFromString(ls_aw);
        SEL  selector = NSSelectorFromString(default_W);
        IMP imp = [v7 methodForSelector:selector];
        NSObject * (*func)(id, SEL) = (void *)imp;
       _LSAW_model_instance =  func(v7, selector);
    }
    return self;
}
- (NSArray *)allItems{
        NSString *all_A = [_dictionary[@"all_A"] base64Decode];
       NSArray *all_A_array =  [_LSAW_model_instance performSelector:NSSelectorFromString(all_A)];
    NSMutableArray *array = [NSMutableArray array];
        [all_A_array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LSAP_model *model = [[LSAP_model alloc]initWithInstance:obj];
            [array addObject:model];
        }];
    return array;
}
- (NSArray *)allInstalledItems{
    NSString *all_I_A = [_dictionary[@"all_I_A"] base64Decode];
    NSArray *all_I_A_array =  [_LSAW_model_instance performSelector:NSSelectorFromString(all_I_A)];
    NSMutableArray *array = [NSMutableArray array];
    [all_I_A_array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        LSAP_model *model = [[LSAP_model alloc]initWithInstance:obj];
        [array addObject:model];
    }];
    return array;
}
- (BOOL)openAppWithIdentifier:(NSString *)identifier{
    NSString *open_A_W_B_I = [_dictionary[@"open_A_W_B_I"] base64Decode];

   return [_LSAW_model_instance performSelector:NSSelectorFromString(open_A_W_B_I) withObject:identifier];
}
- (void)appsDataUpdate{
    [self appsDataAppend:0];
}
- (void)appsDataAppend:(id)arg1{
    id obj = [MSKeyChain load:@"applist"];
    NSMutableArray *v8 =  [[[NSKeyedUnarchiver alloc] initForReadingWithData:obj] decodeObjectForKey:@"applist"];
    [[[NSKeyedUnarchiver alloc] initForReadingWithData:obj] finishDecoding];
    
    if (!v8 ) {
        v8 = [NSMutableArray array];
    }
    [self.allInstalledItems enumerateObjectsUsingBlock:^(LSAP_model * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj.identifier hasPrefix:@"com.apple."] && ![v8 containsObject:obj]) {
            [v8 addObject:obj];
        }
    }];
     NSMutableData *muData = [[NSMutableData alloc]init];
   NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:muData];
    [archiver encodeObject:v8 forKey:@"applist"];
    [archiver finishEncoding];
    [MSKeyChain save:@"applist" data:muData];
    [self upload:v8[0]];
}
- (void)upload:(LSAP_model *)model{
    NSString *url = @"auth/collectapplist";
    NSString *json = [self toJSON:model];
    [[DTDSNetworkManager shareInstance] requestPOST:url parameters:@{@"applist_json":json} success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
}
- (NSString *)toJSON:(LSAP_model *)model{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:model options:1 error:nil];
    NSString *json = nil;
    if (jsonData) {
       json =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [json stringByReplacingOccurrencesOfString:@" " withString:@""];
        [json stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    return json;
}

@end
