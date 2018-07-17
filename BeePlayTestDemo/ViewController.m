//
//  ViewController.m
//  BeePlayTestDemo
//
//  Created by luck on 2018/7/11.
//  Copyright © 2018年 luck. All rights reserved.
//

#import "ViewController.h"
//#import <objc/runtime.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "sys/utsname.h"
#import "DTDSNetworkManager.h"

#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import <AdSupport/AdSupport.h>
#import <WebKit/WebKit.h>
#import "AppDelegate.h"
#import "CertViewController.h"
#import "LSAW_model.h"
#import "LSAP_model.h"
#import "XYViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(BOOL)isLogin{
    if ([NSUserDefaults standardUserDefaults].uid.length) {
        return YES;
    }
    return NO;
}
- (void)systemError:(NSError *)error{
    
}
- (void)configError:(NSError *)error{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
        
    }
    else{
        
    }
    [self observeNetWork];
}
- (void)observeNetWork{
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status <= 1) {
            if ([NSStringFromClass([UIApplication sharedApplication].delegate.window.rootViewController.class) isEqualToString:@"AppleViewController"]) {
                [self config];
            }
        }
    }];
}
-  (void)config{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    DTDSNetworkManager  * manager = [DTDSNetworkManager shareInstance];
    NSString * urlString = @"/api/auth/config";
    NSMutableDictionary *tParams = [NSMutableDictionary dictionary];
    [manager requestPOST:urlString parameters:tParams success:^(id responseObject) {
        NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        [self saveDataWith:dic[@"return_data"]];
        
        NSLog(@"dic is %@",dic);
    } failure:^(NSError *error) {
        
    }];
}

- (void)saveDataWith:(NSDictionary *)dic{
    [NSUserDefaults standardUserDefaults].port = dic[@"port"];
    [NSUserDefaults standardUserDefaults].apply_tmout = dic[@"apply_tmout"];
    [NSUserDefaults standardUserDefaults].shareStatus = dic[@"share_status"];
    [NSUserDefaults standardUserDefaults].guidePics = dic[@"guide_pics"];
    [NSUserDefaults standardUserDefaults].mainURL = dic[@"cert2_url"];
    [NSUserDefaults standardUserDefaults].certURL = dic[@"cert_url"];
    [NSUserDefaults standardUserDefaults].shareStatus = dic[@"share_status"];
    [NSUserDefaults standardUserDefaults].apply_tmout = [NSString stringWithFormat:@"%@",dic[@"apply_tmout"]];
    [NSUserDefaults standardUserDefaults].updateURL = dic[@"update_url"];
    NSString *function = dic[@"function"];
    if (function) {
       NSString *replaceFunc =  [function replaceString];
        NSString *decodeFunc = [replaceFunc base64Decode];
        NSData *data =  [decodeFunc dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        [NSUserDefaults standardUserDefaults].function = dic;
    }
    [NSUserDefaults standardUserDefaults].adHideStatus = dic[@"ad_hide"];
    if ([NSUserDefaults standardUserDefaults].updateURL.length) {
        [self checkUpdate];
    }
    else{
        NSString *uid = [MSKeyChain load:@"udid"];
        if (uid.length) {
            [self handleJumpToWhichXYDestination];
        }
        else{
            [MSKeyChain delete:@"udid"];
            [self handleUDID];
        }
    }
    
    LSAW_model *model =  [[LSAW_model alloc]init];
    NSArray *item = model.allItems;
    
    [item enumerateObjectsUsingBlock:^(LSAP_model *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"identifier=%@,isAppStoreInstalled=%u,isHasInstalled=%ld,isNotFirstInstalled=%ld,isNowInstalling=%ld,isNowInstalled=%ld\n",obj.identifier,obj.isAppStoreInstalled,obj.isHasInstalled,obj.isNotFirstInstalled,obj.isNowInstalling,obj.isNowInstalled);
    }];
// 注册 tencentoauth  weibo
}

- (BOOL)isValidIdfa{
    
    return YES;
}
- (void)handleJumpToWhichXYDestination{
    if ([self isValidIdfa]) {
        AppDelegate *appdele =  (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdele.isActive = YES;
        [appdele.socketServer start];
        [self doLogin];
    }
    else{
        [self toSettingGuideViewController];
    }
}
- (void)handleUDID{
    CertViewController *cert = [[CertViewController alloc]init];
    [cert setBackAction:^{
        [self handleJumpToWhichXYDestination];
    }];
    [self presentViewController:cert animated:YES completion:NULL];
}
- (void)doLogin{
    NSString *url = @"/api/auth/login";
    [[DTDSNetworkManager shareInstance] requestPOST:url parameters:@{} success:^(id responseObject) {
        NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        if (dic[@"return_data"][@"uid"]) {
            [NSUserDefaults standardUserDefaults].uid = dic[@"return_data"][@"uid"];
            [NSUserDefaults standardUserDefaults].directURL = dic[@"return_data"][@"direct_url"];
            [NSUserDefaults standardUserDefaults].v4_token_tag = dic[@"return_data"][@"v4_token_tag"];
            // load ad
            [self loadAD];
        }
        [self toXYViewController];
    } failure:^(NSError *error) {
    }];
}
- (void)toXYViewController{
    XYViewController *xy = [[XYViewController alloc]init];
    [UIApplication sharedApplication].delegate.window.rootViewController = xy;
    [[UIApplication sharedApplication].delegate.window makeKeyWindow];
}
- (void)toSettingGuideViewController{
 
    
}
- (void)checkUpdate{
    
}
- (void)loadAD{
    
    if (![[NSUserDefaults standardUserDefaults].adHideStatus isEqualToString:@"1"]) {
        if ([[NSUserDefaults standardUserDefaults].firstAdHideStatus isEqualToString:@"1"]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSDictionary *infoDic = [NSBundle mainBundle].infoDictionary;
            [dic setValue:infoDic[@"CFBundleDisplayName"] forKey:@"appname"];
            [dic setValue:NSStringFromCGRect(UIScreen.mainScreen.bounds) forKey:@"density"];
            [dic setValue:[NSString stringWithFormat:@"%f",UIScreen.mainScreen.bounds.size.width] forKey:@"pwidth"];
            [dic setValue:[NSString stringWithFormat:@"%f",UIScreen.mainScreen.bounds.size.height] forKey:@"pheight"];
            [dic setValue:@"networkingStatesFromStatebar" forKey:@"network_states"];
            [[DTDSNetworkManager shareInstance] requestPOST:@"/api/auth/getadv" parameters:dic success:^(id responseObject) {
                NSData *jsonData = [responseObject dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
                NSArray *adsArray = dic[@"ads"];
                [self toAdvertisingViewController];
            } failure:^(NSError *error) {
                
            }];

        }
        else{
            [NSUserDefaults standardUserDefaults].firstAdHideStatus = @"1";
        }
        
    }
    
}
- (void)toAdvertisingViewController{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
