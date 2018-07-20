//
//  XYWebViewJSObject.m
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/15.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "XYWebViewJSObject.h"
#import "LSAW_model.h"
#import "LSAP_model.h"
#import "CertViewController.h"
#import "AppDelegate.h"
@implementation XYWebViewJSObject
- (NSArray *)allItems{
    return [[[LSAW_model alloc]init] allItems];
}
- (NSArray *)allInstalledItems{
    return [[[LSAW_model alloc]init] allInstalledItems];
}
- (void)openAppWithIdentifier:(NSString *)identifier{
    [[[LSAW_model alloc] init] openAppWithIdentifier:identifier];
}
- (void)appsDataUpdate{
    [[[LSAW_model alloc] init] appsDataUpdate];
}
- (void)appsDataAppend:(id)arg1{
    [[[LSAW_model alloc] init] appsDataAppend:arg1];
}
- (BOOL)isNowInstalledWithIdentifier:(id)arg1{
    //lsapmodel  需要修改
   return [[[LSAP_model alloc] initWithId:arg1] isNowInstalled];
}
- (BOOL)isNowInstallingWithIdentifier:(id)arg1{
    return [[[LSAP_model alloc] initWithId:arg1] isNowInstalling];
}
- (BOOL)isNotFirstInstalledWithIdentifier:(id)arg1{
    return [[[LSAP_model alloc] initWithId:arg1] isNotFirstInstalled];
}
- (BOOL)isHasInstalledWithIdentifier:(id)arg1{
    return [[[LSAP_model alloc] initWithId:arg1] isHasInstalled];
}
- (BOOL)isAppStoreInstalledWithIdentifier:(id)arg1{
    return [[[LSAP_model alloc] initWithId:arg1] isAppStoreInstalled];
}
- (id)xyservice:(id)arg1{
    return nil;
}
-(NSDictionary *)xyloadingpage:(NSDictionary *)dic{
    NSString *startbtn = dic[@"startbtn"];
    if (startbtn) {
        NSString *urlString = dic[@"url"];
        NSURL *URL;
        if (urlString) {
            NSString * target;
            if (dic[@"target"]) {
                target = dic[@"target"];
            }
            else{
                target = @"self";
            }
            if ([startbtn isEqualToString:@"daniel"]) {
                NSString *directURL = [NSUserDefaults standardUserDefaults].directURL;
                URL = [NSURL URLWithString:directURL];
                
            }
            if ([startbtn isEqualToString:@"page"]) {
                URL = [NSURL URLWithString:urlString];
            }
            if (![target isEqualToString:@"self"]&&
                ![target isEqualToString:@"blank"]&&
                [target isEqualToString:@"safari"]) {
                if ([[UIApplication sharedApplication] canOpenURL:URL]) {
                  BOOL open =   [[UIApplication sharedApplication] openURL:URL];
                    return @{@"state":@(open)};
                }
            }
            
        }
    }
    return @{};
}
//4d6db3a0509a6b674d110e54edf24ede09ab3b55
- (NSDictionary *)xycheckudid:(NSDictionary *)arg1{
    NSString *udid = [MSKeyChain load:@"udid"];
    NSDictionary *dic;
    if (udid.length) {
        
        dic = @{@"status":@"1",@"udid":udid};
    }
    else{
        dic = @{@"status":@"0",@"udid":@""};
    }
    return dic;
}
- (NSDictionary *)xycompletecert:(NSDictionary *)arg1{
    if ([self.viewController isKindOfClass:[NSClassFromString(@"CertViewController") class]]) {
        CertViewController *cert = (CertViewController *)self.viewController;
        [cert back];
    }
    return nil;
}
- (NSDictionary *)xycheckjumptosafari:(NSDictionary *)arg1{
    AppDelegate *appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (appDele.jumpStatus) {
        return @{@"status":appDele.jumpStatus};
    }
    return @{@"status":@"0"};
}
- (NSDictionary *)xyopensafari:(NSDictionary *)arg1{
    AppDelegate *appDele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDele  openSafari];
    return @{};
}
@end
