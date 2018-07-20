//
//  LSAP_model.m
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/15.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "LSAP_model.h"

@implementation LSAP_model
//- (_Bool)isAppStoreInstalled;
//- (id)description;
//- (_Bool)isHasInstalled;
//- (_Bool)isNotFirstInstalled;
//- (_Bool)isNowInstalling;
//- (_Bool)isNowInstalled;
//- (NSString *)identifier;
//- (id)initWithInstance:(id)arg1;

- (instancetype)initWithId:(NSString *)ID{
    self = [super init];
    if (self) {
        NSDictionary *funcation = [NSUserDefaults standardUserDefaults].function;
        _dictionary = funcation;
        NSString*ls_aw =  [funcation[@"LS_A_P"] base64Decode];
        NSString*default_W =  [funcation[@"application_P_F_I"] base64Decode];
        Class v7 = NSClassFromString(ls_aw);
        SEL  selector = NSSelectorFromString(default_W);
        IMP imp = [v7 methodForSelector:selector];
        NSObject * (*func)(id, SEL) = (void *)imp;
        _LSAP_model_instance =  func(v7, selector);
    }
    return self;
}
- (id)initWithInstance:(id)arg1{
    self = [super init];
    if (self) {
        NSDictionary *funcation = [NSUserDefaults standardUserDefaults].function;
        _dictionary = funcation;
        _LSAP_model_instance = arg1;
    }
    return self;
}
- (NSString *)identifier{
  
        NSString *application_I = [_dictionary[@"application_I"] base64Decode];
        NSString *identi =  (NSString *)[_LSAP_model_instance performSelector:NSSelectorFromString(application_I)];
        return identi;
}
- (BOOL)isNowInstalled{
    NSString *is_I = [_dictionary[@"is_I"] base64Decode];
    
    BOOL obj = (BOOL)[_LSAP_model_instance performSelector:NSSelectorFromString(is_I)];
    return obj;
}
- (BOOL)isNowInstalling{
    NSString *is_P = [_dictionary[@"is_P"] base64Decode];
    
    BOOL obj = (BOOL)[_LSAP_model_instance performSelector:NSSelectorFromString(is_P)];
    return obj;
}
- (BOOL)isNotFirstInstalled{
    NSString *is_P_R = [_dictionary[@"is_P_R"] base64Decode];
    
    if ([_LSAP_model_instance respondsToSelector:NSSelectorFromString(is_P_R)]) {
        BOOL obj = (BOOL)[_LSAP_model_instance performSelector:NSSelectorFromString(is_P_R)];
        return obj;
    }
    return NO;
}
- (BOOL)isHasInstalled{
    NSData *applistData = [MSKeyChain load:@"applist"];
  NSKeyedUnarchiver *unarchiver =   [[NSKeyedUnarchiver alloc] initForReadingWithData:applistData];
    NSArray *applist =  [unarchiver decodeObjectForKey:@"applist"];
    return [applist containsObject:self.identifier];
}
- (NSString *)description{
    return self.identifier;
}
- (BOOL)isAppStoreInstalled{
    NSString *source_A_I = [_dictionary[@"source_A_I"] base64Decode];
    NSString *store_F = [_dictionary[@"store_F"] base64Decode];
    NSString *signer_I = [_dictionary[@"signer_I"] base64Decode];
    BOOL  v10 = NO;
    if (![_LSAP_model_instance respondsToSelector:NSSelectorFromString(source_A_I)] &&
        ![_LSAP_model_instance respondsToSelector:NSSelectorFromString(store_F)] &&
        ![_LSAP_model_instance respondsToSelector:NSSelectorFromString(signer_I)]) {
        return YES;
    }
    if ([_LSAP_model_instance respondsToSelector:NSSelectorFromString(source_A_I)]) {
        NSString *v9 = [_LSAP_model_instance performSelector:NSSelectorFromString(source_A_I)];
        v10 =  [v9 isEqualToString:@"com.apple.AppStore"];
    }
    else{
        v10 = NO;
    }
    
    if ([_LSAP_model_instance respondsToSelector:NSSelectorFromString(store_F)]) {
        NSString *v11 = [_LSAP_model_instance performSelector:NSSelectorFromString(store_F)];
        if (v10) {
            v10 = YES;
        }
        else{
            v10 = v11.floatValue > 0.0;
        }
    }
    if ([_LSAP_model_instance respondsToSelector:NSSelectorFromString(signer_I)]) {
        NSString *v13 = [_LSAP_model_instance performSelector:NSSelectorFromString(signer_I)];
        if (v10) {
            v10 = YES;
        }
        else{
            v10 = [v13 isEqualToString:@"Apple iPhone OS Application Signing"];
        }
        
    }
    return v10;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self) {
        self.LSAP_model_instance = [aDecoder decodeObjectForKey:@"LSAP_model_instance"];
        self.dictionary = [aDecoder decodeObjectForKey:@"dictionary"];
    }
    return self;
}



- (void)encodeWithCoder:(NSCoder *)aCoder

{
    [aCoder encodeObject:self.LSAP_model_instance forKey:@"LSAP_model_instance"];
    
    [aCoder encodeObject:self.dictionary forKey:@"dictionary"];
    
}

@end
